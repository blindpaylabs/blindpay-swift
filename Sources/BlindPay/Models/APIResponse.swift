//
//  APIResponse.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Result of an API call: `data` on success, `error` when the API answered
/// with a non-2xx status. Transport failures are thrown as ``BlindPayError``.
public struct APIResponse<T: Sendable>: Sendable {
    public let data: T?
    public let error: APIError?

    internal init(data: T?, error: APIError?) {
        self.data = data
        self.error = error
    }

    /// Returns `data`, or throws `error` when the API returned one.
    /// A successful response with no body (e.g. 204) returns `nil`.
    public func get() throws -> T? {
        if let error = error { throw error }
        return data
    }
}

/// An error response from the BlindPay API.
///
/// Only `status` and `message` are always present. Never contains your API
/// key or the request body.
public struct APIError: Error, Sendable, Equatable {
    /// HTTP status code.
    public let status: Int

    /// Stable error code (e.g. `PAYOUTS_INSUFFICIENT_BALANCE`). Absent on
    /// idempotency errors and on non-JSON bodies.
    public let code: String?

    /// Short machine-readable message (e.g. `idempotency_key_in_flight`).
    public let message: String

    /// Human-readable explanation, when the API sends one.
    public let description: String?

    /// Field-level details. Defaults to empty.
    public let errors: [String]

    /// Server trace id (absent on auth and rate-limit errors).
    public let traceId: String?

    /// The `X-Request-Id` response header.
    public let requestId: String?

    /// The `Idempotency-Key` this request used (yours or auto-generated).
    /// Resend with the same key after checking state.
    public let idempotencyKey: String?

    /// Whether resending can succeed (408, 429, 5xx except terminal codes,
    /// and `idempotency_key_in_flight`). Mutations are never resent
    /// automatically on 5xx, because the server releases the idempotency key
    /// and would run the request again: look the resource up first, then
    /// resend with ``idempotencyKey``.
    public let retryable: Bool

    /// Response headers.
    public let headers: [String: String]

    public init(
        status: Int,
        code: String? = nil,
        message: String,
        description: String? = nil,
        errors: [String] = [],
        traceId: String? = nil,
        requestId: String? = nil,
        idempotencyKey: String? = nil,
        retryable: Bool = false,
        headers: [String: String] = [:]
    ) {
        self.status = status
        self.code = code
        self.message = message
        self.description = description
        self.errors = errors
        self.traceId = traceId
        self.requestId = requestId
        self.idempotencyKey = idempotencyKey
        self.retryable = retryable
        self.headers = headers
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        var text = "BlindPay API error \(status)"
        if let code = code { text += " \(code)" }
        text += ": \(description ?? message)"
        return text
    }
}

/// The JSON error envelope. Every field is optional; `errors` items may be
/// strings or objects.
struct APIErrorBody: Decodable {
    let code: String?
    let message: String?
    let description: String?
    let errors: [String]?
    let traceId: String?

    enum CodingKeys: String, CodingKey {
        case code, message, description, errors
        case traceId = "trace_id"
        case error
    }

    private struct Nested: Decodable { let message: String? }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try? container.decodeIfPresent(String.self, forKey: .code)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        traceId = try? container.decodeIfPresent(String.self, forKey: .traceId)
        // Legacy `{ "error": { "message": ... } }` envelopes are still accepted.
        message = (try? container.decodeIfPresent(String.self, forKey: .message))
            ?? (try? container.decodeIfPresent(Nested.self, forKey: .error))?.message
        if let items = try? container.decodeIfPresent([AnyCodable].self, forKey: .errors) {
            errors = items.map { item in
                if let string = item.value as? String { return string }
                let data = (try? JSONEncoder().encode(item)) ?? Data()
                return String(decoding: data, as: UTF8.self)
            }
        } else {
            errors = nil
        }
    }
}
