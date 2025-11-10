//
//  PayoutsService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Service for managing payouts
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class PayoutsService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }
    
    /// Lists all payouts for the instance
    ///
    /// This method fetches a list of all payouts associated with the instance,
    /// with optional filtering and pagination support.
    ///
    /// - Parameter params: Optional parameters for filtering and pagination
    /// - Returns: An `APIResponse` containing a `ListPayoutsResponse` with payouts and pagination metadata
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let params = ListPayoutsInput(
    ///     limit: "50",
    ///     status: .processing,
    ///     receiverId: "re_123"
    /// )
    /// let response = try await blindPay.instances.payouts.list(params: params)
    /// if let result = response.data {
    ///     print("Found \(result.data.count) payouts")
    ///     print("Has more: \(result.pagination.hasMore)")
    /// }
    /// ```
    public func list(params: ListPayoutsInput? = nil) async throws -> APIResponse<ListPayoutsResponse> {
        let queryParams = params?.toQueryParameters() ?? [:]
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams
        )
    }
    
    /// Retrieves a specific payout by ID
    ///
    /// This method fetches the details of a specific payout.
    ///
    /// - Parameter payoutId: The unique identifier of the payout
    /// - Returns: An `APIResponse` containing the `Payout` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.payouts.get(payoutId: "pa_123")
    /// if let payout = response.data {
    ///     print("Payout status: \(payout.status.rawValue)")
    ///     print("Receiver amount: \(payout.receiverAmount)")
    /// }
    /// ```
    public func get(payoutId: String) async throws -> APIResponse<PayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/\(payoutId)",
            method: .get
        )
    }
    
    /// Retrieves payout tracking information
    ///
    /// This method fetches tracking information for a payout using the public endpoint.
    ///
    /// - Parameter payoutId: The unique identifier of the payout
    /// - Returns: An `APIResponse` containing the `Payout` object with tracking information
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.payouts.getTrack(payoutId: "pa_123")
    /// if let payout = response.data {
    ///     print("Tracking transaction step: \(payout.trackingTransaction?.step.rawValue ?? "N/A")")
    ///     print("Tracking payment step: \(payout.trackingPayment?.step.rawValue ?? "N/A")")
    /// }
    /// ```
    public func getTrack(payoutId: String) async throws -> APIResponse<PayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/e/payouts/\(payoutId)",
            method: .get
        )
    }
    
    /// Creates a new payout on EVM chains
    ///
    /// This method creates a new payout transaction on EVM-compatible blockchains
    /// using a previously created quote.
    ///
    /// - Parameter data: The input data containing the quote ID and sender wallet address
    /// - Returns: An `APIResponse` containing the created payout details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreatePayoutEvmInput(
    ///     quoteId: "qu_123",
    ///     senderWalletAddress: "0x123...890"
    /// )
    /// let response = try await blindPay.instances.payouts.createEvm(data: input)
    /// if let payout = response.data {
    ///     print("Created payout: \(payout.id)")
    ///     print("Status: \(payout.status.rawValue)")
    /// }
    /// ```
    public func createEvm(data: CreatePayoutEvmInput) async throws -> APIResponse<CreatePayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/evm",
            method: .post,
            body: data
        )
    }
    
    /// Creates a new payout on Stellar
    ///
    /// This method creates a new payout transaction on the Stellar blockchain
    /// using a previously created quote.
    ///
    /// - Parameter data: The input data containing the quote ID, sender wallet address, and optional signed transaction
    /// - Returns: An `APIResponse` containing the created payout details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreatePayoutStellarInput(
    ///     quoteId: "qu_123",
    ///     senderWalletAddress: "GABC...XYZ",
    ///     signedTransaction: "AAA...Zey8y0A"
    /// )
    /// let response = try await blindPay.instances.payouts.createStellar(data: input)
    /// if let payout = response.data {
    ///     print("Created payout: \(payout.id)")
    ///     print("Status: \(payout.status.rawValue)")
    /// }
    /// ```
    public func createStellar(data: CreatePayoutStellarInput) async throws -> APIResponse<CreatePayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/stellar",
            method: .post,
            body: data
        )
    }
    
    /// Authorizes a token on Stellar wallet
    ///
    /// This method authorizes a token on a Stellar wallet before creating a payout.
    ///
    /// - Parameter data: The input data containing the quote ID and sender wallet address
    /// - Returns: An `APIResponse` containing the transaction hash
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = AuthorizeStellarInput(
    ///     quoteId: "qu_123",
    ///     senderWalletAddress: "GABC...XYZ"
    /// )
    /// let response = try await blindPay.instances.payouts.authorizeStellar(data: input)
    /// if let result = response.data {
    ///     print("Transaction hash: \(result.transactionHash)")
    /// }
    /// ```
    public func authorizeStellar(data: AuthorizeStellarInput) async throws -> APIResponse<AuthorizeStellarResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/stellar/authorize",
            method: .post,
            body: data
        )
    }
}

