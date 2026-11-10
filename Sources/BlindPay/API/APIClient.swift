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
        self.userAgent = "blindpay-swift/\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")"
    }

    /// Sends a JSON request (or a body-less one).
    func request<T: Decodable & Sendable>(
        endpoint: String,
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
        endpoint: String,
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
        guard method != .get else { return nil }
        if let key = options?.idempotencyKey {
            guard !key.isEmpty else {
                throw BlindPayError.invalidRequest("idempotencyKey must not be empty")
            }
            guard key.count <= 255 else {
                throw BlindPayError.invalidRequest("idempotencyKey must be at most 255 characters")
            }
            return key
        }
        return configuration.maxRetries > 0 ? UUID().uuidString.lowercased() : nil
    }

    private func makeRequest(
        endpoint: String,
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

    private func makeURL(endpoint: String, queryParameters: QueryParameters?) throws -> URL {
        guard var components = URLComponents(string: "\(configuration.baseURL)\(endpoint)") else {
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
        var attempt = 0
        while true {
            try Task.checkCancellation()
            let canRetry = attempt < configuration.maxRetries
            do {
                let (data, response) = try await self.attempt(request, timeout: timeout)
                if (200..<300).contains(response.statusCode) {
                    return try decodeSuccess(data)
                }
                let error = makeAPIError(data: data, response: response, idempotencyKey: idempotencyKey)
                let outcome = RetryPolicy.Outcome.response(status: error.status, code: error.code, message: error.message)
                if canRetry, RetryPolicy.shouldRetry(method: method, isMultipart: isMultipart, hasIdempotencyKey: idempotencyKey != nil, outcome: outcome) {
                    try await configuration.sleep(RetryPolicy.delay(attempt: attempt, retryAfter: error.headers.value(for: "Retry-After"), jitter: configuration.jitter()))
                    attempt += 1
                    continue
                }
                return APIResponse(data: nil, error: error)
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
                case let blindPayError as BlindPayError:
                    throw blindPayError
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
    /// is only an idle timeout, so the transport races a timer task.
    private func attempt(_ request: URLRequest, timeout: TimeInterval) async throws -> (Data, HTTPURLResponse) {
        let transport = configuration.transport
        return try await withThrowingTaskGroup(of: (Data, HTTPURLResponse).self) { group in
            group.addTask { try await transport.send(request) }
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(max(0, timeout) * 1_000_000_000))
                throw AttemptTimeout()
            }
            defer { group.cancelAll() }
            guard let result = try await group.next() else { throw AttemptTimeout() }
            return result
        }
    }

    // MARK: - Decoding

    private struct Envelope<T: Decodable>: Decodable {
        let data: T
    }

    private func decodeSuccess<T: Decodable & Sendable>(_ data: Data) throws -> APIResponse<T> {
        // 204 / empty body / literal null: success with no data.
        let trimmed = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || trimmed == "null" {
            return APIResponse(data: nil, error: nil)
        }
        let decoder = JSONDecoder()
        do {
            return APIResponse(data: try decoder.decode(T.self, from: data), error: nil)
        } catch let directError {
            // Some legacy responses wrap the payload in { "data": ... }.
            if let envelope = try? decoder.decode(Envelope<T>.self, from: data) {
                return APIResponse(data: envelope.data, error: nil)
            }
            throw BlindPayError.decodingError(directError)
        }
    }

    private func makeAPIError(data: Data, response: HTTPURLResponse, idempotencyKey: String?) -> APIError {
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
            retryable: RetryPolicy.isRetryable(status: response.statusCode, code: body?.code, message: body?.message),
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
