//
//  PayinQuote.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

// MARK: - Payer Rules

/// Payer rules for payin quotes: restrict who may fund the payin
public struct PayinQuotePayerRules: Codable, Sendable, Equatable {
    /// Allowed tax IDs for PIX payments
    public let pixAllowedTaxIds: [String]?

    /// Allowed tax ID for Transfers (AR) payments
    public let transfersAllowedTaxId: String?

    /// Allowed tax IDs for PSE (CO) payments
    public let pseAllowedTaxIds: [String]?

    /// PSE payer full name
    public let pseFullName: String?

    /// PSE payer document type (`CC` or `NIT`)
    public let pseDocumentType: String?

    /// PSE payer document number
    public let pseDocumentNumber: String?

    /// PSE payer email
    public let pseEmail: String?

    /// PSE payer phone (`+573` followed by 9 digits)
    public let psePhone: String?

    /// PSE payer bank code
    public let pseBankCode: String?

    public init(
        pixAllowedTaxIds: [String]? = nil,
        transfersAllowedTaxId: String? = nil,
        pseAllowedTaxIds: [String]? = nil,
        pseFullName: String? = nil,
        pseDocumentType: String? = nil,
        pseDocumentNumber: String? = nil,
        pseEmail: String? = nil,
        psePhone: String? = nil,
        pseBankCode: String? = nil
    ) {
        self.pixAllowedTaxIds = pixAllowedTaxIds
        self.transfersAllowedTaxId = transfersAllowedTaxId
        self.pseAllowedTaxIds = pseAllowedTaxIds
        self.pseFullName = pseFullName
        self.pseDocumentType = pseDocumentType
        self.pseDocumentNumber = pseDocumentNumber
        self.pseEmail = pseEmail
        self.psePhone = psePhone
        self.pseBankCode = pseBankCode
    }

    enum CodingKeys: String, CodingKey {
        case pixAllowedTaxIds = "pix_allowed_tax_ids"
        case transfersAllowedTaxId = "transfers_allowed_tax_id"
        case pseAllowedTaxIds = "pse_allowed_tax_ids"
        case pseFullName = "pse_full_name"
        case pseDocumentType = "pse_document_type"
        case pseDocumentNumber = "pse_document_number"
        case pseEmail = "pse_email"
        case psePhone = "pse_phone"
        case pseBankCode = "pse_bank_code"
    }
}

// MARK: - PayinQuote

/// Represents a payin quote
public struct PayinQuote: Codable, Sendable, Equatable {
    /// Unique identifier for the payin quote
    public let id: String

    /// Customer ID
    public let customerId: String

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
    public let expiresAt: Int?
    
    /// Currency
    public let currency: Currency?
    
    /// Commercial quotation
    public let commercialQuotation: Double?
    
    /// BlindPay quotation
    public let blindpayQuotation: Double?
    
    /// Receiver amount
    public let receiverAmount: Double?

    /// Sender amount
    public let senderAmount: Double?

    /// Partner fee amount
    public let partnerFeeAmount: Double?

    /// Flat fee
    public let flatFee: Double?

    /// Total fee amount
    public let totalFeeAmount: Double?

    /// Customer local amount
    public let customerLocalAmount: Double?

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
        customerId: String,
        paymentMethod: PaymentMethod,
        token: StablecoinToken? = nil,
        requestAmount: Int,
        coverFees: Bool? = nil,
        currencyType: CurrencyType,
        expiresAt: Int? = nil,
        currency: Currency? = nil,
        commercialQuotation: Double? = nil,
        blindpayQuotation: Double? = nil,
        receiverAmount: Double? = nil,
        senderAmount: Double? = nil,
        partnerFeeAmount: Double? = nil,
        flatFee: Double? = nil,
        totalFeeAmount: Double? = nil,
        customerLocalAmount: Double? = nil,
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
        self.customerId = customerId
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
        self.customerLocalAmount = customerLocalAmount
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
        case customerId = "customer_id"
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
        case customerLocalAmount = "customer_local_amount"
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

/// Input for creating a payin quote (`CreatePayinQuoteIn`)
public struct CreatePayinQuoteInput: Codable, Sendable {
    /// Blockchain wallet that receives the stablecoins. Set this or `walletId`.
    public let blockchainWalletId: String?

    /// Custodial wallet that receives the stablecoins. Set this or `blockchainWalletId`.
    public let walletId: String?

    /// Currency type (sender or receiver)
    public let currencyType: CurrencyType

    /// Whether the sender covers the fees
    public let coverFees: Bool?

    /// Request amount in dollars (major units). Sent as integer cents, rounded
    /// (19.99 -> 1999). The API's minimum is 500 cents.
    public let requestAmount: Double

    /// Payment method
    public let paymentMethod: PaymentMethod

    /// Stablecoin token to receive (required by the API)
    public let token: StablecoinToken

    /// Partner fee ID
    public let partnerFeeId: String?

    /// Payer rules restricting who may fund the payin
    public let payerRules: PayinQuotePayerRules?

    /// Whether this is an OTC (Over the Counter) quote
    public let isOtc: Bool?

    /// Plaid-connected bank account that funds an `ach_pull` payin. Required
    /// for `ach_pull`, not accepted otherwise.
    public let fundingBankAccountId: String?

    public init(
        blockchainWalletId: String? = nil,
        walletId: String? = nil,
        currencyType: CurrencyType,
        coverFees: Bool? = nil,
        requestAmount: Double,
        paymentMethod: PaymentMethod,
        token: StablecoinToken,
        partnerFeeId: String? = nil,
        payerRules: PayinQuotePayerRules? = nil,
        isOtc: Bool? = nil,
        fundingBankAccountId: String? = nil
    ) {
        self.blockchainWalletId = blockchainWalletId
        self.walletId = walletId
        self.currencyType = currencyType
        self.coverFees = coverFees
        self.requestAmount = requestAmount
        self.paymentMethod = paymentMethod
        self.token = token
        self.partnerFeeId = partnerFeeId
        self.payerRules = payerRules
        self.isOtc = isOtc
        self.fundingBankAccountId = fundingBankAccountId
    }

    enum CodingKeys: String, CodingKey {
        case blockchainWalletId = "blockchain_wallet_id"
        case walletId = "wallet_id"
        case currencyType = "currency_type"
        case coverFees = "cover_fees"
        case requestAmount = "request_amount"
        case paymentMethod = "payment_method"
        case token
        case partnerFeeId = "partner_fee_id"
        case payerRules = "payer_rules"
        case isOtc = "is_otc"
        case fundingBankAccountId = "funding_bank_account_id"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(blockchainWalletId, forKey: .blockchainWalletId)
        try container.encodeIfPresent(walletId, forKey: .walletId)
        try container.encode(currencyType, forKey: .currencyType)
        try container.encodeIfPresent(coverFees, forKey: .coverFees)
        // Convert dollars to integer cents, rounded (19.99 -> 1999)
        try container.encode(Amount.cents(fromMajorUnits: requestAmount, codingPath: container.codingPath + [CodingKeys.requestAmount]), forKey: .requestAmount)
        try container.encode(paymentMethod, forKey: .paymentMethod)
        try container.encode(token, forKey: .token)
        try container.encodeIfPresent(partnerFeeId, forKey: .partnerFeeId)
        try container.encodeIfPresent(payerRules, forKey: .payerRules)
        try container.encodeIfPresent(isOtc, forKey: .isOtc)
        try container.encodeIfPresent(fundingBankAccountId, forKey: .fundingBankAccountId)
    }
}

/// Card checkout details on a payin quote (present only for `card` payins)
public struct PayinQuoteCardInstruction: Codable, Sendable, Equatable {
    /// Card gateway that issued the tokenization key
    public let provider: String

    /// Public tokenization key for the gateway's browser library
    public let tokenizationKey: String

    /// Public key for the gateway's 3-D Secure SDK, if configured
    public let checkoutPublicKey: String?

    /// Signed checkout token. Always null on a quote; issued by Create Payin.
    public let checkoutToken: String?

    /// Hosted checkout URL. Always null on a quote; issued by Create Payin.
    public let checkoutUrl: String?

    public init(
        provider: String,
        tokenizationKey: String,
        checkoutPublicKey: String? = nil,
        checkoutToken: String? = nil,
        checkoutUrl: String? = nil
    ) {
        self.provider = provider
        self.tokenizationKey = tokenizationKey
        self.checkoutPublicKey = checkoutPublicKey
        self.checkoutToken = checkoutToken
        self.checkoutUrl = checkoutUrl
    }

    enum CodingKeys: String, CodingKey {
        case provider
        case tokenizationKey = "tokenization_key"
        case checkoutPublicKey = "checkout_public_key"
        case checkoutToken = "checkout_token"
        case checkoutUrl = "checkout_url"
    }
}

/// Response for creating a payin quote (`CreatePayinQuoteOut`).
///
/// Amounts are integer cents; quotations are decimal rates.
public struct CreatePayinQuoteResponse: Codable, Sendable, Equatable {
    /// Payin quote ID
    public let id: String

    /// Epoch milliseconds after which the quote can no longer be used
    /// (5 minutes after creation, 10 seconds for OTC quotes)
    public let expiresAt: Int?

    /// Commercial quotation (e.g. 1 USD = 4.95 BRL is 495)
    public let commercialQuotation: Double?

    /// BlindPay quotation (commercial quotation plus BlindPay fees)
    public let blindpayQuotation: Double?

    /// Amount the customer receives, in cents of the stablecoin
    public let receiverAmount: Int?

    /// Amount the payer must send, in cents of the fiat currency
    public let senderAmount: Int?

    /// Partner fee, in cents
    public let partnerFeeAmount: Int?

    /// Flat fee, in cents
    public let flatFee: Int?

    /// BlindPay fee accrued to the billing cycle, in cents
    public let billingFeeAmount: Int?

    /// Whether this is an OTC quote
    public let isOtc: Bool?

    /// Card checkout details; present only when `paymentMethod` is card
    public let cardInstruction: PayinQuoteCardInstruction?

    public init(
        id: String,
        expiresAt: Int? = nil,
        commercialQuotation: Double? = nil,
        blindpayQuotation: Double? = nil,
        receiverAmount: Int? = nil,
        senderAmount: Int? = nil,
        partnerFeeAmount: Int? = nil,
        flatFee: Int? = nil,
        billingFeeAmount: Int? = nil,
        isOtc: Bool? = nil,
        cardInstruction: PayinQuoteCardInstruction? = nil
    ) {
        self.id = id
        self.expiresAt = expiresAt
        self.commercialQuotation = commercialQuotation
        self.blindpayQuotation = blindpayQuotation
        self.receiverAmount = receiverAmount
        self.senderAmount = senderAmount
        self.partnerFeeAmount = partnerFeeAmount
        self.flatFee = flatFee
        self.billingFeeAmount = billingFeeAmount
        self.isOtc = isOtc
        self.cardInstruction = cardInstruction
    }

    enum CodingKeys: String, CodingKey {
        case id
        case expiresAt = "expires_at"
        case commercialQuotation = "commercial_quotation"
        case blindpayQuotation = "blindpay_quotation"
        case receiverAmount = "receiver_amount"
        case senderAmount = "sender_amount"
        case partnerFeeAmount = "partner_fee_amount"
        case flatFee = "flat_fee"
        case billingFeeAmount = "billing_fee_amount"
        case isOtc = "is_otc"
        case cardInstruction = "card_instruction"
    }
}

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
    
    /// Filter by customer ID
    public let customerId: String?

    public init(
        limit: String? = nil,
        offset: String? = nil,
        startingAfter: String? = nil,
        endingBefore: String? = nil,
        customerId: String? = nil
    ) {
        self.limit = limit
        self.offset = offset
        self.startingAfter = startingAfter
        self.endingBefore = endingBefore
        self.customerId = customerId
    }

    enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case startingAfter = "starting_after"
        case endingBefore = "ending_before"
        case customerId = "customer_id"
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
        if let customerId = customerId {
            params["customer_id"] = customerId
        }
        return params
    }
}
