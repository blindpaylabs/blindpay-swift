//
//  PayinsService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

/// Service for managing payins
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class PayinsService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }
    
    /// Lists all payins for the instance
    ///
    /// This method fetches a list of all payins associated with the instance,
    /// with optional filtering and pagination support.
    ///
    /// - Parameter params: Optional parameters for filtering and pagination
    /// - Returns: An `APIResponse` containing a `ListPayinsResponse` with payins and pagination metadata
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let params = ListPayinsInput(
    ///     limit: "50",
    ///     status: .processing,
    ///     receiverId: "re_123"
    /// )
    /// let response = try await blindPay.instances.payins.list(params: params)
    /// if let result = response.data {
    ///     print("Found \(result.data.count) payins")
    ///     print("Has more: \(result.pagination.hasMore)")
    /// }
    /// ```
    public func list(params: ListPayinsInput? = nil) async throws -> APIResponse<ListPayinsResponse> {
        let queryParams = params?.toQueryParameters() ?? [:]
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payins",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams
        )
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
    public func get(payinId: String) async throws -> APIResponse<PayinResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payins/\(payinId)",
            method: .get
        )
    }
    
    /// Retrieves payin tracking information
    ///
    /// This method fetches tracking information for a payin using the public endpoint.
    ///
    /// - Parameter payinId: The unique identifier of the payin
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
    public func getTrack(payinId: String) async throws -> APIResponse<PayinResponse> {
        return try await apiClient.request(
            endpoint: "/v1/e/payins/\(payinId)",
            method: .get
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
    public func createEvm(data: CreatePayinInput) async throws -> APIResponse<CreatePayinResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payins/evm",
            method: .post,
            body: data
        )
    }
}

