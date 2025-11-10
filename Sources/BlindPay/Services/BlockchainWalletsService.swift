//
//  BlockchainWalletsService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Service for managing blockchain wallets
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class BlockchainWalletsService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    private let receiverId: String
    
    init(apiClient: APIClient, instanceId: String, receiverId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.receiverId = receiverId
    }
    
    /// Retrieves the sign message for a blockchain wallet
    ///
    /// This method fetches a message that needs to be signed to verify wallet ownership.
    ///
    /// - Returns: An `APIResponse` containing the sign message
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").blockchainWallets.getSignMessage()
    /// if let signMessage = response.data {
    ///     print("Message to sign: \(signMessage.message)")
    /// }
    /// ```
    public func getSignMessage() async throws -> APIResponse<BlockchainWalletSignMessageResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/blockchain-wallets/sign-message",
            method: .get
        )
    }
    
    /// Lists all blockchain wallets for the receiver
    ///
    /// This method fetches a list of all blockchain wallets associated with the receiver.
    ///
    /// - Returns: An `APIResponse` containing an array of `BlockchainWallet` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").blockchainWallets.list()
    /// if let wallets = response.data {
    ///     for wallet in wallets {
    ///         print("\(wallet.name) - \(wallet.network.rawValue)")
    ///         if let address = wallet.address {
    ///             print("Address: \(address)")
    ///         }
    ///     }
    /// }
    /// ```
    public func list() async throws -> APIResponse<BlockchainWalletsResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/blockchain-wallets",
            method: .get
        )
    }
    
    /// Creates a new blockchain wallet for the receiver
    ///
    /// This method creates a new blockchain wallet with the specified name, network, and optional address.
    ///
    /// - Parameter data: The input data containing wallet configuration
    /// - Returns: An `APIResponse` containing the created blockchain wallet
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateBlockchainWalletInput(
    ///     name: "My Polygon Wallet",
    ///     network: .polygon,
    ///     address: "0xDD6a3aD0949396e57C7738ba8FC1A46A5a1C372C",
    ///     signatureTxHash: "0x3c499c542cef5e3811e1192ce70d8cc03d5c3359",
    ///     isAccountAbstraction: false
    /// )
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").blockchainWallets.create(data: input)
    /// if let wallet = response.data {
    ///     print("Created wallet: \(wallet.id)")
    ///     print("Network: \(wallet.network.rawValue)")
    /// }
    /// ```
    public func create(data: CreateBlockchainWalletInput) async throws -> APIResponse<CreateBlockchainWalletResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/blockchain-wallets",
            method: .post,
            body: data
        )
    }
    
    /// Retrieves a specific blockchain wallet by ID
    ///
    /// This method fetches the details of a specific blockchain wallet.
    ///
    /// - Parameter id: The unique identifier of the blockchain wallet
    /// - Returns: An `APIResponse` containing the `BlockchainWallet` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").blockchainWallets.get(id: "bw_123")
    /// if let wallet = response.data {
    ///     print("Wallet name: \(wallet.name)")
    ///     print("Network: \(wallet.network.rawValue)")
    ///     if let address = wallet.address {
    ///         print("Address: \(address)")
    ///     }
    /// }
    /// ```
    public func get(id: String) async throws -> APIResponse<BlockchainWalletResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/blockchain-wallets/\(id)",
            method: .get
        )
    }
    
    /// Deletes a blockchain wallet
    ///
    /// This method permanently deletes a blockchain wallet. This action cannot be undone.
    ///
    /// - Parameter id: The unique identifier of the blockchain wallet to delete
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").blockchainWallets.delete(id: "bw_123")
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Wallet deleted successfully")
    /// }
    /// ```
    public func delete(id: String) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/blockchain-wallets/\(id)",
            method: .delete
        )
    }
}

