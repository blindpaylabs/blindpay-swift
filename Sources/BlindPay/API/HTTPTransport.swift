//
//  HTTPTransport.swift
//  blindpay-swift
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Sends one HTTP request and returns the raw response.
///
/// The client calls the transport once per attempt; retries, timeouts and
/// error mapping happen above it. Inject your own (for tests, proxies or
/// metrics) through ``Configuration/transport``.
public protocol HTTPTransport: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

/// The default transport, backed by `URLSession`.
public struct URLSessionTransport: HTTPTransport {
    public let session: URLSession

    /// - Parameter session: The session to use. Defaults to an ephemeral
    ///   session (no cookies or URL cache are shared with the host app).
    public init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }

    public func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw BlindPayError.invalidResponse
        }
        return (data, http)
    }
}
