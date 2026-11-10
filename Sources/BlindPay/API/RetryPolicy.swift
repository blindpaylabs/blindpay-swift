//
//  RetryPolicy.swift
//  blindpay-swift
//
//  The retry decision table shared by every BlindPay SDK (plan Appendix A2,
//  v3): mutations are never retried on 5xx, because the server releases the
//  idempotency key on 5xx and a retry would run the handler again.
//

import Foundation

enum RetryPolicy {
    /// What one attempt produced.
    enum Outcome {
        /// No response: connection, DNS or TLS failure, or the attempt timed out.
        case noResponse
        case response(status: Int, code: String?, message: String?)
    }

    /// 5xx codes the spec's error table classifies as terminal.
    static let terminalCodes: Set<String> = ["PAYINS_CARD_PAYMENT_PENDING"]

    static let inFlightMessage = "idempotency_key_in_flight"

    /// Rows 2-10 of the table (row 1, caller cancellation, is handled by the
    /// client before this is asked).
    static func shouldRetry(method: HTTPMethod, isMultipart: Bool, hasIdempotencyKey: Bool, outcome: Outcome) -> Bool {
        if isMultipart { return false }                                   // 2
        let isMutation = method != .get
        if isMutation && !hasIdempotencyKey { return false }              // 3
        switch outcome {
        case .noResponse:
            return true                                                   // 4
        case let .response(status, code, message):
            if status == 409 { return message == inFlightMessage }        // 5
            if status == 429 { return true }                              // 6
            if isMutation { return false }                                // 7 (and mutation 408)
            if status >= 500, let code = code, terminalCodes.contains(code) { return false } // 8
            return [408, 500, 502, 503, 504].contains(status)             // 9, 10
        }
    }

    /// Whether resending could succeed, independent of method: reported on
    /// ``APIError/retryable`` so callers can decide.
    static func isRetryable(status: Int, code: String?, message: String?) -> Bool {
        if status == 409 { return message == inFlightMessage }
        if status == 408 || status == 429 { return true }
        if status >= 500 {
            if let code = code, terminalCodes.contains(code) { return false }
            return true
        }
        return false
    }

    /// `min(8, 0.5 * 2^attempt) * jitter`, or `Retry-After` when it is an
    /// integer number of seconds no greater than 60.
    static func delay(attempt: Int, retryAfter: String?, jitter: Double) -> TimeInterval {
        if let raw = retryAfter?.trimmingCharacters(in: .whitespaces),
           !raw.isEmpty, raw.allSatisfy(\.isASCII), raw.allSatisfy(\.isNumber),
           let seconds = Int(raw), seconds <= 60 {
            return TimeInterval(seconds)
        }
        return min(8.0, 0.5 * pow(2.0, Double(attempt))) * jitter
    }
}
