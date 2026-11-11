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
    case decodingError(Error)
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
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
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
        default: return nil
        }
    }
}
