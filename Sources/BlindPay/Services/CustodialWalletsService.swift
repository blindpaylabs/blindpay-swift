//
//  CustodialWalletsService.swift
//  blindpay-swift
//

import Foundation

/// Service for managing custodial wallets
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class CustodialWalletsService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    private let receiverId: String

    init(apiClient: APIClient, instanceId: String, receiverId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.receiverId = receiverId
    }

    /// Lists all custodial wallets for the receiver
    ///
    /// - Returns: An `APIResponse` containing an array of `CustodialWallet` objects
    /// - Throws: `BlindPayError` if the request fails
    public func list() async throws -> APIResponse<CustodialWalletsResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/wallets",
            method: .get
        )
    }

    /// Retrieves a specific custodial wallet by ID
    ///
    /// - Parameter id: The unique identifier of the custodial wallet
    /// - Returns: An `APIResponse` containing the `CustodialWallet` object
    /// - Throws: `BlindPayError` if the request fails
    public func get(id: String) async throws -> APIResponse<CustodialWalletResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/wallets/\(id)",
            method: .get
        )
    }

    /// Creates a new custodial wallet
    ///
    /// - Parameter data: The input data containing wallet configuration
    /// - Returns: An `APIResponse` containing the created custodial wallet
    /// - Throws: `BlindPayError` if the request fails
    public func create(data: CreateCustodialWalletInput) async throws -> APIResponse<CreateCustodialWalletResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/wallets",
            method: .post,
            body: data
        )
    }

    /// Gets the balance of a custodial wallet
    ///
    /// - Parameter id: The unique identifier of the custodial wallet
    /// - Returns: An `APIResponse` containing the wallet balance
    /// - Throws: `BlindPayError` if the request fails
    public func getBalance(id: String) async throws -> APIResponse<CustodialWalletBalanceResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/wallets/\(id)/balance",
            method: .get
        )
    }

    /// Deletes a custodial wallet
    ///
    /// - Parameter id: The unique identifier of the custodial wallet to delete
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    public func delete(id: String) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/wallets/\(id)",
            method: .delete
        )
    }
}
