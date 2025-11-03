//
//  WebhookEndpointsService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

/// Service for managing webhook endpoints
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class WebhookEndpointsService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }
    
    /// Lists all webhook endpoints for the instance
    ///
    /// This method fetches a list of all webhook endpoints associated with the instance.
    ///
    /// - Returns: An `APIResponse` containing an array of `WebhookEndpoint` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.webhookEndpoints.list()
    /// if let endpoints = response.data {
    ///     for endpoint in endpoints {
    ///         print("\(endpoint.url) - Events: \(endpoint.events)")
    ///     }
    /// }
    /// ```
    public func list() async throws -> APIResponse<WebhookEndpointsResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/webhook-endpoints",
            method: .get
        )
    }
    
    /// Creates a new webhook endpoint for the instance
    ///
    /// This method creates a new webhook endpoint with the specified URL and events.
    ///
    /// - Parameter data: The input data containing the URL and events to subscribe to
    /// - Returns: An `APIResponse` containing the created webhook endpoint ID
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateWebhookEndpointInput(
    ///     url: "https://example.com/webhook",
    ///     events: [.receiverNew, .payoutNew]
    /// )
    /// let response = try await blindPay.instances.webhookEndpoints.create(data: input)
    /// if let created = response.data {
    ///     print("Created endpoint: \(created.id)")
    /// }
    /// ```
    public func create(data: CreateWebhookEndpointInput) async throws -> APIResponse<CreateWebhookEndpointResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/webhook-endpoints",
            method: .post,
            body: data
        )
    }
    
    /// Deletes a webhook endpoint
    ///
    /// This method permanently deletes a webhook endpoint. This action cannot be undone.
    ///
    /// - Parameter id: The unique identifier of the webhook endpoint to delete
    /// - Returns: An `APIResponse` with a success response indicating deletion
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.webhookEndpoints.delete(id: "we_123")
    /// if let result = response.data {
    ///     print("Deleted: \(result.success)")
    /// }
    /// ```
    public func delete(id: String) async throws -> APIResponse<DeleteWebhookEndpointResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/webhook-endpoints/\(id)",
            method: .delete
        )
    }
    
    /// Retrieves the secret key for a webhook endpoint
    ///
    /// This method fetches the secret key used to verify webhook signatures.
    ///
    /// - Parameter id: The unique identifier of the webhook endpoint
    /// - Returns: An `APIResponse` containing the webhook secret key
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.webhookEndpoints.getSecret(id: "we_123")
    /// if let secret = response.data {
    ///     print("Secret key: \(secret.key)")
    /// }
    /// ```
    public func getSecret(id: String) async throws -> APIResponse<WebhookEndpointSecret> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/webhook-endpoints/\(id)/secret",
            method: .get
        )
    }
    
    /// Retrieves the portal access URL for webhook endpoints
    ///
    /// This method fetches a URL that provides access to the webhook portal
    /// for managing webhook endpoints.
    ///
    /// - Returns: An `APIResponse` containing the portal access URL
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.webhookEndpoints.getPortalAccessUrl()
    /// if let portal = response.data {
    ///     print("Portal URL: \(portal.url)")
    /// }
    /// ```
    public func getPortalAccessUrl() async throws -> APIResponse<WebhookPortalAccess> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/webhook-endpoints/portal-access",
            method: .get
        )
    }
}

