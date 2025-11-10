//
//  QuotesService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

/// Service for managing quotes
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class QuotesService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }
    
    /// Creates a new quote
    ///
    /// This method creates a new quote for a transaction based on the provided parameters.
    ///
    /// - Parameter data: The input data containing quote configuration
    /// - Returns: An `APIResponse` containing the created quote details including contract information
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateQuoteInput(
    ///     bankAccountId: "ba_123",
    ///     currencyType: .sender,
    ///     network: .base,
    ///     requestAmount: 1000.0,
    ///     token: .usdc,
    ///     coverFees: true,
    ///     description: "Payment for services",
    ///     partnerFeeId: "pf_123",
    ///     transactionDocumentFile: nil,
    ///     transactionDocumentId: nil,
    ///     transactionDocumentType: .invoice
    /// )
    /// let response = try await blindPay.instances.quotes.create(data: input)
    /// if let quote = response.data {
    ///     print("Quote ID: \(quote.id)")
    ///     print("Expires at: \(quote.expiresAt)")
    ///     print("Sender amount: \(quote.senderAmount)")
    ///     print("Receiver amount: \(quote.receiverAmount)")
    /// }
    /// ```
    public func create(data: CreateQuoteInput) async throws -> APIResponse<CreateQuoteResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/quotes",
            method: .post,
            body: data
        )
    }
    
    /// Gets the foreign exchange rate between two currencies
    ///
    /// This method retrieves the current FX rate for converting between two currencies,
    /// including BlindPay quotation and fees.
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
    /// let response = try await blindPay.instances.quotes.getFxRate(data: input)
    /// if let fxRate = response.data {
    ///     print("Commercial quotation: \(fxRate.commercialQuotation)")
    ///     print("BlindPay quotation: \(fxRate.blindpayQuotation)")
    ///     print("Result amount: \(fxRate.resultAmount)")
    /// }
    /// ```
    public func getFxRate(data: GetFxRateInput) async throws -> APIResponse<GetFxRateResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/quotes/fx",
            method: .post,
            body: data
        )
    }
}

