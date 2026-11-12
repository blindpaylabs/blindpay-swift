//
//  PayinsService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Service for managing payins
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class PayinsService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    /// Payin quotes management service
    public let quotes: PayinQuotesService
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.quotes = PayinQuotesService(apiClient: apiClient, instanceId: instanceId)
    }
    
    /// Lists all payins for the instance
    ///
    /// This method fetches a list of all payins associated with the instance,
    /// with optional filtering and pagination support.
    ///
    /// - Parameter params: Optional parameters for filtering and pagination
    /// Without `limit` or a cursor the API returns every payin in one array
    /// (`pagination` is `nil`); with one it returns a page (default size 10).
    ///
    /// - Returns: An `APIResponse` containing a `ListPayinsResponse`
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let params = ListPayinsInput(limit: 50, customerId: "cu_123", status: .processing)
    /// let response = try await blindPay.instances.payins.list(params: params)
    /// if let result = response.data {
    ///     print("Found \(result.data.count) payins")
    ///     print("Has more: \(result.pagination?.hasMore ?? false)")
    /// }
    /// ```
    public func list(params: ListPayinsInput? = nil, options: RequestOptions? = nil) async throws -> APIResponse<ListPayinsResponse> {
        let queryParams = params?.toQueryParameters() ?? QueryParameters()
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payins",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams,
            options: options
        )
    }

    /// Iterates every payin matching `params`, fetching pages of 100 (or
    /// `params.limit`) on demand. `endingBefore` is not supported.
    /// If the server answers `hasMore` with the same cursor it was just sent,
    /// iteration ends after that page by throwing ``BlindPayError/invalidResponse``.
    ///
    /// ```swift
    /// for try await payin in blindPay.instances.payins.listAutoPaging(params: ListPayinsInput(status: .completed)) {
    ///     print(payin.id)
    /// }
    /// ```
    public func listAutoPaging(params: ListPayinsInput = ListPayinsInput(), options: RequestOptions? = nil) -> AsyncThrowingStream<Payin, Error> {
        AutoPager.stream(params: params) { [self] page in try await self.list(params: page, options: options) }
    }
    
    /// Retrieves a specific payin by ID
    ///
    /// This method fetches the details of a specific payin.
    ///
    /// - Parameter payinId: The unique identifier of the payin
    /// - Returns: An `APIResponse` containing the `Payin` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.payins.get(payinId: "pi_123")
    /// if let payin = response.data {
    ///     print("Payin status: \(payin.status.rawValue)")
    ///     print("Receiver amount: \(payin.receiverAmount ?? 0)")
    /// }
    /// ```
    public func get(payinId: String, options: RequestOptions? = nil) async throws -> APIResponse<PayinResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payins/\(payinId)",
            method: .get,
            options: options
        )
    }
    
    /// Retrieves payin tracking information
    ///
    /// This method fetches tracking information for a payin using the public endpoint.
    ///
    /// Public tracking endpoint for BlindPay's web and iOS apps; server-side
    /// calls get 401 in production. Use ``get(payinId:options:)`` instead.
    ///
    /// - Parameters:
    ///   - payinId: The unique identifier of the payin
    ///   - checkoutToken: The card checkout token, for card payins
    /// - Returns: An `APIResponse` containing the `Payin` object with tracking information
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.payins.getTrack(payinId: "pi_123")
    /// if let payin = response.data {
    ///     print("Tracking transaction step: \(payin.trackingTransaction?.step ?? "N/A")")
    ///     print("Tracking payment step: \(payin.trackingPayment?.step ?? "N/A")")
    /// }
    /// ```
    public func getTrack(payinId: String, checkoutToken: String? = nil, options: RequestOptions? = nil) async throws -> APIResponse<PayinResponse> {
        let queryParams: QueryParameters = ["checkout_token": checkoutToken]
        return try await apiClient.request(
            endpoint: "/v1/e/payins/\(payinId)",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams,
            options: options
        )
    }
    
    /// Creates a new payin on EVM chains
    ///
    /// This method creates a new payin transaction on EVM-compatible blockchains
    /// using a previously created payin quote.
    ///
    /// - Parameter data: The input data containing the payin quote ID
    /// - Returns: An `APIResponse` containing the created payin details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreatePayinInput(payinQuoteId: "pq_123")
    /// let response = try await blindPay.instances.payins.createEvm(data: input)
    /// if let payin = response.data {
    ///     print("Created payin: \(payin.id)")
    ///     print("Status: \(payin.status.rawValue)")
    ///     if let pixCode = payin.pixCode {
    ///         print("PIX code: \(pixCode)")
    ///     }
    /// }
    /// ```
    public func createEvm(data: CreatePayinInput, options: RequestOptions? = nil) async throws -> APIResponse<CreatePayinResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payins/evm",
            method: .post,
            body: data,
            options: options
        )
    }
}

