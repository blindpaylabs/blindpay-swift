//
//  APIClient.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// API client for making network requests.
///
/// Each call serialises its body once, then runs up to
/// `configuration.maxRetries + 1` attempts through the transport, each bounded
/// by a total timeout. Retry decisions follow ``RetryPolicy``.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
internal final class APIClient: Sendable {
    private let apiKey: String
    private let instanceId: String
    private let configuration: Configuration
    private let userAgent: String

    init(apiKey: String, instanceId: String, configuration: Configuration) {
        self.apiKey = apiKey
        self.instanceId = instanceId
        self.configuration = configuration
        self.userAgent = "blindpay-swift/\(BlindPaySDK.version)"
    }

    /// Sends a JSON request (or a body-less one).
    func request<T: Decodable & Sendable>(
        endpoint: Endpoint,
        method: HTTPMethod = .get,
        body: (any Encodable)? = nil,
        queryParameters: QueryParameters? = nil,
        options: RequestOptions? = nil
    ) async throws -> APIResponse<T> {
        var bodyData: Data?
        if let body = body {
            do {
                bodyData = try JSONEncoder().encode(body)
            } catch {
                throw BlindPayError.encodingError(error)
            }
        }
        let idempotencyKey = try resolveIdempotencyKey(method: method, options: options)
        let request = try makeRequest(
            endpoint: endpoint,
            method: method,
            queryParameters: queryParameters,
            body: bodyData,
            contentType: bodyData == nil ? nil : "application/json",
            idempotencyKey: idempotencyKey,
            options: options
        )
        return try await send(request, method: method, isMultipart: false, idempotencyKey: idempotencyKey, options: options)
    }

    /// Sends a `multipart/form-data` request (used by file uploads). Never
    /// carries an idempotency key (the API skips multipart) and is never
    /// retried.
    func requestMultipart<T: Decodable & Sendable>(
        endpoint: Endpoint,
        method: HTTPMethod,
        form: MultipartFormData,
        queryParameters: QueryParameters? = nil,
        options: RequestOptions? = nil
    ) async throws -> APIResponse<T> {
        let request = try makeRequest(
            endpoint: endpoint,
            method: method,
            queryParameters: queryParameters,
            body: form.encoded(),
            contentType: form.contentType,
            idempotencyKey: nil,
            options: options
        )
        return try await send(request, method: method, isMultipart: true, idempotencyKey: nil, options: options)
    }

    // MARK: - Request building

    /// Validates a caller key, or generates one before the first attempt for
    /// a JSON mutation when retries are on.
    private func resolveIdempotencyKey(method: HTTPMethod, options: RequestOptions?) throws -> String? {
        if options?.headers.keys.contains(where: { $0.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }) == true {
            throw BlindPayError.invalidRequest("pass the idempotency key as RequestOptions.idempotencyKey, not as a header")
        }
        guard method != .get else { return nil }
        if let key = options?.idempotencyKey {
            // The server ignores an empty key, so it would look protected
            // without being so; padding would make retries look like
            // different keys.
            guard !key.isEmpty, key.trimmingCharacters(in: .whitespacesAndNewlines) == key else {
                throw BlindPayError.invalidRequest("idempotencyKey must not be empty or padded with whitespace")
            }
            // The server measures the key as a JavaScript string (UTF-16 units).
            guard key.utf16.count <= 255 else {
                throw BlindPayError.invalidRequest("idempotencyKey must be at most 255 characters (UTF-16 code units)")
            }
            return key
        }
        return configuration.maxRetries > 0 ? UUID().uuidString.lowercased() : nil
    }

    private func makeRequest(
        endpoint: Endpoint,
        method: HTTPMethod,
        queryParameters: QueryParameters?,
        body: Data?,
        contentType: String?,
        idempotencyKey: String?,
        options: RequestOptions?
    ) throws -> URLRequest {
        var request = URLRequest(url: try makeURL(endpoint: endpoint, queryParameters: queryParameters))
        request.httpMethod = method.rawValue
        request.httpBody = body
        // Backstop only: the total per-attempt timeout is enforced in attempt().
        request.timeoutInterval = options?.timeout ?? configuration.timeout
        for (name, value) in options?.headers ?? [:] {
            request.setValue(value, forHTTPHeaderField: name)
        }
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(idempotencyKey, forHTTPHeaderField: "Idempotency-Key")
        return request
    }

    private func makeURL(endpoint: Endpoint, queryParameters: QueryParameters?) throws -> URL {
        guard var components = URLComponents(string: configuration.baseURL + endpoint.path) else {
            throw BlindPayError.invalidURL
        }
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            components.queryItems = queryParameters.queryItems
            // URLComponents leaves "+" alone, which servers read as a space.
            components.percentEncodedQuery = components.percentEncodedQuery?
                .replacingOccurrences(of: "+", with: "%2B")
        }
        guard let url = components.url else {
            throw BlindPayError.invalidURL
        }
        return url
    }

    // MARK: - Sending

    private struct AttemptTimeout: Error {}

    private func send<T: Decodable & Sendable>(
        _ request: URLRequest,
        method: HTTPMethod,
        isMultipart: Bool,
        idempotencyKey: String?,
        options: RequestOptions?
    ) async throws -> APIResponse<T> {
        let timeout = options?.timeout ?? configuration.timeout
        guard timeout > 0, timeout.isFinite else {
            throw BlindPayError.invalidRequest("timeout must be a positive number of seconds")
        }
        var attempt = 0
        while true {
            try Task.checkCancellation()
            let canRetry = attempt < configuration.maxRetries
            do {
                let (data, response) = try await self.attempt(request, timeout: timeout)
                if (200..<300).contains(response.statusCode) {
                    return try decodeSuccess(data, status: response.statusCode, idempotencyKey: idempotencyKey)
                }
                let error = makeAPIError(data: data, response: response, method: method, idempotencyKey: idempotencyKey)
                let outcome = RetryPolicy.Outcome.response(status: error.status, code: error.code, message: error.message)
                if canRetry, RetryPolicy.shouldRetry(method: method, isMultipart: isMultipart, hasIdempotencyKey: idempotencyKey != nil, outcome: outcome) {
                    try await sleepBeforeRetry(RetryPolicy.delay(attempt: attempt, retryAfter: error.headers.value(for: "Retry-After"), jitter: configuration.jitter()), after: error)
                    attempt += 1
                    continue
                }
                return APIResponse(data: nil, error: error)
            } catch HTTPTransportError.incompleteResponse(let response, let underlying) {
                if Task.isCancelled { throw CancellationError() }
                // The server answered, so classify by its status. A mutation is
                // never resent: on a 5xx the server has released the key and
                // would run it again. A GET is resent for a 2xx or a retryable
                // status, never for another 4xx.
                let status = response.statusCode
                let getMayRetry = (200..<300).contains(status)
                    || RetryPolicy.shouldRetry(method: .get, isMultipart: false, hasIdempotencyKey: false, outcome: .response(status: status, code: nil, message: nil))
                if method == .get, !isMultipart, canRetry, getMayRetry {
                    try await configuration.sleep(RetryPolicy.delay(attempt: attempt, retryAfter: nil, jitter: configuration.jitter()))
                    attempt += 1
                    continue
                }
                if status >= 400 {
                    return APIResponse(data: nil, error: makeAPIError(data: Data(), response: response, method: method, idempotencyKey: idempotencyKey))
                }
                throw BlindPayError.incompleteResponse(status: status, underlying: underlying, idempotencyKey: idempotencyKey)
            } catch let error as BlindPayError {
                // Raised by this client (decoding, cancellation after an API
                // error, ...): never retried.
                throw error
            } catch {
                if error is CancellationError || Task.isCancelled { throw CancellationError() }
                let failure: BlindPayError
                switch error {
                case is AttemptTimeout:
                    failure = .timeout(idempotencyKey: idempotencyKey)
                case let urlError as URLError where urlError.code == .timedOut:
                    failure = .timeout(idempotencyKey: idempotencyKey)
                case let urlError as URLError:
                    failure = .networkError(urlError, idempotencyKey: idempotencyKey)
                default:
                    failure = .networkError(error, idempotencyKey: idempotencyKey)
                }
                if canRetry, RetryPolicy.shouldRetry(method: method, isMultipart: isMultipart, hasIdempotencyKey: idempotencyKey != nil, outcome: .noResponse) {
                    try await configuration.sleep(RetryPolicy.delay(attempt: attempt, retryAfter: nil, jitter: configuration.jitter()))
                    attempt += 1
                    continue
                }
                throw failure
            }
        }
    }

    /// One attempt, bounded by a total timeout. `URLRequest.timeoutInterval`
    /// is only an idle timeout, so a timer cancels the transport. The
    /// transport's own outcome is still awaited, so a timeout that hits while
    /// the body is being read surfaces as an incomplete response (the server
    /// answered), not as "no response".
    private func attempt(_ request: URLRequest, timeout: TimeInterval) async throws -> (Data, HTTPURLResponse) {
        let transport = configuration.transport
        let timedOut = Flag()
        let send = Task { try await transport.send(request) }
        let timer = Task {
            try await Task.sleep(nanoseconds: UInt64(max(0, timeout) * 1_000_000_000))
            timedOut.set()
            send.cancel()
        }
        defer { timer.cancel() }
        do {
            return try await withTaskCancellationHandler {
                try await send.value
            } onCancel: {
                send.cancel()
            }
        } catch let error as HTTPTransportError {
            throw error
        } catch {
            if timedOut.isSet { throw AttemptTimeout() }
            throw error
        }
    }

    private final class Flag: @unchecked Sendable {
        private let lock = NSLock()
        private var value = false
        func set() { lock.lock(); value = true; lock.unlock() }
        var isSet: Bool { lock.lock(); defer { lock.unlock() }; return value }
    }

    // MARK: - Decoding

    /// Sleeps before a retry that follows an API error; a cancellation during
    /// the wait surfaces that error instead of a bare CancellationError.
    private func sleepBeforeRetry(_ seconds: TimeInterval, after apiError: APIError) async throws {
        do {
            try await configuration.sleep(seconds)
        } catch {
            throw BlindPayError.cancelled(lastError: apiError)
        }
        if Task.isCancelled { throw BlindPayError.cancelled(lastError: apiError) }
    }

    private func decodeSuccess<T: Decodable & Sendable>(_ data: Data, status: Int, idempotencyKey: String?) throws -> APIResponse<T> {
        // 204 / empty body / literal null: success with no data.
        let trimmed = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || trimmed == "null" {
            return APIResponse(data: nil, error: nil)
        }
        do {
            return APIResponse(data: try JSONDecoder().decode(T.self, from: data), error: nil)
        } catch {
            throw BlindPayError.decodingError(error, status: status, idempotencyKey: idempotencyKey)
        }
    }

    private func makeAPIError(data: Data, response: HTTPURLResponse, method: HTTPMethod, idempotencyKey: String?) -> APIError {
        var headers: [String: String] = [:]
        for (name, value) in response.allHeaderFields {
            headers[String(describing: name)] = String(describing: value)
        }
        // Non-JSON bodies (e.g. a proxy's HTML 502) still produce an APIError.
        let body = try? JSONDecoder().decode(APIErrorBody.self, from: data)
        let message = body?.message ?? HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        return APIError(
            status: response.statusCode,
            code: body?.code,
            message: message,
            description: body?.description,
            errors: body?.errors ?? [],
            traceId: body?.traceId,
            requestId: headers.value(for: "X-Request-Id"),
            idempotencyKey: idempotencyKey,
            retryable: RetryPolicy.isRetryable(method: method, hasIdempotencyKey: idempotencyKey != nil,
                                               status: response.statusCode, code: body?.code, message: body?.message),
            headers: headers
        )
    }
}

extension Dictionary where Key == String, Value == String {
    /// Case-insensitive header lookup.
    func value(for header: String) -> String? {
        first { $0.key.caseInsensitiveCompare(header) == .orderedSame }?.value
    }
}

/// HTTP methods
internal enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// Never expose the API key through `dump`, `Mirror` or string descriptions.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension APIClient: CustomReflectable, CustomStringConvertible, CustomDebugStringConvertible {
    var customMirror: Mirror {
        Mirror(self, children: ["apiKey": "<redacted>", "baseURL": configuration.baseURL], displayStyle: .class)
    }

    var description: String { "APIClient(baseURL: \(configuration.baseURL), apiKey: <redacted>)" }

    var debugDescription: String { description }
}
