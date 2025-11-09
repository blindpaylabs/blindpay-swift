//
//  OfframpWalletsService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Service for managing offramp wallets
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class OfframpWalletsService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }
    
    /// Lists all offramp wallets for a bank account
    ///
    /// This method fetches a list of all offramp wallets associated with the specified bank account.
    ///
    /// - Parameters:
    ///   - receiverId: The unique identifier of the receiver
    ///   - bankAccountId: The unique identifier of the bank account
    /// - Returns: An `APIResponse` containing an array of `OfframpWallet` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").bankAccounts.offrampWallets.list(receiverId: "re_123", bankAccountId: "ba_123")
    /// if let wallets = response.data {
    ///     for wallet in wallets {
    ///         print("\(wallet.address) - \(wallet.network.rawValue)")
    ///     }
    /// }
    /// ```
    public func list(receiverId: String, bankAccountId: String) async throws -> APIResponse<OfframpWalletsResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/bank-accounts/\(bankAccountId)/offramp-wallets",
            method: .get
        )
    }
    
    /// Creates a new offramp wallet for a bank account
    ///
    /// This method creates a new offramp wallet with the specified network and optional external ID.
    ///
    /// - Parameters:
    ///   - receiverId: The unique identifier of the receiver
    ///   - bankAccountId: The unique identifier of the bank account
    ///   - data: The input data containing the network and optional external ID
    /// - Returns: An `APIResponse` containing the created offramp wallet
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateOfframpWalletInput(
    ///     network: .tron,
    ///     externalId: "my_external_id"
    /// )
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").bankAccounts.offrampWallets.create(receiverId: "re_123", bankAccountId: "ba_123", data: input)
    /// if let wallet = response.data {
    ///     print("Created wallet: \(wallet.id)")
    ///     print("Address: \(wallet.address)")
    /// }
    /// ```
    public func create(receiverId: String, bankAccountId: String, data: CreateOfframpWalletInput) async throws -> APIResponse<CreateOfframpWalletResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/bank-accounts/\(bankAccountId)/offramp-wallets",
            method: .post,
            body: data
        )
    }
    
    /// Retrieves a specific offramp wallet by ID
    ///
    /// This method fetches the details of a specific offramp wallet.
    ///
    /// - Parameters:
    ///   - receiverId: The unique identifier of the receiver
    ///   - bankAccountId: The unique identifier of the bank account
    ///   - walletId: The unique identifier of the offramp wallet
    /// - Returns: An `APIResponse` containing the `OfframpWallet` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").bankAccounts.offrampWallets.get(receiverId: "re_123", bankAccountId: "ba_123", walletId: "ow_123")
    /// if let wallet = response.data {
    ///     print("Wallet address: \(wallet.address)")
    ///     print("Network: \(wallet.network.rawValue)")
    /// }
    /// ```
    public func get(receiverId: String, bankAccountId: String, walletId: String) async throws -> APIResponse<OfframpWalletResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/bank-accounts/\(bankAccountId)/offramp-wallets/\(walletId)",
            method: .get
        )
    }
}

