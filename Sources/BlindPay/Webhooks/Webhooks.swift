//
//  Webhooks.swift
//  blindpay-swift
//
//  Standalone Svix webhook verification. Needs no API key or client.
//

import Foundation
#if canImport(CryptoKit)
import CryptoKit
#else
import Crypto
#endif

/// Verifies BlindPay webhooks and decodes them into typed events.
///
/// BlindPay signs webhooks with Svix. Verify the **raw** request body, exactly
/// as received: re-encoding parsed JSON changes the bytes and fails
/// verification. Deduplicate deliveries on the `svix-id` header, and never
/// log your `whsec_` secret. Every method has a `now:` overload that checks
/// the timestamp against a fixed time instead of the clock.
///
/// ```swift
/// // Vapor: req.body.data, req.headers; any framework works the same way.
/// let event = try Webhooks.constructEvent(payload: rawBody, headers: headers, secret: webhookSecret)
/// switch event {
/// case .payoutComplete(let payout), .payoutUpdate(let payout):
///     if payout.status == .failed { /* the payout failed */ }
/// default:
///     break
/// }
/// ```
public enum Webhooks {
    /// Accepted clock skew between the `svix-timestamp` header and now: 5 minutes.
    public static let defaultTolerance: TimeInterval = 300

    /// Returns whether `payload` carries a valid signature for `secret`.
    /// Never throws: a missing header, a malformed secret or timestamp, an
    /// expired timestamp or a wrong signature all return `false`.
    ///
    /// - Parameters:
    ///   - payload: The raw request body bytes.
    ///   - headers: The request headers (looked up case-insensitively).
    ///     `svix-id`, `svix-timestamp` and `svix-signature` are required;
    ///     the `webhook-*` equivalents are accepted too.
    ///   - secret: The endpoint secret (`whsec_...`), from
    ///     ``WebhookEndpointsService/getSecret(id:options:)``.
    ///   - tolerance: Maximum age (or clock skew) of the timestamp, in seconds.
    public static func verify(
        payload: Data,
        headers: [String: String],
        secret: String,
        tolerance: TimeInterval = defaultTolerance
    ) -> Bool {
        verify(payload: payload, headers: headers, secret: secret, tolerance: tolerance, now: Date())
    }

    /// ``verify(payload:headers:secret:tolerance:)`` for a body you hold as a
    /// string. Pass it exactly as received.
    public static func verify(
        payload: String,
        headers: [String: String],
        secret: String,
        tolerance: TimeInterval = defaultTolerance
    ) -> Bool {
        verify(payload: Data(payload.utf8), headers: headers, secret: secret, tolerance: tolerance)
    }

    /// Verifies the webhook, then decodes it into a ``WebhookEvent``.
    /// An event name this SDK version doesn't know returns
    /// ``WebhookEvent/unknown(type:payload:)`` instead of failing.
    ///
    /// - Throws: ``BlindPayError/webhookVerificationFailed`` when the
    ///   signature doesn't verify, ``BlindPayError/decodingError(_:status:idempotencyKey:)`` when a
    ///   verified payload doesn't decode.
    public static func constructEvent(
        payload: Data,
        headers: [String: String],
        secret: String,
        tolerance: TimeInterval = defaultTolerance
    ) throws -> WebhookEvent {
        try constructEvent(payload: payload, headers: headers, secret: secret, tolerance: tolerance, now: Date())
    }

    /// ``constructEvent(payload:headers:secret:tolerance:)`` for a body you
    /// hold as a string. Pass it exactly as received.
    public static func constructEvent(
        payload: String,
        headers: [String: String],
        secret: String,
        tolerance: TimeInterval = defaultTolerance
    ) throws -> WebhookEvent {
        try constructEvent(payload: Data(payload.utf8), headers: headers, secret: secret, tolerance: tolerance)
    }

    // MARK: - Fixed clock (tests, replays, the shared vectors)

    /// ``constructEvent(payload:headers:secret:tolerance:)`` checked against
    /// `now` instead of the current time: for tests, the shared webhook
    /// vectors, or re-verifying a stored delivery. `now` is truncated to whole
    /// seconds, the unit of `svix-timestamp`.
    public static func constructEvent(
        payload: Data,
        headers: [String: String],
        secret: String,
        tolerance: TimeInterval = defaultTolerance,
        now: Date
    ) throws -> WebhookEvent {
        guard verify(payload: payload, headers: headers, secret: secret, tolerance: tolerance, now: now) else {
            throw BlindPayError.webhookVerificationFailed
        }
        do {
            return try WebhookEvent.decode(from: payload)
        } catch {
            throw BlindPayError.decodingError(error)
        }
    }

    /// ``constructEvent(payload:headers:secret:tolerance:now:)`` for a body
    /// you hold as a string. Pass it exactly as received.
    public static func constructEvent(
        payload: String,
        headers: [String: String],
        secret: String,
        tolerance: TimeInterval = defaultTolerance,
        now: Date
    ) throws -> WebhookEvent {
        try constructEvent(payload: Data(payload.utf8), headers: headers, secret: secret, tolerance: tolerance, now: now)
    }

    /// ``verify(payload:headers:secret:tolerance:)`` for a body you hold as a
    /// string, checked against `now` instead of the current time.
    public static func verify(
        payload: String,
        headers: [String: String],
        secret: String,
        tolerance: TimeInterval = defaultTolerance,
        now: Date
    ) -> Bool {
        verify(payload: Data(payload.utf8), headers: headers, secret: secret, tolerance: tolerance, now: now)
    }

    /// ``verify(payload:headers:secret:tolerance:)`` checked against `now`
    /// instead of the current time: for tests, the shared webhook vectors, or
    /// re-verifying a stored delivery. `now` is truncated to whole seconds,
    /// the unit of `svix-timestamp`; the timestamp may be up to `tolerance`
    /// seconds before or after it.
    public static func verify(
        payload: Data,
        headers: [String: String],
        secret: String,
        tolerance: TimeInterval = defaultTolerance,
        now: Date
    ) -> Bool {
        guard let id = header("svix-id", "webhook-id", in: headers),
              let timestamp = header("svix-timestamp", "webhook-timestamp", in: headers),
              let signatures = header("svix-signature", "webhook-signature", in: headers) else {
            return false
        }
        guard !timestamp.isEmpty, timestamp.utf8.allSatisfy({ $0 >= 48 && $0 <= 57 }),
              let seconds = Double(timestamp),
              abs(now.timeIntervalSince1970.rounded(.down) - seconds) <= tolerance else {
            return false
        }
        guard let key = decodeSecret(secret) else { return false }

        var message = Data("\(id).\(timestamp).".utf8)
        message.append(payload)
        let mac = HMAC<SHA256>.authenticationCode(for: message, using: SymmetricKey(data: key))
        let expected = Array(Data(mac).base64EncodedString().utf8)

        for entry in signatures.split(separator: " ") {
            let parts = entry.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: false)
            guard parts.count == 2, parts[0] == "v1" else { continue }
            if constantTimeEquals(Array(parts[1].utf8), expected) { return true }
        }
        return false
    }

    private static func header(_ name: String, _ alias: String, in headers: [String: String]) -> String? {
        headers.value(for: name) ?? headers.value(for: alias)
    }

    /// Strips an optional `whsec_` prefix and base64-decodes the rest.
    private static func decodeSecret(_ secret: String) -> Data? {
        var base64 = secret.hasPrefix("whsec_") ? String(secret.dropFirst("whsec_".count)) : secret
        if base64.count % 4 != 0 { base64 += String(repeating: "=", count: 4 - base64.count % 4) }
        guard let key = Data(base64Encoded: base64), !key.isEmpty else { return nil }
        return key
    }

    /// Compares in time that depends only on the length, never on content.
    private static func constantTimeEquals(_ lhs: [UInt8], _ rhs: [UInt8]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        var difference: UInt8 = 0
        for index in lhs.indices { difference |= lhs[index] ^ rhs[index] }
        return difference == 0
    }
}
