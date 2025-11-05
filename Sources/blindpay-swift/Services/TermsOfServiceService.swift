//
//  TermsOfServiceService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

/// Service for managing terms of service
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class TermsOfServiceService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }
    
    /// Initiates a new terms of service session
    ///
    /// This method creates a new terms of service session and returns a URL
    /// where the user can review and accept the terms.
    ///
    /// - Parameter data: The input data containing idempotency key, optional receiver ID, and optional redirect URL
    /// - Returns: An `APIResponse` containing the terms of service URL
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = InitiateTosInput(
    ///     idempotencyKey: "123e4567-e89b-12d3-a456-426614174000",
    ///     receiverId: "re_000000000000",
    ///     redirectUrl: "https://example.com/redirect"
    /// )
    /// let response = try await blindPay.instances.termsOfService.initiate(data: input)
    /// if let result = response.data {
    ///     print("TOS URL: \(result.url)")
    /// }
    /// ```
    public func initiate(data: InitiateTosInput) async throws -> APIResponse<InitiateTosResponse> {
        return try await apiClient.request(
            endpoint: "/v1/e/instances/\(instanceId)/tos",
            method: .post,
            body: data
        )
    }
    
    /// Accepts the terms of service
    ///
    /// This method accepts the terms of service using the session token
    /// obtained from the initiate endpoint.
    ///
    /// - Parameter data: The input data containing idempotency key, session, session token, and optional receiver ID
    /// - Returns: An `APIResponse` containing the terms of service acceptance details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = AcceptTosInput(
    ///     idempotencyKey: "123e4567-e89b-12d3-a456-426614174000",
    ///     session: "",
    ///     sessionToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    ///     receiverId: "re_000000000000"
    /// )
    /// let response = try await blindPay.instances.termsOfService.accept(data: input)
    /// if let result = response.data {
    ///     print("Accepted TOS ID: \(result.tosId)")
    ///     print("Version: \(result.version)")
    /// }
    /// ```
    public func accept(data: AcceptTosInput) async throws -> APIResponse<AcceptTosResponse> {
        return try await apiClient.request(
            endpoint: "/v1/e/tos",
            method: .put,
            body: data
        )
    }
}

