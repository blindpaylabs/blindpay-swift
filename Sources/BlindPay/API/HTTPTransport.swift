//
//  HTTPTransport.swift
//  blindpay-swift
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Sends one HTTP request and returns the raw response.
///
/// The client calls the transport once per attempt; retries, timeouts and
/// error mapping happen above it. Inject your own (for tests, proxies or
/// metrics) through ``Configuration/transport``.
///
/// When the status line and headers arrived but the body then failed (or the
/// attempt was cancelled while reading it), throw
/// ``HTTPTransportError/incompleteResponse(_:underlying:)``. The client must
/// know the server answered: a mutation that got a response is never resent
/// automatically, because the server may already have run it.
public protocol HTTPTransport: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

/// Transport failures that carry what was received.
public enum HTTPTransportError: Error, Sendable {
    /// The response's status line and headers arrived, but reading the body
    /// failed or was cancelled.
    case incompleteResponse(HTTPURLResponse, underlying: Error)
}

/// The default transport, backed by `URLSession`.
///
/// It owns its session (built from `configuration`) so it can tell a failure
/// before any response from one while reading the body.
public final class URLSessionTransport: HTTPTransport, @unchecked Sendable {
    private let session: URLSession
    private let delegate: SessionDelegate

    /// - Parameter configuration: The session configuration. Defaults to an
    ///   ephemeral configuration (no cookies or URL cache shared with the
    ///   host app). The client enforces its own per-attempt timeout.
    public init(configuration: URLSessionConfiguration = .ephemeral) {
        let delegate = SessionDelegate()
        self.delegate = delegate
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }

    deinit {
        // The session retains its delegate until invalidated.
        session.finishTasksAndInvalidate()
    }

    public func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let handle = TaskHandle()
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                let task = session.dataTask(with: request)
                delegate.register(task, continuation: continuation)
                handle.start(task)
            }
        } onCancel: {
            handle.cancel()
        }
    }
}

/// Cancels the data task even when cancellation arrives before it exists.
private final class TaskHandle: @unchecked Sendable {
    private let lock = NSLock()
    private var task: URLSessionTask?
    private var cancelled = false

    func start(_ task: URLSessionTask) {
        lock.lock()
        self.task = task
        let cancelled = self.cancelled
        lock.unlock()
        if cancelled { task.cancel() } else { task.resume() }
    }

    func cancel() {
        lock.lock()
        cancelled = true
        let task = self.task
        lock.unlock()
        task?.cancel()
    }
}

private final class SessionDelegate: NSObject, URLSessionDataDelegate, @unchecked Sendable {
    private struct State {
        let continuation: CheckedContinuation<(Data, HTTPURLResponse), Error>
        var response: HTTPURLResponse?
        var data = Data()
    }

    private let lock = NSLock()
    private var states: [Int: State] = [:]

    func register(_ task: URLSessionTask, continuation: CheckedContinuation<(Data, HTTPURLResponse), Error>) {
        lock.lock()
        states[task.taskIdentifier] = State(continuation: continuation)
        lock.unlock()
    }

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        lock.lock()
        states[dataTask.taskIdentifier]?.response = response as? HTTPURLResponse
        lock.unlock()
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        lock.lock()
        states[dataTask.taskIdentifier]?.data.append(data)
        lock.unlock()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        lock.lock()
        let state = states.removeValue(forKey: task.taskIdentifier)
        lock.unlock()
        guard let state = state else { return }
        switch (error, state.response) {
        case let (error?, response?):
            state.continuation.resume(throwing: HTTPTransportError.incompleteResponse(response, underlying: error))
        case let (error?, nil):
            state.continuation.resume(throwing: error)
        case let (nil, response?):
            state.continuation.resume(returning: (state.data, response))
        case (nil, nil):
            state.continuation.resume(throwing: BlindPayError.invalidResponse)
        }
    }
}
