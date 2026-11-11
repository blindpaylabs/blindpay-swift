//
//  CustodialWalletsService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 09/04/26.
//

import Foundation

/// Service for managing custodial wallets
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class CustodialWalletsService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    private let customerId: String

    init(apiClient: APIClient, instanceId: String, customerId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.customerId = customerId
    }

    /// Lists all custodial wallets for the customer
    ///
    /// - Returns: An `APIResponse` containing an array of `CustodialWallet` objects
    /// - Throws: `BlindPayError` if the request fails
    public func list(options: RequestOptions? = nil) async throws -> APIResponse<CustodialWalletsResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)/wallets",
            method: .get,
            options: options
        )
    }

    /// Retrieves a specific custodial wallet by ID
    ///
    /// - Parameter id: The unique identifier of the custodial wallet
    /// - Returns: An `APIResponse` containing the `CustodialWallet` object
    /// - Throws: `BlindPayError` if the request fails
    public func get(id: String, options: RequestOptions? = nil) async throws -> APIResponse<CustodialWalletResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)/wallets/\(id)",
            method: .get,
            options: options
        )
    }

    /// Creates a new custodial wallet
    ///
    /// - Parameter data: The input data containing wallet configuration
    /// - Returns: An `APIResponse` containing the created custodial wallet
    /// - Throws: `BlindPayError` if the request fails
    public func create(data: CreateCustodialWalletInput, options: RequestOptions? = nil) async throws -> APIResponse<CreateCustodialWalletResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)/wallets",
            method: .post,
            body: data,
            options: options
        )
    }

    /// Gets the balance of a custodial wallet
    ///
    /// - Parameter id: The unique identifier of the custodial wallet
    /// - Returns: An `APIResponse` containing the wallet balance
    /// - Throws: `BlindPayError` if the request fails
    public func getBalance(id: String, options: RequestOptions? = nil) async throws -> APIResponse<CustodialWalletBalanceResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)/wallets/\(id)/balance",
            method: .get,
            options: options
        )
    }

    /// Deletes a custodial wallet
    ///
    /// - Parameter id: The unique identifier of the custodial wallet to delete
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    public func delete(id: String, options: RequestOptions? = nil) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)/wallets/\(id)",
            method: .delete,
            options: options
        )
    }

    /// Lists one page of deposits into a managed wallet. The API always
    /// paginates this list (default page size 10).
    public func getDeposits(id: String, params: ListWalletDepositsInput? = nil, options: RequestOptions? = nil) async throws -> APIResponse<WalletDepositsResponse> {
        let queryParams = params?.toQueryParameters() ?? QueryParameters()
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)/wallets/\(id)/deposits",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams,
            options: options
        )
    }

    /// Iterates every deposit into a managed wallet, fetching pages of 100 (or
    /// `params.limit`) on demand. `endingBefore` is not supported.
    public func getDepositsAutoPaging(id: String, params: ListWalletDepositsInput = ListWalletDepositsInput(), options: RequestOptions? = nil) -> AsyncThrowingStream<WalletDeposit, Error> {
        AutoPager.stream(params: params) { [self] page in try await self.getDeposits(id: id, params: page, options: options) }
    }
}
