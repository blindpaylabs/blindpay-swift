//
//  MockServer.swift
//  blindpay-swift
//
//  In-process HTTP mock built on URLProtocol. Each MockServer owns a unique
//  host, so tests running in parallel never see each other's requests.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import BlindPay

/// A request as the mock transport received it.
struct RecordedRequest: Sendable {
    let method: String
    let url: URL
    let headers: [String: String]
    let body: Data

    var path: String { url.path }

    /// Query items in wire order.
    var queryItems: [URLQueryItem] {
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
    }

    func header(_ name: String) -> String? {
        headers.first { $0.key.caseInsensitiveCompare(name) == .orderedSame }?.value
    }

    func jsonBody() throws -> [String: Any] {
        try JSONSerialization.jsonObject(with: body) as? [String: Any] ?? [:]
    }
}

struct MockResponse: Sendable {
    var status: Int = 200
    var headers: [String: String] = ["Content-Type": "application/json"]
    var body: Data = Data()

    static func json(_ data: Data, status: Int = 200) -> MockResponse {
        MockResponse(status: status, body: data)
    }
}

final class MockServer: @unchecked Sendable {
    let host = "mock-\(UUID().uuidString.lowercased()).test"
    let instanceId = "in_000000000000"
    private let lock = NSLock()
    private var recorded: [RecordedRequest] = []
    private let responder: @Sendable (RecordedRequest) -> MockResponse

    init(responder: @escaping @Sendable (RecordedRequest) -> MockResponse) {
        self.responder = responder
        MockRegistry.shared.register(self, for: host)
    }

    /// Answers attempt `n` with `responses[n]` (the last one repeats).
    convenience init(sequence responses: [MockResponse]) {
        let counter = Counter()
        self.init { _ in responses[min(counter.next(), responses.count - 1)] }
    }

    /// Always answers with the same response.
    convenience init(respondWith response: MockResponse) {
        self.init { _ in response }
    }

    deinit {
        MockRegistry.shared.unregister(host)
    }

    /// A client wired to this mock. Retries are on (as in production) but
    /// never really sleep; recorded sleeps are in ``sleeps``.
    var client: BlindPay { client() }

    func client(maxRetries: Int = 2, timeout: TimeInterval = 60) -> BlindPay {
        BlindPay(apiKey: "test_key", instanceId: instanceId, configuration: configuration(maxRetries: maxRetries, timeout: timeout))
    }

    func configuration(maxRetries: Int = 2, timeout: TimeInterval = 60) -> Configuration {
        Configuration(
            baseURL: "https://\(host)",
            timeout: timeout,
            maxRetries: maxRetries,
            transport: MockServer.transport,
            sleep: { [weak self] seconds in self?.recordSleep(seconds) },
            jitter: { 1.0 }
        )
    }

    /// A URLSession transport whose requests go to MockURLProtocol.
    static let transport: URLSessionTransport = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSessionTransport(session: URLSession(configuration: configuration))
    }()

    private var recordedSleeps: [TimeInterval] = []

    /// Every backoff the client asked for, in order.
    var sleeps: [TimeInterval] {
        lock.lock(); defer { lock.unlock() }
        return recordedSleeps
    }

    private func recordSleep(_ seconds: TimeInterval) {
        lock.lock(); defer { lock.unlock() }
        recordedSleeps.append(seconds)
    }

    var requests: [RecordedRequest] {
        lock.lock(); defer { lock.unlock() }
        return recorded
    }

    fileprivate func handle(_ request: RecordedRequest) -> MockResponse {
        lock.lock()
        recorded.append(request)
        lock.unlock()
        return responder(request)
    }
}

final class Counter: @unchecked Sendable {
    private let lock = NSLock()
    private var value = 0
    func next() -> Int {
        lock.lock(); defer { lock.unlock() }
        defer { value += 1 }
        return value
    }
}

private final class MockRegistry: @unchecked Sendable {
    static let shared = MockRegistry()
    private let lock = NSLock()
    private var servers: [String: MockServer] = [:]

    func register(_ server: MockServer, for host: String) {
        lock.lock(); defer { lock.unlock() }
        servers[host] = server
    }

    func unregister(_ host: String) {
        lock.lock(); defer { lock.unlock() }
        servers[host] = nil
    }

    func server(for host: String) -> MockServer? {
        lock.lock(); defer { lock.unlock() }
        return servers[host]
    }
}

final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let url = request.url, let host = url.host,
              let server = MockRegistry.shared.server(for: host) else {
            client?.urlProtocol(self, didFailWithError: URLError(.cannotConnectToHost))
            return
        }
        let recorded = RecordedRequest(
            method: request.httpMethod ?? "GET",
            url: url,
            headers: request.allHTTPHeaderFields ?? [:],
            // Inside a URLProtocol the body arrives as a stream, not httpBody.
            body: request.httpBody ?? Self.readAll(request.httpBodyStream)
        )
        let response = server.handle(recorded)
        let http = HTTPURLResponse(url: url, statusCode: response.status, httpVersion: "HTTP/1.1", headerFields: response.headers)!
        client?.urlProtocol(self, didReceive: http, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: response.body)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}

    private static func readAll(_ stream: InputStream?) -> Data {
        guard let stream = stream else { return Data() }
        stream.open()
        defer { stream.close() }
        var data = Data()
        var buffer = [UInt8](repeating: 0, count: 4096)
        while stream.hasBytesAvailable {
            let count = stream.read(&buffer, maxLength: buffer.count)
            if count <= 0 { break }
            data.append(buffer, count: count)
        }
        return data
    }
}

extension MockResponse {
    /// One of the shared error fixtures (Fixtures/errors/<name>.json).
    static func errorFixture(_ name: String) throws -> MockResponse {
        let fixture = try Fixtures.json(at: Fixtures.root.appendingPathComponent("errors/\(name).json"))
        var headers = fixture["headers"] as? [String: String] ?? ["Content-Type": "application/json"]
        headers["X-Request-Id"] = "req_\(name)"
        let body: Data
        if let raw = fixture["raw_body"] as? String {
            body = Data(raw.utf8)
        } else if let json = fixture["body"] {
            body = try JSONSerialization.data(withJSONObject: json)
        } else {
            body = Data()
        }
        return MockResponse(status: fixture["status"] as? Int ?? 500, headers: headers, body: body)
    }

    static func status(_ status: Int, retryAfter: String? = nil, body: String = #"{"success":false,"message":"error"}"#) -> MockResponse {
        var headers = ["Content-Type": "application/json"]
        if let retryAfter = retryAfter { headers["Retry-After"] = retryAfter }
        return MockResponse(status: status, headers: headers, body: Data(body.utf8))
    }

    static let ok = MockResponse(status: 200, body: Data(#"{"success":true}"#.utf8))
}

/// A transport that runs a scripted step per attempt, then defers to the mock.
final class ScriptedTransport: HTTPTransport, @unchecked Sendable {
    enum Step {
        case fail(URLError.Code)
        case hang
        case pass
    }

    private let lock = NSLock()
    private var steps: [Step]
    private(set) var attempts = 0

    init(_ steps: [Step]) { self.steps = steps }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let step: Step = {
            lock.lock(); defer { lock.unlock() }
            attempts += 1
            return steps.isEmpty ? .pass : steps.removeFirst()
        }()
        switch step {
        case .fail(let code):
            throw URLError(code)
        case .hang:
            // Honours cancellation, like URLSession does.
            try await Task.sleep(nanoseconds: 30_000_000_000)
            throw URLError(.unknown)
        case .pass:
            return try await MockServer.transport.send(request)
        }
    }
}

extension MockServer {
    /// A client whose transport runs `transport`'s script before reaching this mock.
    func client(transport: ScriptedTransport, maxRetries: Int = 2, timeout: TimeInterval = 60) -> BlindPay {
        let base = configuration(maxRetries: maxRetries, timeout: timeout)
        return BlindPay(apiKey: "test_key", instanceId: instanceId, configuration: Configuration(
            baseURL: base.baseURL, timeout: timeout, maxRetries: maxRetries, transport: transport,
            sleep: base.sleep, jitter: base.jitter))
    }
}
