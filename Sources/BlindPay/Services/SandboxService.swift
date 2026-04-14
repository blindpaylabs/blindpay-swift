//
//  SandboxService.swift
//  blindpay-swift
//

import Foundation

/// Service for managing sandbox items
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class SandboxService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String

    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }

    /// Lists all sandbox items for the instance
    ///
    /// This method fetches a list of all sandbox items associated with the instance.
    ///
    /// - Returns: An `APIResponse` containing an array of `Sandbox` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.sandbox.list()
    /// if let items = response.data {
    ///     for item in items {
    ///         print("\(item.name) - \(item.status.rawValue)")
    ///     }
    /// }
    /// ```
    public func list() async throws -> APIResponse<SandboxesResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/sandbox",
            method: .get
        )
    }

    /// Creates a new sandbox item
    ///
    /// This method creates a new sandbox item with the specified name and optional metadata.
    ///
    /// - Parameter data: The input data containing the item name and optional metadata
    /// - Returns: An `APIResponse` containing the created sandbox item
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateSandboxInput(
    ///     name: "My Sandbox Item",
    ///     metadata: ["key": "value"]
    /// )
    /// let response = try await blindPay.instances.sandbox.create(data: input)
    /// if let created = response.data {
    ///     print("Created sandbox item: \(created.id)")
    /// }
    /// ```
    public func create(data: CreateSandboxInput) async throws -> APIResponse<CreateSandboxResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/sandbox",
            method: .post,
            body: data
        )
    }

    /// Retrieves a specific sandbox item by ID
    ///
    /// This method fetches the details of a specific sandbox item.
    ///
    /// - Parameter id: The unique identifier of the sandbox item
    /// - Returns: An `APIResponse` containing the `Sandbox` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.sandbox.get(id: "sb_000000000000")
    /// if let item = response.data {
    ///     print("Sandbox item: \(item.name) - \(item.status.rawValue)")
    /// }
    /// ```
    public func get(id: String) async throws -> APIResponse<Sandbox> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/sandbox/\(id)",
            method: .get
        )
    }

    /// Updates an existing sandbox item
    ///
    /// This method updates the specified sandbox item. Only provided fields will be updated.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the sandbox item to update
    ///   - data: The update data containing the fields to update
    /// - Returns: An `APIResponse` containing the updated `Sandbox` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = UpdateSandboxInput(name: "Updated Name")
    /// let response = try await blindPay.instances.sandbox.update(id: "sb_000000000000", data: input)
    /// if let updated = response.data {
    ///     print("Updated sandbox item: \(updated.name)")
    /// }
    /// ```
    public func update(id: String, data: UpdateSandboxInput) async throws -> APIResponse<Sandbox> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/sandbox/\(id)",
            method: .patch,
            body: data
        )
    }

    /// Deletes a sandbox item
    ///
    /// This method permanently deletes a sandbox item. This action cannot be undone.
    ///
    /// - Parameter id: The unique identifier of the sandbox item to delete
    /// - Returns: An `APIResponse` containing the deletion success status
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.sandbox.delete(id: "sb_000000000000")
    /// if let result = response.data {
    ///     print("Deletion successful: \(result.success)")
    /// }
    /// ```
    public func delete(id: String) async throws -> APIResponse<DeleteSandboxResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/sandbox/\(id)",
            method: .delete
        )
    }
}
