//
//  Payin.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

// MARK: - Enums

/// Payin status
public struct PayinStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let processing = PayinStatus(rawValue: "processing")
    public static let onHold = PayinStatus(rawValue: "on_hold")
    public static let failed = PayinStatus(rawValue: "failed")
    public static let refunded = PayinStatus(rawValue: "refunded")
    public static let completed = PayinStatus(rawValue: "completed")
}

/// Manual execution status for payin
public struct ManualExecutionStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let pending = ManualExecutionStatus(rawValue: "pending")
    public static let concluded = ManualExecutionStatus(rawValue: "concluded")
    public static let failed = ManualExecutionStatus(rawValue: "failed")
}

/// Payment method for payin
public struct PaymentMethod: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let ach = PaymentMethod(rawValue: "ach")
    public static let achPull = PaymentMethod(rawValue: "ach_pull")
    public static let wire = PaymentMethod(rawValue: "wire")
    public static let pix = PaymentMethod(rawValue: "pix")
    public static let card = PaymentMethod(rawValue: "card")
    public static let spei = PaymentMethod(rawValue: "spei")
    public static let transfers = PaymentMethod(rawValue: "transfers")
    public static let pse = PaymentMethod(rawValue: "pse")
    public static let internationalSwift = PaymentMethod(rawValue: "international_swift")
    public static let rtp = PaymentMethod(rawValue: "rtp")
    public static let ted = PaymentMethod(rawValue: "ted")
    public static let breB = PaymentMethod(rawValue: "bre_b")
}

/// Payin type
public struct PayinType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let individual = PayinType(rawValue: "individual")
    public static let business = PayinType(rawValue: "business")
}

// MARK: - Tracking Types

/// Transaction tracking information for payin
public struct PayinTrackingTransaction: Codable, Sendable, Equatable {
  /// Step name
  public let step: String

  /// Status of the step
  public let status: String?

  /// External transaction ID
  public let externalId: String?

  /// Completion timestamp
  public let completedAt: String?

  /// Sender name
  public let senderName: String?

  /// Sender tax ID
  public let senderTaxId: String?

  /// Sender bank code
  public let senderBankCode: String?

  /// Sender account number
  public let senderAccountNumber: String?

  /// Trace number
  public let traceNumber: String?

  /// Transaction reference
  public let transactionReference: String?

  /// Description
  public let description: String?

  /// Card checkout details, for card payins.
  public let cardInstruction: PayinQuoteCardInstruction?

  public let cardClaimAt: String?

  public let cardEvidence: [String: AnyCodable]?

  public let cardFailedAttempts: Int?

  public let cardGatesFailedAt: String?





  /// BACEN Pix end-to-end transaction ID (govt Pix ID)
  public let endToEndId: String?

  /// Payment provider name
  public let providerName: String?

  /// Payment provider transaction id
  public let providerTransactionId: String?

  /// PSE (Colombia) payment link and payer details.
  public let pseInstruction: PayinPseInstruction?

  /// Name of the bank the funds came from.
  public let senderBankName: String?

  /// TED (Brazil) bank details to pay into.
  public let tedInstruction: PayinTedInstruction?

  /// Blockchain transaction hash
  public let transactionHash: String?

  /// Transfers (Argentina) account to pay into.
  public let transfersInstruction: PayinTransfersInstruction?

  public init(
    step: String,
    status: String? = nil,
    externalId: String? = nil,
    completedAt: String? = nil,
    senderName: String? = nil,
    senderTaxId: String? = nil,
    senderBankCode: String? = nil,
    senderAccountNumber: String? = nil,
    traceNumber: String? = nil,
    transactionReference: String? = nil,
    description: String? = nil,
    cardInstruction: PayinQuoteCardInstruction? = nil,
    cardClaimAt: String? = nil,
    cardEvidence: [String: AnyCodable]? = nil,
    cardFailedAttempts: Int? = nil,
    cardGatesFailedAt: String? = nil,
    endToEndId: String? = nil,
    providerName: String? = nil,
    providerTransactionId: String? = nil,
    pseInstruction: PayinPseInstruction? = nil,
    senderBankName: String? = nil,
    tedInstruction: PayinTedInstruction? = nil,
    transactionHash: String? = nil,
    transfersInstruction: PayinTransfersInstruction? = nil
  ) {
    self.step = step
    self.status = status
    self.externalId = externalId
    self.completedAt = completedAt
    self.senderName = senderName
    self.senderTaxId = senderTaxId
    self.senderBankCode = senderBankCode
    self.senderAccountNumber = senderAccountNumber
    self.traceNumber = traceNumber
    self.transactionReference = transactionReference
    self.description = description
    self.cardInstruction = cardInstruction
    self.cardClaimAt = cardClaimAt
    self.cardEvidence = cardEvidence
    self.cardFailedAttempts = cardFailedAttempts
    self.cardGatesFailedAt = cardGatesFailedAt
    self.endToEndId = endToEndId
    self.providerName = providerName
    self.providerTransactionId = providerTransactionId
    self.pseInstruction = pseInstruction
    self.senderBankName = senderBankName
    self.tedInstruction = tedInstruction
    self.transactionHash = transactionHash
    self.transfersInstruction = transfersInstruction
  }

  enum CodingKeys: String, CodingKey {
    case step
    case status
    case externalId = "external_id"
    case completedAt = "completed_at"
    case senderName = "sender_name"
    case senderTaxId = "sender_tax_id"
    case senderBankCode = "sender_bank_code"
    case senderAccountNumber = "sender_account_number"
    case traceNumber = "trace_number"
    case transactionReference = "transaction_reference"
    case description
    case cardInstruction = "card_instruction"
    case cardClaimAt = "card_claim_at"
    case cardEvidence = "card_evidence"
    case cardFailedAttempts = "card_failed_attempts"
    case cardGatesFailedAt = "card_gates_failed_at"
    case endToEndId = "end_to_end_id"
    case providerName = "provider_name"
    case providerTransactionId = "provider_transaction_id"
    case pseInstruction = "pse_instruction"
    case senderBankName = "sender_bank_name"
    case tedInstruction = "ted_instruction"
    case transactionHash = "transaction_hash"
    case transfersInstruction = "transfers_instruction"
  }
}

/// PSE (Colombia) payment instruction on a payin's `tracking_transaction`.
public struct PayinPseInstruction: Codable, Sendable, Equatable {
    /// PSE payment link URL.
    public let paymentLink: String?
    /// PSE provider reference used for webhook matching (the payin intent id).
    public let fid: String?
    /// PSE payin intent id at the provider.
    public let payinIntentId: String?
    /// When the PSE payment link expires.
    public let expiresAt: String?
    /// Payer full name.
    public let fullName: String?
    /// Payer document number.
    public let taxId: String?
    /// Payer document type (`CC` or `NIT`).
    public let documentType: String?
    /// Payer phone number.
    public let phone: String?
    /// Payer email.
    public let email: String?
    /// Payer bank code.
    public let bankCode: String?

    public init(
        paymentLink: String? = nil,
        fid: String? = nil,
        payinIntentId: String? = nil,
        expiresAt: String? = nil,
        fullName: String? = nil,
        taxId: String? = nil,
        documentType: String? = nil,
        phone: String? = nil,
        email: String? = nil,
        bankCode: String? = nil
    ) {
        self.paymentLink = paymentLink
        self.fid = fid
        self.payinIntentId = payinIntentId
        self.expiresAt = expiresAt
        self.fullName = fullName
        self.taxId = taxId
        self.documentType = documentType
        self.phone = phone
        self.email = email
        self.bankCode = bankCode
    }

    enum CodingKeys: String, CodingKey {
        case paymentLink = "payment_link"
        case fid
        case payinIntentId = "payin_intent_id"
        case expiresAt = "expires_at"
        case fullName = "full_name"
        case taxId = "tax_id"
        case documentType = "document_type"
        case phone
        case email
        case bankCode = "bank_code"
    }
}

/// TED (Brazil) bank details to pay a payin into.
public struct PayinTedInstruction: Codable, Sendable, Equatable {
    public let beneficiaryName: String?
    public let taxId: String?
    public let bankCode: String?
    public let bankName: String?
    public let branchCode: String?
    public let accountNumber: String?
    public let accountType: String?

    public init(
        beneficiaryName: String? = nil,
        taxId: String? = nil,
        bankCode: String? = nil,
        bankName: String? = nil,
        branchCode: String? = nil,
        accountNumber: String? = nil,
        accountType: String? = nil
    ) {
        self.beneficiaryName = beneficiaryName
        self.taxId = taxId
        self.bankCode = bankCode
        self.bankName = bankName
        self.branchCode = branchCode
        self.accountNumber = accountNumber
        self.accountType = accountType
    }

    enum CodingKeys: String, CodingKey {
        case beneficiaryName = "beneficiary_name"
        case taxId = "tax_id"
        case bankCode = "bank_code"
        case bankName = "bank_name"
        case branchCode = "branch_code"
        case accountNumber = "account_number"
        case accountType = "account_type"
    }
}

/// Transfers (Argentina) account to pay a payin into.
public struct PayinTransfersInstruction: Codable, Sendable, Equatable {
    /// CVU, CBU or alias account.
    public let account: String?
    /// Account type: `CVU`, `CBU` or `ALIAS`.
    public let type: String?
    /// CUIT/CUIL, digits only.
    public let taxId: String?

    public init(account: String? = nil, type: String? = nil, taxId: String? = nil) {
        self.account = account
        self.type = type
        self.taxId = taxId
    }

    enum CodingKeys: String, CodingKey {
        case account
        case type
        case taxId = "tax_id"
    }
}

/// Payment tracking information for payin
///
/// `@unchecked Sendable` because `reviewContexts` holds `AnyCodable`.
public struct PayinTrackingPayment: Codable, Equatable, @unchecked Sendable {
  /// Step name
  public let step: String

  /// Provider name
  public let providerName: String?

  /// Completion timestamp
  public let completedAt: String?

  /// Structured risk context per flagging source (free-form JSON object)
  public let reviewContexts: [String: AnyCodable]?

  public let reviewSources: [String]?

  /// Risk sources already approved by an analyst
  public let approvedRiskSources: [String]?

  /// Structured risk context for manual review
  public let reviewContext: [String: AnyCodable]?

  /// Primary risk source that sent this payin to manual review
  public let reviewSource: String?

  public init(step: String, providerName: String? = nil, completedAt: String? = nil, reviewContexts: [String: AnyCodable]? = nil, reviewSources: [String]? = nil, approvedRiskSources: [String]? = nil, reviewContext: [String: AnyCodable]? = nil, reviewSource: String? = nil) {
    self.step = step
    self.providerName = providerName
    self.completedAt = completedAt
    self.reviewContexts = reviewContexts
    self.reviewSources = reviewSources
    self.approvedRiskSources = approvedRiskSources
    self.reviewContext = reviewContext
    self.reviewSource = reviewSource
  }

  enum CodingKeys: String, CodingKey {
    case step
    case providerName = "provider_name"
    case completedAt = "completed_at"
    case reviewContexts = "review_contexts"
    case reviewSources = "review_sources"
    case approvedRiskSources = "approved_risk_sources"
    case reviewContext = "review_context"
    case reviewSource = "review_source"
  }
}

/// Complete tracking information for payin
public struct PayinTrackingComplete: Codable, Sendable, Equatable {
  /// Step name
  public let step: String

  /// Transaction hash
  public let transactionHash: String?

  /// Completion timestamp
  public let completedAt: String?

  public init(step: String, transactionHash: String? = nil, completedAt: String? = nil) {
    self.step = step
    self.transactionHash = transactionHash
    self.completedAt = completedAt
  }

  enum CodingKeys: String, CodingKey {
    case step
    case transactionHash = "transaction_hash"
    case completedAt = "completed_at"
  }
}

/// Partner fee tracking information for payin
public struct PayinTrackingPartnerFee: Codable, Sendable, Equatable {
  /// Step name
  public let step: String

  /// Transaction hash
  public let transactionHash: String?

  /// Completion timestamp
  public let completedAt: String?

  public init(step: String, transactionHash: String? = nil, completedAt: String? = nil) {
    self.step = step
    self.transactionHash = transactionHash
    self.completedAt = completedAt
  }

  enum CodingKeys: String, CodingKey {
    case step
    case transactionHash = "transaction_hash"
    case completedAt = "completed_at"
  }
}

// MARK: - Bank Details

/// ACH payment details
public struct ACHDetails: Codable, Sendable, Equatable {
  /// Routing number
  public let routingNumber: String

  /// Account number
  public let accountNumber: String

  public init(routingNumber: String, accountNumber: String) {
    self.routingNumber = routingNumber
    self.accountNumber = accountNumber
  }

  enum CodingKeys: String, CodingKey {
    case routingNumber = "routing_number"
    case accountNumber = "account_number"
  }
}

/// Wire payment details
public struct WireDetails: Codable, Sendable, Equatable {
  /// Routing number
  public let routingNumber: String

  /// Account number
  public let accountNumber: String

  public init(routingNumber: String, accountNumber: String) {
    self.routingNumber = routingNumber
    self.accountNumber = accountNumber
  }

  enum CodingKeys: String, CodingKey {
    case routingNumber = "routing_number"
    case accountNumber = "account_number"
  }
}

/// RTP payment details
public struct RTPDetails: Codable, Sendable, Equatable {
  /// Routing number
  public let routingNumber: String

  /// Account number
  public let accountNumber: String

  public init(routingNumber: String, accountNumber: String) {
    self.routingNumber = routingNumber
    self.accountNumber = accountNumber
  }

  enum CodingKeys: String, CodingKey {
    case routingNumber = "routing_number"
    case accountNumber = "account_number"
  }
}

/// Beneficiary information
public struct BeneficiaryInfo: Codable, Sendable, Equatable {
  /// Beneficiary name
  public let name: String?

  /// Address line 1
  public let addressLine1: String?

  /// Address line 2
  public let addressLine2: String?

  public init(name: String? = nil, addressLine1: String? = nil, addressLine2: String? = nil) {
    self.name = name
    self.addressLine1 = addressLine1
    self.addressLine2 = addressLine2
  }

  enum CodingKeys: String, CodingKey {
    case name
    case addressLine1 = "address_line_1"
    case addressLine2 = "address_line_2"
  }
}

/// Receiving bank information
public struct ReceivingBankInfo: Codable, Sendable, Equatable {
  /// Bank name
  public let name: String?

  /// Address line 1
  public let addressLine1: String?

  /// Address line 2
  public let addressLine2: String?

  public init(name: String? = nil, addressLine1: String? = nil, addressLine2: String? = nil) {
    self.name = name
    self.addressLine1 = addressLine1
    self.addressLine2 = addressLine2
  }

  enum CodingKeys: String, CodingKey {
    case name
    case addressLine1 = "address_line_1"
    case addressLine2 = "address_line_2"
  }
}

/// BlindPay bank details
public struct BlindPayBankDetails: Codable, Sendable, Equatable {
  /// Routing number
  public let routingNumber: String?

  /// Account number
  public let accountNumber: String?

  /// Account type
  public let accountType: String?

  /// SWIFT BIC code
  public let swiftBicCode: String?

  /// ACH payment details
  public let ach: ACHDetails?

  /// Wire payment details
  public let wire: WireDetails?

  /// RTP payment details
  public let rtp: RTPDetails?

  /// Beneficiary information
  public let beneficiary: BeneficiaryInfo?

  /// Receiving bank information
  public let receivingBank: ReceivingBankInfo?

  public init(
    routingNumber: String? = nil,
    accountNumber: String? = nil,
    accountType: String? = nil,
    swiftBicCode: String? = nil,
    ach: ACHDetails? = nil,
    wire: WireDetails? = nil,
    rtp: RTPDetails? = nil,
    beneficiary: BeneficiaryInfo? = nil,
    receivingBank: ReceivingBankInfo? = nil
  ) {
    self.routingNumber = routingNumber
    self.accountNumber = accountNumber
    self.accountType = accountType
    self.swiftBicCode = swiftBicCode
    self.ach = ach
    self.wire = wire
    self.rtp = rtp
    self.beneficiary = beneficiary
    self.receivingBank = receivingBank
  }

  enum CodingKeys: String, CodingKey {
    case routingNumber = "routing_number"
    case accountNumber = "account_number"
    case accountType = "account_type"
    case swiftBicCode = "swift_bic_code"
    case ach
    case wire
    case rtp
    case beneficiary
    case receivingBank = "receiving_bank"
  }
}

// MARK: - Payin

/// Represents a payin
public struct Payin: Codable, Sendable, Equatable {
  /// Unique identifier for the payin
  public let id: String

  /// Customer ID
  public let customerId: String

  /// PIX code for payment
  public let pixCode: String?

  /// Memo code for payment
  public let memoCode: String?

  /// CLABE code for payment
  public let clabe: String?

  /// Status of the payin
  public let status: PayinStatus

  /// Manual execution status
  public let manualExecutionStatus: ManualExecutionStatus?

  /// Payin quote ID
  public let payinQuoteId: String?

  /// Instance ID
  public let instanceId: String

  /// Transaction tracking information
  public let trackingTransaction: PayinTrackingTransaction?

  /// Payment tracking information
  public let trackingPayment: PayinTrackingPayment?

  /// Complete tracking information
  public let trackingComplete: PayinTrackingComplete?

  /// Partner fee tracking information
  public let trackingPartnerFee: PayinTrackingPartnerFee?

  /// Timestamp when the payin was created
  public let createdAt: String?

  /// Timestamp when the payin was last updated
  public let updatedAt: String?

  /// Image URL
  public let imageUrl: String?

  /// First name
  public let firstName: String?

  /// Last name
  public let lastName: String?

  /// Legal name
  public let legalName: String?

  /// Type (individual or company)
  public let type: PayinType?

  /// Payment method
  public let paymentMethod: PaymentMethod?

  /// Sender amount
  public let senderAmount: Int?

  /// Receiver amount
  public let receiverAmount: Int?

  /// Token
  public let token: StablecoinToken?

  /// Partner fee amount
  public let partnerFeeAmount: Int?

  /// Partner fee ID
  public let partnerFeeId: String?

  /// Total fee amount
  public let totalFeeAmount: Double?

  /// Commercial quotation
  public let commercialQuotation: Double?

  /// BlindPay quotation
  public let blindpayQuotation: Double?

  /// Currency
  public let currency: Currency?

  /// Billing fee
  public let billingFee: Int?

  /// Wallet display name
  public let name: String?

  /// Wallet address
  public let address: String?

  /// Network
  public let network: Network?

  /// BlindPay bank details
  public let blindpayBankDetails: BlindPayBankDetails?

  /// Whether this is an OTC transaction
  public let isOtc: Bool?

  /// Billing fee amount (in smallest currency unit)
  public let billingFeeAmount: Int?

  /// PSE document type
  public let pseDocumentType: String?

  /// PSE full name
  public let pseFullName: String?

  /// PSE payment link
  public let psePaymentLink: String?

  /// PSE tax ID
  public let pseTaxId: String?

  /// When `manual_execution_status` became `concluded`: an ISO 8601 string,
  /// or `nil`. `AnyCodable` because the spec declares no type for it; read
  /// it with `manualConcludedAt?.value as? String`.
  public let manualConcludedAt: AnyCodable?

  /// Identifier of the operator who marked the manual OTC concluded.
  public let manualConcludedBy: String?

  /// Payin partner fee amount in cents
  public let partnerFee: Int?

  /// Restrictions on who may fund this payin, copied from the payin quote.
  public let payerRules: PayinQuotePayerRules?

  /// BlindPay fee in cents deducted from the transaction at the time it is processed. Virtual account deposits of $100.00 or more are charged here (unless your instance is configured for end-of-month billing, in which case every fee accrues to billing_fee_amount).
  public let transactionFeeAmount: Int?

  public init(
    id: String,
    customerId: String,
    pixCode: String? = nil,
    memoCode: String? = nil,
    clabe: String? = nil,
    status: PayinStatus,
    manualExecutionStatus: ManualExecutionStatus? = nil,
    payinQuoteId: String? = nil,
    instanceId: String,
    trackingTransaction: PayinTrackingTransaction? = nil,
    trackingPayment: PayinTrackingPayment? = nil,
    trackingComplete: PayinTrackingComplete? = nil,
    trackingPartnerFee: PayinTrackingPartnerFee? = nil,
    createdAt: String? = nil,
    updatedAt: String? = nil,
    imageUrl: String? = nil,
    firstName: String? = nil,
    lastName: String? = nil,
    legalName: String? = nil,
    type: PayinType? = nil,
    paymentMethod: PaymentMethod? = nil,
    senderAmount: Int? = nil,
    receiverAmount: Int? = nil,
    token: StablecoinToken? = nil,
    partnerFeeAmount: Int? = nil,
    partnerFeeId: String? = nil,
    totalFeeAmount: Double? = nil,
    commercialQuotation: Double? = nil,
    blindpayQuotation: Double? = nil,
    currency: Currency? = nil,
    billingFee: Int? = nil,
    name: String? = nil,
    address: String? = nil,
    network: Network? = nil,
    blindpayBankDetails: BlindPayBankDetails? = nil,
    isOtc: Bool? = nil,
    billingFeeAmount: Int? = nil,
    pseDocumentType: String? = nil,
    pseFullName: String? = nil,
    psePaymentLink: String? = nil,
    pseTaxId: String? = nil,
    manualConcludedAt: AnyCodable? = nil,
    manualConcludedBy: String? = nil,
    partnerFee: Int? = nil,
    payerRules: PayinQuotePayerRules? = nil,
    transactionFeeAmount: Int? = nil
  ) {
    self.id = id
    self.customerId = customerId
    self.pixCode = pixCode
    self.memoCode = memoCode
    self.clabe = clabe
    self.status = status
    self.manualExecutionStatus = manualExecutionStatus
    self.payinQuoteId = payinQuoteId
    self.instanceId = instanceId
    self.trackingTransaction = trackingTransaction
    self.trackingPayment = trackingPayment
    self.trackingComplete = trackingComplete
    self.trackingPartnerFee = trackingPartnerFee
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.imageUrl = imageUrl
    self.firstName = firstName
    self.lastName = lastName
    self.legalName = legalName
    self.type = type
    self.paymentMethod = paymentMethod
    self.senderAmount = senderAmount
    self.receiverAmount = receiverAmount
    self.token = token
    self.partnerFeeAmount = partnerFeeAmount
    self.partnerFeeId = partnerFeeId
    self.totalFeeAmount = totalFeeAmount
    self.commercialQuotation = commercialQuotation
    self.blindpayQuotation = blindpayQuotation
    self.currency = currency
    self.billingFee = billingFee
    self.name = name
    self.address = address
    self.network = network
    self.blindpayBankDetails = blindpayBankDetails
    self.isOtc = isOtc
    self.billingFeeAmount = billingFeeAmount
    self.pseDocumentType = pseDocumentType
    self.pseFullName = pseFullName
    self.psePaymentLink = psePaymentLink
    self.pseTaxId = pseTaxId
    self.manualConcludedAt = manualConcludedAt
    self.manualConcludedBy = manualConcludedBy
    self.partnerFee = partnerFee
    self.payerRules = payerRules
    self.transactionFeeAmount = transactionFeeAmount
  }

  enum CodingKeys: String, CodingKey {
    case id
    case customerId = "customer_id"
    case pixCode = "pix_code"
    case memoCode = "memo_code"
    case clabe
    case status
    case manualExecutionStatus = "manual_execution_status"
    case payinQuoteId = "payin_quote_id"
    case instanceId = "instance_id"
    case trackingTransaction = "tracking_transaction"
    case trackingPayment = "tracking_payment"
    case trackingComplete = "tracking_complete"
    case trackingPartnerFee = "tracking_partner_fee"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case imageUrl = "image_url"
    case firstName = "first_name"
    case lastName = "last_name"
    case legalName = "legal_name"
    case type
    case paymentMethod = "payment_method"
    case senderAmount = "sender_amount"
    case receiverAmount = "receiver_amount"
    case token
    case partnerFeeAmount = "partner_fee_amount"
    case partnerFeeId = "partner_fee_id"
    case totalFeeAmount = "total_fee_amount"
    case commercialQuotation = "commercial_quotation"
    case blindpayQuotation = "blindpay_quotation"
    case currency
    case billingFee = "billing_fee"
    case name
    case address
    case network
    case blindpayBankDetails = "blindpay_bank_details"
    case isOtc = "is_otc"
    case billingFeeAmount = "billing_fee_amount"
    case pseDocumentType = "pse_document_type"
    case pseFullName = "pse_full_name"
    case psePaymentLink = "pse_payment_link"
    case pseTaxId = "pse_tax_id"
    case manualConcludedAt = "manual_concluded_at"
    case manualConcludedBy = "manual_concluded_by"
    case partnerFee = "partner_fee"
    case payerRules = "payer_rules"
    case transactionFeeAmount = "transaction_fee_amount"
  }
}

// MARK: - Response Types

/// One page of payins (see ``ListResult``).
public typealias ListPayinsResponse = ListResult<Payin>

/// Response type for single payin
public typealias PayinResponse = Payin

// MARK: - Input Types

/// Filters and cursors for listing payins. Every value is optional; unset ones are not sent.
public struct ListPayinsInput: CursorPaginatedInput {
  /// Page size (10, 50, 100, 200, 500 or 1000).
  public var limit: Int?

  /// Return items after this id (the previous page's `pagination.nextPage`).
  public var startingAfter: String?

  /// Return items before this id.
  public var endingBefore: String?

  /// Only this customer.
  public var customerId: String?

  /// Only this status.
  public var status: PayinStatus?

  /// Customer name contains this text.
  public var customerName: String?

  /// Only this bank account.
  public var bankAccountId: String?

  /// Only this country.
  public var country: Country?

  /// Only this payment method.
  public var paymentMethod: PaymentMethod?

  /// Only this network.
  public var network: Network?

  /// Only this token.
  public var token: StablecoinToken?

  /// Deprecated: the API ignores `offset`. Use `startingAfter`.
  @available(*, deprecated, message: "Ignored by the API; use startingAfter.")
  public var offset: Int? {
    get { legacyOffset }
    set { legacyOffset = newValue }
  }
  private var legacyOffset: Int?

  public init(
    limit: Int? = nil,
    startingAfter: String? = nil,
    endingBefore: String? = nil,
    customerId: String? = nil,
    status: PayinStatus? = nil,
    customerName: String? = nil,
    bankAccountId: String? = nil,
    country: Country? = nil,
    paymentMethod: PaymentMethod? = nil,
    network: Network? = nil,
    token: StablecoinToken? = nil
  ) {
    self.limit = limit
    self.startingAfter = startingAfter
    self.endingBefore = endingBefore
    self.customerId = customerId
    self.status = status
    self.customerName = customerName
    self.bankAccountId = bankAccountId
    self.country = country
    self.paymentMethod = paymentMethod
    self.network = network
    self.token = token
  }

  func toQueryParameters() -> QueryParameters {
    var params = QueryParameters()
    params["limit"] = limit.map(String.init)
    params["offset"] = legacyOffset.map(String.init)
    params["starting_after"] = startingAfter
    params["ending_before"] = endingBefore
    params["customer_id"] = customerId
    params["status"] = status?.rawValue
    params["customer_name"] = customerName
    params["bank_account_id"] = bankAccountId
    params["country"] = country?.rawValue
    params["payment_method"] = paymentMethod?.rawValue
    params["network"] = network?.rawValue
    params["token"] = token?.rawValue
    return params
  }
}

/// Input for creating a payin on EVM chains
public struct CreatePayinInput: Codable, Sendable {
  /// Payin quote ID
  public let payinQuoteId: String

  public init(payinQuoteId: String) {
    self.payinQuoteId = payinQuoteId
  }

  enum CodingKeys: String, CodingKey {
    case payinQuoteId = "payin_quote_id"
  }
}

/// Response type for creating a payin
public struct CreatePayinResponse: Codable, Sendable {
  /// Unique identifier for the created payin
  public let id: String

  /// Status of the payin
  public let status: PayinStatus

  /// PIX code for payment
  public let pixCode: String?

  /// Memo code for payment
  public let memoCode: String?

  /// CLABE code for payment
  public let clabe: String?

  /// Complete tracking information
  public let trackingComplete: PayinTrackingComplete

  /// Payment tracking information
  public let trackingPayment: PayinTrackingPayment

  /// Transaction tracking information
  public let trackingTransaction: PayinTrackingTransaction

  /// Partner fee tracking information
  public let trackingPartnerFee: PayinTrackingPartnerFee?

  /// BlindPay bank details
  public let blindpayBankDetails: BlindPayBankDetails

  /// Customer ID
  public let customerId: String?

  /// Receiver amount
  public let receiverAmount: Int?

  /// Payment method
  public let paymentMethod: PaymentMethod?

  /// Billing fee
  public let billingFee: Int?

  /// Sender amount
  public let senderAmount: Int?

  /// BlindPay fee in cents accrued to your billing cycle (charged at the end of the month). Virtual account deposits below $100.00 always accrue here, so small deposits are delivered in full.
  public let billingFeeAmount: Int?

  /// Payin partner fee amount in cents
  public let partnerFee: Int?

  /// BlindPay fee in cents deducted from the transaction at the time it is processed. Virtual account deposits of $100.00 or more are charged here (unless your instance is configured for end-of-month billing, in which case every fee accrues to billing_fee_amount).
  public let transactionFeeAmount: Int?

  public init(
    id: String,
    status: PayinStatus,
    pixCode: String? = nil,
    memoCode: String? = nil,
    clabe: String? = nil,
    trackingComplete: PayinTrackingComplete,
    trackingPayment: PayinTrackingPayment,
    trackingTransaction: PayinTrackingTransaction,
    trackingPartnerFee: PayinTrackingPartnerFee? = nil,
    blindpayBankDetails: BlindPayBankDetails,
    customerId: String? = nil,
    receiverAmount: Int? = nil,
    paymentMethod: PaymentMethod? = nil,
    billingFee: Int? = nil,
    senderAmount: Int? = nil,
    billingFeeAmount: Int? = nil,
    partnerFee: Int? = nil,
    transactionFeeAmount: Int? = nil
  ) {
    self.id = id
    self.status = status
    self.pixCode = pixCode
    self.memoCode = memoCode
    self.clabe = clabe
    self.trackingComplete = trackingComplete
    self.trackingPayment = trackingPayment
    self.trackingTransaction = trackingTransaction
    self.trackingPartnerFee = trackingPartnerFee
    self.blindpayBankDetails = blindpayBankDetails
    self.customerId = customerId
    self.receiverAmount = receiverAmount
    self.paymentMethod = paymentMethod
    self.billingFee = billingFee
    self.senderAmount = senderAmount
    self.billingFeeAmount = billingFeeAmount
    self.partnerFee = partnerFee
    self.transactionFeeAmount = transactionFeeAmount
  }

  enum CodingKeys: String, CodingKey {
    case id
    case status
    case pixCode = "pix_code"
    case memoCode = "memo_code"
    case clabe
    case trackingComplete = "tracking_complete"
    case trackingPayment = "tracking_payment"
    case trackingTransaction = "tracking_transaction"
    case trackingPartnerFee = "tracking_partner_fee"
    case blindpayBankDetails = "blindpay_bank_details"
    case customerId = "customer_id"
    case receiverAmount = "receiver_amount"
    case paymentMethod = "payment_method"
    case billingFee = "billing_fee"
    case senderAmount = "sender_amount"
    case billingFeeAmount = "billing_fee_amount"
    case partnerFee = "partner_fee"
    case transactionFeeAmount = "transaction_fee_amount"
  }
}
