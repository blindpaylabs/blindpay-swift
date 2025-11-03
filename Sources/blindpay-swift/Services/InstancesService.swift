//
//  InstancesService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 31/10/25.
//

import Foundation

/// Service for managing instance members and settings
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class InstancesService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }
    
    /// Retrieves all members of the instance
    ///
    /// This method fetches a list of all members associated with the instance,
    /// including their roles, contact information, and membership details.
    ///
    /// - Returns: An `APIResponse` containing an array of `InstanceMember` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.getMembers()
    /// if let members = response.data {
    ///     for member in members {
    ///         print("\(member.firstName) \(member.lastName) - \(member.role.rawValue)")
    ///     }
    /// }
    /// ```
    public func getMembers() async throws -> APIResponse<InstanceMembersResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/members",
            method: .get
        )
    }
    
    /// Updates the instance with new data
    ///
    /// This method updates the instance's name and optionally sets a redirect URL
    /// for receiver invites.
    ///
    /// - Parameter data: The update data containing the instance name and optional redirect URL
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let updateData = UpdateInstanceInput(
    ///     name: "My Updated Instance",
    ///     receiverInviteRedirectUrl: "https://example.com/redirect"
    /// )
    /// let response = try await blindPay.instances.update(data: updateData)
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Instance updated successfully")
    /// }
    /// ```
    public func update(data: UpdateInstanceInput) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)",
            method: .put,
            body: data
        )
    }
    
    /// Deletes the instance
    ///
    /// This method permanently deletes the instance. This action cannot be undone.
    ///
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.delete()
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Instance deleted successfully")
    /// }
    /// ```
    public func delete() async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)",
            method: .delete
        )
    }
}

