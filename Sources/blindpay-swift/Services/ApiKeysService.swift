//
//  ApiKeysService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 31/10/25.
//

import Foundation

/// Service for managing API keys
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class ApiKeysService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }
    
    /// Lists all API keys for the instance
    ///
    /// This method fetches a list of all API keys associated with the instance.
    /// Note that the token is only returned when creating or getting a single key.
    ///
    /// - Returns: An `APIResponse` containing an array of `ApiKey` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.apiKeys.list()
    /// if let keys = response.data {
    ///     for key in keys {
    ///         print("\(key.name) - Last used: \(key.lastUsedAt ?? "Never")")
    ///     }
    /// }
    /// ```
    public func list() async throws -> APIResponse<ApiKeysResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/api-keys",
            method: .get
        )
    }
    
    /// Creates a new API key for the instance
    ///
    /// This method creates a new API key with the specified name and permissions.
    /// The token is only returned once when the key is created.
    ///
    /// - Parameter data: The input data containing the key name, permission, and optional IP whitelist
    /// - Returns: An `APIResponse` containing the created API key with its token
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateApiKeyInput(
    ///     name: "My API Key",
    ///     permission: .fullAccess,
    ///     ipWhitelist: ["192.168.1.1"]
    /// )
    /// let response = try await blindPay.instances.apiKeys.create(data: input)
    /// if let created = response.data {
    ///     print("Created key: \(created.id)")
    ///     print("Token: \(created.token)") // Save this token securely!
    /// }
    /// ```
    public func create(data: CreateApiKeyInput) async throws -> APIResponse<CreateApiKeyResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/api-keys",
            method: .post,
            body: data
        )
    }
    
    /// Retrieves a specific API key by ID
    ///
    /// This method fetches the details of a specific API key, including its token.
    ///
    /// - Parameter id: The unique identifier of the API key
    /// - Returns: An `APIResponse` containing the `ApiKey` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.apiKeys.get(id: "key_123")
    /// if let key = response.data {
    ///     print("Key name: \(key.name)")
    ///     print("Token: \(key.token)")
    /// }
    /// ```
    public func get(id: String) async throws -> APIResponse<ApiKey> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/api-keys/\(id)",
            method: .get
        )
    }
    
    /// Deletes an API key
    ///
    /// This method permanently deletes an API key. This action cannot be undone.
    ///
    /// - Parameter id: The unique identifier of the API key to delete
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.apiKeys.delete(id: "key_123")
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("API key deleted successfully")
    /// }
    /// ```
    public func delete(id: String) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/api-keys/\(id)",
            method: .delete
        )
    }
}

