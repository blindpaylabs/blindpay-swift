//
//  RequestOptions.swift
//  blindpay-swift
//

import Foundation

/// Per-request options. Every service method takes an optional trailing
/// `options:` value. Options never change the shared client.
public struct RequestOptions: Sendable, Equatable {
    /// Sent as the `Idempotency-Key` header on POST/PUT/PATCH/DELETE JSON
    /// requests (ignored on GETs and file uploads). Must be 1-255 characters;
    /// an empty or longer key is rejected before the request is sent.
    ///
    /// When unset and retries are enabled, the client generates a UUID key
    /// before the first attempt so a retried mutation can't run twice. The
    /// key used is reported on errors (``APIError/idempotencyKey``) so you can
    /// resend deliberately with the same key.
    public var idempotencyKey: String?

    /// Total seconds for each attempt of this request; overrides
    /// ``Configuration/timeout``.
    public var timeout: TimeInterval?

    /// Extra headers for this request. They can't replace `Authorization`.
    public var headers: [String: String]

    public init(idempotencyKey: String? = nil, timeout: TimeInterval? = nil, headers: [String: String] = [:]) {
        self.idempotencyKey = idempotencyKey
        self.timeout = timeout
        self.headers = headers
    }
}
