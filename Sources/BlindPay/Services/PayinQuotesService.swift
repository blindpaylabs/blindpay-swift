//
//  PayinQuotesService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Service for managing payin quotes
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class PayinQuotesService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }
    
    /// Creates a new payin quote
    ///
    /// This method creates a new payin quote for a transaction based on the provided parameters.
    ///
    /// - Parameter data: The input data containing payin quote configuration
    /// - Returns: An `APIResponse` containing the created payin quote details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreatePayinQuoteInput(
    ///     receiverId: "re_123",
    ///     blockchainWalletId: "bw_123",
    ///     paymentMethod: .pix,
    ///     currencyType: .sender,
    ///     network: .base,
    ///     requestAmount: 1000.0,
    ///     token: .usdc,
    ///     coverFees: true,
    ///     description: "Payment for services",
    ///     partnerFeeId: "pf_123"
    /// )
    /// let response = try await blindPay.instances.payins.quotes.create(data: input)
    /// if let quote = response.data {
    ///     print("Quote ID: \(quote.id)")
    ///     print("Expires at: \(quote.expiresAt)")
    ///     print("Sender amount: \(quote.senderAmount)")
    ///     print("Receiver amount: \(quote.receiverAmount)")
    /// }
    /// ```
    public func create(data: CreatePayinQuoteInput) async throws -> APIResponse<CreatePayinQuoteResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payin-quotes",
            method: .post,
            body: data
        )
    }
    
    /// Retrieves a specific payin quote by ID
    ///
    /// This method fetches the details of a specific payin quote.
    ///
    /// - Parameter id: The unique identifier of the payin quote
    /// - Returns: An `APIResponse` containing the `PayinQuote` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.payins.quotes.get(id: "pq_123")
    /// if let quote = response.data {
    ///     print("Quote ID: \(quote.id)")
    ///     print("Expires at: \(quote.expiresAt)")
    ///     print("Sender amount: \(quote.senderAmount)")
    ///     print("Receiver amount: \(quote.receiverAmount)")
    /// }
    /// ```
    public func get(id: String) async throws -> APIResponse<PayinQuoteResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payin-quotes/\(id)",
            method: .get
        )
    }
    
    /// Lists all payin quotes for the instance
    ///
    /// This method fetches a list of all payin quotes associated with the instance,
    /// with optional filtering and pagination support.
    ///
    /// - Parameter params: Optional parameters for filtering and pagination
    /// - Returns: An `APIResponse` containing an array of `PayinQuote` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let params = ListPayinQuotesInput(
    ///     limit: "50",
    ///     receiverId: "re_123"
    /// )
    /// let response = try await blindPay.instances.payins.quotes.list(params: params)
    /// if let quotes = response.data {
    ///     print("Found \(quotes.count) payin quotes")
    ///     for quote in quotes {
    ///         print("Quote ID: \(quote.id)")
    ///     }
    /// }
    /// ```
    public func list(params: ListPayinQuotesInput? = nil) async throws -> APIResponse<PayinQuotesResponse> {
        let queryParams = params?.toQueryParameters() ?? [:]
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payin-quotes",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams
        )
    }
    
    /// Gets the foreign exchange rate between two currencies for payin quotes
    ///
    /// This method retrieves the current FX rate for converting between two currencies,
    /// including BlindPay quotation and fees for payin quotes.
    ///
    /// - Parameter data: The input data containing currency information and request amount
    /// - Returns: An `APIResponse` containing FX rate details including quotations and fees
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = GetFxRateInput(
    ///     currencyType: .sender,
    ///     from: .usdc,
    ///     to: .brl,
    ///     requestAmount: 1000.0
    /// )
    /// let response = try await blindPay.instances.payins.quotes.getFxRate(data: input)
    /// if let fxRate = response.data {
    ///     print("Commercial quotation: \(fxRate.commercialQuotation)")
    ///     print("BlindPay quotation: \(fxRate.blindpayQuotation)")
    ///     print("Result amount: \(fxRate.resultAmount)")
    /// }
    /// ```
    public func getFxRate(data: GetFxRateInput) async throws -> APIResponse<GetFxRateResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payin-quotes/fx",
            method: .post,
            body: data
        )
    }
}

