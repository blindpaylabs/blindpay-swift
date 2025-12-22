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
    private let receiverId: String
    
    init(apiClient: APIClient, instanceId: String, receiverId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.receiverId = receiverId
    }
    
    /// Lists all virtual accounts for a receiver
    ///
    /// This method fetches a list of all virtual accounts associated with the receiver.
    ///
    /// - Parameter receiverId: The unique identifier of the receiver
    /// - Returns: An `APIResponse` containing an array of virtual accounts
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").virtualAccounts.list(receiverId: "re_123")
    /// if let virtualAccounts = response.data {
    ///     for virtualAccount in virtualAccounts {
    ///         print("Virtual Account ID: \(virtualAccount.id)")
    ///         print("Token: \(virtualAccount.token.rawValue)")
    ///         print("Banking Partner: \(virtualAccount.bankingPartner.rawValue)")
    ///     }
    /// }
    /// ```
    public func list(receiverId: String) async throws -> APIResponse<VirtualAccountsResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/virtual-accounts",
            method: .get
        )
    }
    
    /// Retrieves a specific virtual account by ID
    ///
    /// This method fetches a specific virtual account by its ID. Returns `nil` in the response data if not found.
    ///
    /// - Parameters:
    ///   - receiverId: The unique identifier of the receiver
    ///   - id: The unique identifier of the virtual account
    /// - Returns: An `APIResponse` containing the virtual account, or `nil` if not found
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").virtualAccounts.get(receiverId: "re_123", id: "va_123")
    /// if let virtualAccount = response.data {
    ///     print("Virtual Account ID: \(virtualAccount.id)")
    ///     print("Token: \(virtualAccount.token.rawValue)")
    ///     print("ACH Account: \(virtualAccount.us.ach.accountNumber)")
    /// } else {
    ///     print("Virtual account not found")
    /// }
    /// ```
    public func get(receiverId: String, id: String) async throws -> APIResponse<VirtualAccountResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/virtual-accounts/\(id)",
            method: .get
        )
    }
    
    /// Creates a new virtual account for a receiver
    ///
    /// This method creates a new virtual account with the specified banking partner, blockchain wallet, and token.
    ///
    /// - Parameters:
    ///   - receiverId: The unique identifier of the receiver
    ///   - data: The input data containing the banking partner, blockchain wallet ID, and token
    /// - Returns: An `APIResponse` containing the created virtual account
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateVirtualAccountInput(
    ///     bankingPartner: .jpmorgan,
    ///     token: .usdc,
    ///     blockchainWalletId: "bw_123"
    /// )
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").virtualAccounts.create(receiverId: "re_123", data: input)
    /// if let virtualAccount = response.data {
    ///     print("Created virtual account: \(virtualAccount.id)")
    ///     print("Banking Partner: \(virtualAccount.bankingPartner.rawValue)")
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
    ///   - id: The unique identifier of the virtual account to update
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
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").virtualAccounts.update(receiverId: "re_123", id: "va_123", data: input)
    /// if let result = response.data {
    ///     print("Update successful: \(result.success)")
    /// }
    /// ```
    public func update(receiverId: String, id: String, data: UpdateVirtualAccountInput) async throws -> APIResponse<UpdateVirtualAccountResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/virtual-accounts/\(id)",
            method: .put,
            body: data
        )
    }
}

