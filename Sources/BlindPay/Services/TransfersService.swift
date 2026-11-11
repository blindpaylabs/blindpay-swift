//
//  TransfersService.swift
//  blindpay-swift
//

import Foundation

/// Stablecoin transfers between wallets. Instance-scoped.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class TransfersService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String

    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }

    /// Lists one page of transfers. The API always paginates this list
    /// (default page size 10).
    ///
    /// ```swift
    /// let page = try await blindPay.instances.transfers.list(params: ListTransfersInput(limit: 50, status: .completed)).get()
    /// print(page?.data.count ?? 0, page?.pagination?.hasMore ?? false)
    /// ```
    public func list(params: ListTransfersInput? = nil, options: RequestOptions? = nil) async throws -> APIResponse<ListTransfersResponse> {
        let queryParams = params?.toQueryParameters() ?? QueryParameters()
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/transfers",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams,
            options: options
        )
    }

    /// Iterates every transfer matching `params`, fetching pages of 100 (or
    /// `params.limit`) on demand. `endingBefore` is not supported.
    ///
    /// ```swift
    /// for try await transfer in blindPay.instances.transfers.listAutoPaging(params: ListTransfersInput(status: .completed)) {
    ///     print(transfer.id)
    /// }
    /// ```
    public func listAutoPaging(params: ListTransfersInput = ListTransfersInput(), options: RequestOptions? = nil) -> AsyncThrowingStream<Transfer, Error> {
        AutoPager.stream(params: params) { [self] page in try await self.list(params: page, options: options) }
    }

    /// Retrieves a transfer.
    public func get(transferId: String, options: RequestOptions? = nil) async throws -> APIResponse<TransferResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/transfers/\(transferId)",
            method: .get,
            options: options
        )
    }

    /// Public tracking endpoint for BlindPay's web and iOS apps; server-side
    /// calls get 401 in production. Use ``get(transferId:options:)`` instead.
    public func getTrack(transferId: String, options: RequestOptions? = nil) async throws -> APIResponse<TransferResponse> {
        return try await apiClient.request(
            endpoint: "/v1/e/transfers/\(transferId)",
            method: .get,
            options: options
        )
    }

    /// Executes a transfer from a transfer quote. Quotes are single-use.
    public func create(data: CreateTransferInput, options: RequestOptions? = nil) async throws -> APIResponse<CreateTransferResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/transfers",
            method: .post,
            body: data,
            options: options
        )
    }
}
