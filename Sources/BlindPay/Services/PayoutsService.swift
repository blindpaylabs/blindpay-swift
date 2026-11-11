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
    /// Without `limit` or a cursor the API returns every payout in one array
    /// (`pagination` is `nil`); with one it returns a page (default size 10).
    ///
    /// - Returns: An `APIResponse` containing a `ListPayoutsResponse`
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let params = ListPayoutsInput(limit: 50, customerId: "cu_123", status: .processing)
    /// let response = try await blindPay.instances.payouts.list(params: params)
    /// if let result = response.data {
    ///     print("Found \(result.data.count) payouts")
    ///     print("Has more: \(result.pagination?.hasMore ?? false)")
    /// }
    /// ```
    public func list(params: ListPayoutsInput? = nil, options: RequestOptions? = nil) async throws -> APIResponse<ListPayoutsResponse> {
        let queryParams = params?.toQueryParameters() ?? QueryParameters()
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams,
            options: options
        )
    }

    /// Iterates every payout matching `params`, fetching pages of 100 (or
    /// `params.limit`) on demand. `endingBefore` is not supported.
    ///
    /// ```swift
    /// for try await payout in blindPay.instances.payouts.listAutoPaging(params: ListPayoutsInput(status: .completed)) {
    ///     print(payout.id)
    /// }
    /// ```
    public func listAutoPaging(params: ListPayoutsInput = ListPayoutsInput(), options: RequestOptions? = nil) -> AsyncThrowingStream<Payout, Error> {
        AutoPager.stream(params: params) { [self] page in try await self.list(params: page, options: options) }
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
    public func get(payoutId: String, options: RequestOptions? = nil) async throws -> APIResponse<PayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/\(payoutId)",
            method: .get,
            options: options
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
    /// Public tracking endpoint for BlindPay's web and iOS apps; server-side
    /// calls get 401 in production. Use ``get(payoutId:options:)`` instead.
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.payouts.getTrack(payoutId: "pa_123")
    /// if let payout = response.data {
    ///     print("Tracking transaction step: \(payout.trackingTransaction?.step.rawValue ?? "N/A")")
    ///     print("Tracking payment step: \(payout.trackingPayment?.step.rawValue ?? "N/A")")
    /// }
    /// ```
    public func getTrack(payoutId: String, options: RequestOptions? = nil) async throws -> APIResponse<PayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/e/payouts/\(payoutId)",
            method: .get,
            options: options
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
    public func createEvm(data: CreatePayoutEvmInput, options: RequestOptions? = nil) async throws -> APIResponse<CreatePayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/evm",
            method: .post,
            body: data,
            options: options
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
    public func createStellar(data: CreatePayoutStellarInput, options: RequestOptions? = nil) async throws -> APIResponse<CreatePayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/stellar",
            method: .post,
            body: data,
            options: options
        )
    }
    
    /// Creates a new payout on Solana
    ///
    /// This method creates a new payout transaction on the Solana blockchain
    /// using a previously created quote.
    ///
    /// - Parameter data: The input data containing the quote ID, sender wallet address, and optional signed transaction
    /// - Returns: An `APIResponse` containing the created payout details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreatePayoutSolanaInput(
    ///     quoteId: "qu_123",
    ///     senderWalletAddress: "0x123...890",
    ///     signedTransaction: "AAA...Zey8y0A"
    /// )
    /// let response = try await blindPay.instances.payouts.createSolana(data: input)
    /// if let payout = response.data {
    ///     print("Created payout: \(payout.id)")
    ///     print("Status: \(payout.status.rawValue)")
    /// }
    /// ```
    public func createSolana(data: CreatePayoutSolanaInput, options: RequestOptions? = nil) async throws -> APIResponse<CreatePayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/solana",
            method: .post,
            body: data,
            options: options
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
    public func authorizeStellar(data: AuthorizeStellarInput, options: RequestOptions? = nil) async throws -> APIResponse<AuthorizeStellarResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/stellar/authorize",
            method: .post,
            body: data,
            options: options
        )
    }

    /// Submits supporting documents for a payout that is waiting for them
    /// (see ``Payout/trackingDocuments``).
    public func submitDocuments(payoutId: String, data: SubmitPayoutDocumentsInput, options: RequestOptions? = nil) async throws -> APIResponse<SubmitPayoutDocumentsResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/\(payoutId)/documents",
            method: .post,
            body: data,
            options: options
        )
    }
}
