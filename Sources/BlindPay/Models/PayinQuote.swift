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

    /// Amount in integer cents (`1999` = 19.99), or whole units for currencies
    /// without cents. Convert with ``Amount/cents(fromMajorUnits:)``. The API
    /// enforces a per-currency minimum and returns 400 below it.
    public let requestAmount: Int

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
        requestAmount: Int,
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
        try container.encode(requestAmount, forKey: .requestAmount)
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

