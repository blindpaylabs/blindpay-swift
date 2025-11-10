//
//  VirtualAccountsService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Service for managing virtual accounts
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class VirtualAccountsService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }
    
    /// Retrieves the virtual account for a receiver
    ///
    /// This method fetches the virtual account associated with the specified receiver.
    ///
    /// - Parameter receiverId: The unique identifier of the receiver
    /// - Returns: An `APIResponse` containing the virtual account
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").virtualAccounts.get(receiverId: "re_123")
    /// if let virtualAccount = response.data {
    ///     print("Virtual Account ID: \(virtualAccount.id)")
    ///     print("Token: \(virtualAccount.token.rawValue)")
    ///     print("ACH Account: \(virtualAccount.us.ach.accountNumber)")
    /// }
    /// ```
    public func get(receiverId: String) async throws -> APIResponse<VirtualAccountResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/virtual-accounts",
            method: .get
        )
    }
    
    /// Creates a new virtual account for a receiver
    ///
    /// This method creates a new virtual account with the specified blockchain wallet and token.
    ///
    /// - Parameters:
    ///   - receiverId: The unique identifier of the receiver
    ///   - data: The input data containing the blockchain wallet ID and token
    /// - Returns: An `APIResponse` containing the created virtual account
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateVirtualAccountInput(
    ///     blockchainWalletId: "bw_123",
    ///     token: .usdc
    /// )
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").virtualAccounts.create(receiverId: "re_123", data: input)
    /// if let virtualAccount = response.data {
    ///     print("Created virtual account: \(virtualAccount.id)")
    ///     print("ACH Routing: \(virtualAccount.us.ach.routingNumber)")
    /// }
    /// ```
    public func create(receiverId: String, data: CreateVirtualAccountInput) async throws -> APIResponse<CreateVirtualAccountResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/virtual-accounts",
            method: .post,
            body: data
        )
    }
    
    /// Updates a virtual account for a receiver
    ///
    /// This method updates the virtual account with new blockchain wallet and token information.
    ///
    /// - Parameters:
    ///   - receiverId: The unique identifier of the receiver
    ///   - data: The input data containing the blockchain wallet ID and token
    /// - Returns: An `APIResponse` containing the update result
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = UpdateVirtualAccountInput(
    ///     blockchainWalletId: "bw_456",
    ///     token: .usdt
    /// )
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").virtualAccounts.update(receiverId: "re_123", data: input)
    /// if let result = response.data {
    ///     print("Update successful: \(result.success)")
    /// }
    /// ```
    public func update(receiverId: String, data: UpdateVirtualAccountInput) async throws -> APIResponse<UpdateVirtualAccountResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/virtual-accounts",
            method: .put,
            body: data
        )
    }
}

