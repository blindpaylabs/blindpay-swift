//
//  PayablesService.swift
//  blindpay-swift
//

import Foundation

/// Payables: bills (boleto, PIX code or invoice) a customer pays out to a
/// beneficiary. Instance-scoped. Pay one with a quote that sets
/// `payableId`, then a payout.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class PayablesService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String

    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }

    /// Creates a payable.
    public func create(data: CreatePayableInput, options: RequestOptions? = nil) async throws -> APIResponse<Payable> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payables",
            method: .post,
            body: data,
            options: options
        )
    }

    /// Lists payables. Without `limit` or a cursor the API returns every
    /// payable in one array (`pagination` is `nil`); with one it returns a
    /// page (default size 10).
    public func list(params: ListPayablesInput? = nil, options: RequestOptions? = nil) async throws -> APIResponse<ListPayablesResponse> {
        let queryParams = params?.toQueryParameters() ?? QueryParameters()
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payables",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams,
            options: options
        )
    }

    /// Iterates every payable matching `params`, fetching pages of 100 (or
    /// `params.limit`) on demand. `endingBefore` is not supported.
    public func listAutoPaging(params: ListPayablesInput = ListPayablesInput(), options: RequestOptions? = nil) -> AsyncThrowingStream<Payable, Error> {
        AutoPager.stream(params: params) { [self] page in try await self.list(params: page, options: options) }
    }

    /// Retrieves a payable.
    public func get(id: String, options: RequestOptions? = nil) async throws -> APIResponse<Payable> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payables/\(id)",
            method: .get,
            options: options
        )
    }

    /// Deletes a draft payable and returns it.
    public func delete(id: String, options: RequestOptions? = nil) async throws -> APIResponse<Payable> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payables/\(id)",
            method: .delete,
            options: options
        )
    }
}
