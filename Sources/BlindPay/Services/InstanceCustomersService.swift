//
//  InstanceCustomersService.swift
//  blindpay-swift
//

import Foundation

/// Lists and creates customers. Instance-scoped; operations on one customer
/// live on ``BlindPay/customers(customerId:)``.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class InstanceCustomersService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String

    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }

    /// Lists customers. Without `limit` or a cursor the API returns every
    /// customer in one array (`pagination` is `nil`); with one it returns a
    /// page (default size 100).
    public func list(params: ListCustomersInput? = nil, options: RequestOptions? = nil) async throws -> APIResponse<ListCustomersResponse> {
        let queryParams = params?.toQueryParameters() ?? QueryParameters()
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams,
            options: options
        )
    }

    /// Iterates every customer matching `params`, fetching pages of 100 (or
    /// `params.limit`) on demand. `endingBefore` is not supported.
    /// If the server answers `hasMore` with the same cursor it was just sent,
    /// iteration ends after that page by throwing ``BlindPayError/invalidResponse``.
    public func listAutoPaging(params: ListCustomersInput = ListCustomersInput(), options: RequestOptions? = nil) -> AsyncThrowingStream<Customer, Error> {
        AutoPager.stream(params: params) { [self] page in try await self.list(params: page, options: options) }
    }

    /// Creates a customer.
    public func create(data: CreateCustomerInput, options: RequestOptions? = nil) async throws -> APIResponse<CreateCustomerResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers",
            method: .post,
            body: data,
            options: options
        )
    }
}
