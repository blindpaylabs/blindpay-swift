//
//  Configuration.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Configuration for the BlindPay client.
///
/// A configured client is immutable and safe to share across tasks.
public struct Configuration: Sendable {
    /// Base URL for the API (endpoints add `/v1/...`). A custom URL receives
    /// your API key, so only point it at hosts you trust (tests, proxies).
    public let baseURL: String

    /// Total time allowed for one attempt (connect, headers and body), in
    /// seconds. Defaults to 60. A per-request ``RequestOptions/timeout``
    /// overrides it.
    public let timeout: TimeInterval

    /// How many times a failed request may be retried (so `maxRetries + 1`
    /// attempts in total). Defaults to 2; `0` disables retries and automatic
    /// idempotency keys.
    public let maxRetries: Int

    /// Sends each attempt. Defaults to ``URLSessionTransport``.
    public let transport: any HTTPTransport

    /// Sleeps between retries. Internal test seam; must honour cancellation.
    let sleep: @Sendable (TimeInterval) async throws -> Void

    /// Returns a jitter factor in `[0.5, 1.0]`. Internal test seam.
    let jitter: @Sendable () -> Double

    /// Default configuration
    public static let `default` = Configuration()

    public static let defaultBaseURL = "https://api.blindpay.com"

    /// Create a configuration.
    /// - Parameters:
    ///   - baseURL: Base URL for the API.
    ///   - timeout: Total seconds per attempt (default 60).
    ///   - maxRetries: Retries after the first attempt (default 2, `0` disables).
    ///   - transport: The HTTP transport (default `URLSessionTransport()`).
    public init(
        baseURL: String = Configuration.defaultBaseURL,
        timeout: TimeInterval = 60,
        maxRetries: Int = 2,
        transport: any HTTPTransport = URLSessionTransport()
    ) {
        self.init(baseURL: baseURL, timeout: timeout, maxRetries: maxRetries, transport: transport,
                  sleep: { try await Task.sleep(nanoseconds: UInt64(max(0, $0) * 1_000_000_000)) },
                  jitter: { Double.random(in: 0.5...1.0) })
    }

    init(
        baseURL: String,
        timeout: TimeInterval,
        maxRetries: Int,
        transport: any HTTPTransport,
        sleep: @escaping @Sendable (TimeInterval) async throws -> Void,
        jitter: @escaping @Sendable () -> Double
    ) {
        self.baseURL = baseURL
        self.timeout = timeout
        self.maxRetries = max(0, maxRetries)
        self.transport = transport
        self.sleep = sleep
        self.jitter = jitter
    }
}
