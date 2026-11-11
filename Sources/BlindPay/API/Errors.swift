//
//  Errors.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Errors thrown by the client. API error responses are returned in
/// ``APIResponse/error`` instead (or thrown by ``APIResponse/get()``).
public enum BlindPayError: Error, LocalizedError, Sendable {
    case invalidURL
    case invalidResponse
    /// The request was rejected before it was sent (e.g. an empty or
    /// over-255-character idempotency key).
    case invalidRequest(String)
    case encodingError(Error)
    /// A body didn't decode. For an API response, `status` and the request's
    /// `idempotencyKey` are set: a 2xx that fails to decode still happened.
    case decodingError(Error, status: Int? = nil, idempotencyKey: String? = nil)
    /// The status line arrived but the body couldn't be read. The request
    /// reached the server (for a 2xx it succeeded); don't resend a mutation
    /// without checking its state first.
    case incompleteResponse(status: Int, underlying: Error, idempotencyKey: String?)
    /// The task was cancelled while waiting to retry after `lastError`.
    case cancelled(lastError: APIError)
    /// No response was received (connection, DNS or TLS failure). Carries the
    /// idempotency key the request used, if any, so you can resend it.
    case networkError(Error, idempotencyKey: String?)
    /// An attempt exceeded its total timeout and retries were exhausted.
    case timeout(idempotencyKey: String?)
    /// A webhook's signature, timestamp or headers didn't verify.
    case webhookVerificationFailed

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidRequest(let reason):
            return "Invalid request: \(reason)"
        case .encodingError(let error):
            return "Encoding error: \(error.localizedDescription)"
        case .decodingError(let error, let status, _):
            return "Decoding error\(status.map { " (HTTP \($0))" } ?? ""): \(error.localizedDescription)"
        case .incompleteResponse(let status, let error, _):
            return "HTTP \(status) response body could not be read: \(error.localizedDescription)"
        case .cancelled(let lastError):
            return "Cancelled while waiting to retry after: \(lastError.localizedDescription)"
        case .networkError(let error, _):
            return "Network error: \(error.localizedDescription)"
        case .timeout:
            return "The request timed out"
        case .webhookVerificationFailed:
            return "Webhook signature verification failed"
        }
    }

    /// The idempotency key the failed request used, if any.
    public var idempotencyKey: String? {
        switch self {
        case .networkError(_, let key), .timeout(let key): return key
        case .decodingError(_, _, let key), .incompleteResponse(_, _, let key): return key
        case .cancelled(let lastError): return lastError.idempotencyKey
        default: return nil
        }
    }
}
