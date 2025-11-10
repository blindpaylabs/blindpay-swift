//
//  PayinQuote.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

// MARK: - Payer Rules

/// Payer rules for payin quotes
public struct PayinQuotePayerRules: Codable, Sendable, Equatable {
    /// Allowed tax IDs for PIX payments
    public let pixAllowedTaxIds: [String]?
    
    public init(pixAllowedTaxIds: [String]? = nil) {
        self.pixAllowedTaxIds = pixAllowedTaxIds
    }
    
    enum CodingKeys: String, CodingKey {
        case pixAllowedTaxIds = "pix_allowed_tax_ids"
    }
}

// MARK: - PayinQuote

/// Represents a payin quote
public struct PayinQuote: Codable, Sendable, Equatable {
    /// Unique identifier for the payin quote
    public let id: String
    
    /// Receiver ID
    public let receiverId: String
    
    /// Payment method
    public let paymentMethod: PaymentMethod
    
    /// Token
    public let token: StablecoinToken?
    
    /// Request amount (in smallest unit, e.g., 100 = 1.00)
    public let requestAmount: Int
    
    /// Whether fees are covered
    public let coverFees: Bool?
    
    /// Currency type (sender or receiver)
    public let currencyType: CurrencyType
    
    /// Expiration timestamp
    public let expiresAt: Int
    
    /// Currency
    public let currency: Currency?
    
    /// Commercial quotation
    public let commercialQuotation: Double
    
    /// BlindPay quotation
    public let blindpayQuotation: Double
    
    /// Receiver amount
    public let receiverAmount: Double
    
    /// Sender amount
    public let senderAmount: Double
    
    /// Partner fee amount
    public let partnerFeeAmount: Double
    
    /// Flat fee
    public let flatFee: Double
    
    /// Total fee amount
    public let totalFeeAmount: Double?
    
    /// Receiver local amount
    public let receiverLocalAmount: Double?
    
    /// Payer rules
    public let payerRules: PayinQuotePayerRules?
    
    /// Blockchain wallet ID
    public let blockchainWalletId: String?
    
    /// Instance ID
    public let instanceId: String
    
    /// Partner fee ID
    public let partnerFeeId: String?
    
    /// Billing fee
    public let billingFee: Int?
    
    /// Description
    public let description: String?
    
    /// Timestamp when the quote was created
    public let createdAt: String
    
    /// Timestamp when the quote was last updated
    public let updatedAt: String
    
    public init(
        id: String,
        receiverId: String,
        paymentMethod: PaymentMethod,
        token: StablecoinToken? = nil,
        requestAmount: Int,
        coverFees: Bool? = nil,
        currencyType: CurrencyType,
        expiresAt: Int,
        currency: Currency? = nil,
        commercialQuotation: Double,
        blindpayQuotation: Double,
        receiverAmount: Double,
        senderAmount: Double,
        partnerFeeAmount: Double,
        flatFee: Double,
        totalFeeAmount: Double? = nil,
        receiverLocalAmount: Double? = nil,
        payerRules: PayinQuotePayerRules? = nil,
        blockchainWalletId: String? = nil,
        instanceId: String,
        partnerFeeId: String? = nil,
        billingFee: Int? = nil,
        description: String? = nil,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.receiverId = receiverId
        self.paymentMethod = paymentMethod
        self.token = token
        self.requestAmount = requestAmount
        self.coverFees = coverFees
        self.currencyType = currencyType
        self.expiresAt = expiresAt
        self.currency = currency
        self.commercialQuotation = commercialQuotation
        self.blindpayQuotation = blindpayQuotation
        self.receiverAmount = receiverAmount
        self.senderAmount = senderAmount
        self.partnerFeeAmount = partnerFeeAmount
        self.flatFee = flatFee
        self.totalFeeAmount = totalFeeAmount
        self.receiverLocalAmount = receiverLocalAmount
        self.payerRules = payerRules
        self.blockchainWalletId = blockchainWalletId
        self.instanceId = instanceId
        self.partnerFeeId = partnerFeeId
        self.billingFee = billingFee
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case receiverId = "receiver_id"
        case paymentMethod = "payment_method"
        case token
        case requestAmount = "request_amount"
        case coverFees = "cover_fees"
        case currencyType = "currency_type"
        case expiresAt = "expires_at"
        case currency
        case commercialQuotation = "commercial_quotation"
        case blindpayQuotation = "blindpay_quotation"
        case receiverAmount = "receiver_amount"
        case senderAmount = "sender_amount"
        case partnerFeeAmount = "partner_fee_amount"
        case flatFee = "flat_fee"
        case totalFeeAmount = "total_fee_amount"
        case receiverLocalAmount = "receiver_local_amount"
        case payerRules = "payer_rules"
        case blockchainWalletId = "blockchain_wallet_id"
        case instanceId = "instance_id"
        case partnerFeeId = "partner_fee_id"
        case billingFee = "billing_fee"
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Response Types

/// Response type for listing payin quotes
public typealias PayinQuotesResponse = [PayinQuote]

/// Response type for single payin quote
public typealias PayinQuoteResponse = PayinQuote

// MARK: - Input Types

/// Input for creating a payin quote
public struct CreatePayinQuoteInput: Codable, Sendable {
    /// Receiver ID
    public let receiverId: String
    
    /// Blockchain wallet ID
    public let blockchainWalletId: String
    
    /// Payment method
    public let paymentMethod: PaymentMethod
    
    /// Currency type (sender or receiver)
    public let currencyType: CurrencyType
    
    /// Network (optional)
    public let network: Network?
    
    /// Request amount
    public let requestAmount: Double
    
    /// Token (optional)
    public let token: StablecoinToken?
    
    /// Whether to cover fees
    public let coverFees: Bool?
    
    /// Description (optional)
    public let description: String?
    
    /// Partner fee ID (optional)
    public let partnerFeeId: String?
    
    public init(
        receiverId: String,
        blockchainWalletId: String,
        paymentMethod: PaymentMethod,
        currencyType: CurrencyType,
        network: Network? = nil,
        requestAmount: Double,
        token: StablecoinToken? = nil,
        coverFees: Bool? = nil,
        description: String? = nil,
        partnerFeeId: String? = nil
    ) {
        self.receiverId = receiverId
        self.blockchainWalletId = blockchainWalletId
        self.paymentMethod = paymentMethod
        self.currencyType = currencyType
        self.network = network
        self.requestAmount = requestAmount
        self.token = token
        self.coverFees = coverFees
        self.description = description
        self.partnerFeeId = partnerFeeId
    }
    
    enum CodingKeys: String, CodingKey {
        case receiverId = "receiver_id"
        case blockchainWalletId = "blockchain_wallet_id"
        case paymentMethod = "payment_method"
        case currencyType = "currency_type"
        case network
        case requestAmount = "request_amount"
        case token
        case coverFees = "cover_fees"
        case description
        case partnerFeeId = "partner_fee_id"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(receiverId, forKey: .receiverId)
        try container.encode(blockchainWalletId, forKey: .blockchainWalletId)
        try container.encode(paymentMethod, forKey: .paymentMethod)
        try container.encode(currencyType, forKey: .currencyType)
        try container.encodeIfPresent(network, forKey: .network)
        // Convert to integer smallest unit (100 = 1.00)
        try container.encode(Int(requestAmount * 100), forKey: .requestAmount)
        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(coverFees, forKey: .coverFees)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(partnerFeeId, forKey: .partnerFeeId)
    }
}

/// Response for creating a payin quote
public typealias CreatePayinQuoteResponse = PayinQuote

/// Input parameters for listing payin quotes
public struct ListPayinQuotesInput: Codable, Sendable {
    /// Number of items to return
    public let limit: String?
    
    /// Number of items to skip
    public let offset: String?
    
    /// Cursor for pagination (starting after this ID)
    public let startingAfter: String?
    
    /// Cursor for pagination (ending before this ID)
    public let endingBefore: String?
    
    /// Filter by receiver ID
    public let receiverId: String?
    
    public init(
        limit: String? = nil,
        offset: String? = nil,
        startingAfter: String? = nil,
        endingBefore: String? = nil,
        receiverId: String? = nil
    ) {
        self.limit = limit
        self.offset = offset
        self.startingAfter = startingAfter
        self.endingBefore = endingBefore
        self.receiverId = receiverId
    }
    
    enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case startingAfter = "starting_after"
        case endingBefore = "ending_before"
        case receiverId = "receiver_id"
    }
    
    /// Converts to query parameters dictionary
    func toQueryParameters() -> [String: String] {
        var params: [String: String] = [:]
        if let limit = limit {
            params["limit"] = limit
        }
        if let offset = offset {
            params["offset"] = offset
        }
        if let startingAfter = startingAfter {
            params["starting_after"] = startingAfter
        }
        if let endingBefore = endingBefore {
            params["ending_before"] = endingBefore
        }
        if let receiverId = receiverId {
            params["receiver_id"] = receiverId
        }
        return params
    }
}

