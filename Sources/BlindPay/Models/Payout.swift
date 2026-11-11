//
//  Payout.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

// MARK: - Enums

/// Payout status
public struct PayoutStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let processing = PayoutStatus(rawValue: "processing")
    public static let onHold = PayoutStatus(rawValue: "on_hold")
    public static let failed = PayoutStatus(rawValue: "failed")
    public static let refunded = PayoutStatus(rawValue: "refunded")
    public static let completed = PayoutStatus(rawValue: "completed")
}

/// Tracking step
public struct TrackingStep: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let processing = TrackingStep(rawValue: "processing")
    public static let onHold = TrackingStep(rawValue: "on_hold")
    public static let completed = TrackingStep(rawValue: "completed")
    public static let pendingRefundReview = TrackingStep(rawValue: "pending_refund_review")
}

/// Provider status for liquidity tracking
public struct ProviderStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let deposited = ProviderStatus(rawValue: "deposited")
    public static let converted = ProviderStatus(rawValue: "converted")
    public static let withdrawn = ProviderStatus(rawValue: "withdrawn")
}

/// Provider status for payment tracking
public struct PaymentProviderStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let canceled = PaymentProviderStatus(rawValue: "canceled")
    public static let failed = PaymentProviderStatus(rawValue: "failed")
    public static let returned = PaymentProviderStatus(rawValue: "returned")
    public static let sent = PaymentProviderStatus(rawValue: "sent")
}

/// Payment type for payout
public struct PaymentType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let wire = PaymentType(rawValue: "wire")
    public static let ach = PaymentType(rawValue: "ach")
    public static let pix = PaymentType(rawValue: "pix")
    public static let pixSafe = PaymentType(rawValue: "pix_safe")
    public static let speiBitso = PaymentType(rawValue: "spei_bitso")
    public static let transfersBitso = PaymentType(rawValue: "transfers_bitso")
    public static let achCopBitso = PaymentType(rawValue: "ach_cop_bitso")
    public static let internationalSwift = PaymentType(rawValue: "international_swift")
    public static let rtp = PaymentType(rawValue: "rtp")
    public static let ted = PaymentType(rawValue: "ted")
    public static let fasterPayments = PaymentType(rawValue: "faster_payments")
}

/// Account type
public struct AccountType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let checking = AccountType(rawValue: "checking")
    public static let saving = AccountType(rawValue: "saving")
}


/// ACH COP document type
public struct AchCopDocumentType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let cc = AchCopDocumentType(rawValue: "CC")
    public static let ce = AchCopDocumentType(rawValue: "CE")
    public static let nit = AchCopDocumentType(rawValue: "NIT")
    public static let pass = AchCopDocumentType(rawValue: "PASS")
    public static let pep = AchCopDocumentType(rawValue: "PEP")
}

/// Estimated time of arrival
public struct EstimatedTimeOfArrival: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let fiveMin = EstimatedTimeOfArrival(rawValue: "5_min")
    public static let thirtyMin = EstimatedTimeOfArrival(rawValue: "30_min")
    public static let twoHours = EstimatedTimeOfArrival(rawValue: "2_hours")
    public static let oneBusinessDay = EstimatedTimeOfArrival(rawValue: "1_business_day")
    public static let twoBusinessDays = EstimatedTimeOfArrival(rawValue: "2_business_days")
    public static let fiveBusinessDays = EstimatedTimeOfArrival(rawValue: "5_business_days")
}

/// Tracking complete status
public struct TrackingCompleteStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let tokensRefunded = TrackingCompleteStatus(rawValue: "tokens_refunded")
    public static let paid = TrackingCompleteStatus(rawValue: "paid")
}

/// Tracking transaction status
public struct TrackingTransactionStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let failed = TrackingTransactionStatus(rawValue: "failed")
    public static let found = TrackingTransactionStatus(rawValue: "found")
}

/// SPEI protocol
public struct SpeiProtocol: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let clabe = SpeiProtocol(rawValue: "clabe")
    public static let debitcard = SpeiProtocol(rawValue: "debitcard")
    public static let phonenum = SpeiProtocol(rawValue: "phonenum")
}

/// Transfers type
public struct TransfersType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let cvu = TransfersType(rawValue: "CVU")
    public static let cbu = TransfersType(rawValue: "CBU")
    public static let alias = TransfersType(rawValue: "ALIAS")
}

// MARK: - Tracking Types

/// Transaction tracking information for payout
public struct PayoutTrackingTransaction: Codable, Sendable, Equatable {
  /// Step name
  public let step: TrackingStep

  /// Status of the step
  public let status: TrackingTransactionStatus?

  /// Transaction hash
  public let transactionHash: String?

  /// Completion timestamp
  public let completedAt: String?

  public init(
    step: TrackingStep,
    status: TrackingTransactionStatus? = nil,
    transactionHash: String? = nil,
    completedAt: String? = nil
  ) {
    self.step = step
    self.status = status
    self.transactionHash = transactionHash
    self.completedAt = completedAt
  }

  enum CodingKeys: String, CodingKey {
    case step
    case status
    case transactionHash = "transaction_hash"
    case completedAt = "completed_at"
  }
}

/// Payment tracking information for payout
public struct PayoutTrackingPayment: Codable, Sendable, Equatable {
  /// Step name
  public let step: TrackingStep

  /// Provider name
  public let providerName: String?

  /// Provider transaction ID
  public let providerTransactionId: String?

  /// Provider status
  public let providerStatus: PaymentProviderStatus?

  /// Recipient name
  public let recipientName: String?

  /// Recipient tax ID
  public let recipientTaxId: String?

  /// Recipient bank code
  public let recipientBankCode: String?

  /// Recipient branch code
  public let recipientBranchCode: String?

  /// Recipient account number
  public let recipientAccountNumber: String?

  /// Recipient account type
  public let recipientAccountType: String?

  /// Estimated time of arrival
  public let estimatedTimeOfArrival: EstimatedTimeOfArrival?

  /// Completion timestamp
  public let completedAt: String?

  public let refundReviewActionedAt: String?

  public let refundReviewDetectedAt: String?

  public let refundReviewReason: String?

  public let returnedAmount: Int?

  public let reviewContext: [String: AnyCodable]?

  public let reviewSource: String?

  public let reviewSources: [String]?















  public init(
    step: TrackingStep,
    providerName: String? = nil,
    providerTransactionId: String? = nil,
    providerStatus: PaymentProviderStatus? = nil,
    recipientName: String? = nil,
    recipientTaxId: String? = nil,
    recipientBankCode: String? = nil,
    recipientBranchCode: String? = nil,
    recipientAccountNumber: String? = nil,
    recipientAccountType: String? = nil,
    estimatedTimeOfArrival: EstimatedTimeOfArrival? = nil,
    completedAt: String? = nil,
    refundReviewActionedAt: String? = nil,
    refundReviewDetectedAt: String? = nil,
    refundReviewReason: String? = nil,
    returnedAmount: Int? = nil,
    reviewContext: [String: AnyCodable]? = nil,
    reviewSource: String? = nil,
    reviewSources: [String]? = nil
  ) {
    self.step = step
    self.providerName = providerName
    self.providerTransactionId = providerTransactionId
    self.providerStatus = providerStatus
    self.recipientName = recipientName
    self.recipientTaxId = recipientTaxId
    self.recipientBankCode = recipientBankCode
    self.recipientBranchCode = recipientBranchCode
    self.recipientAccountNumber = recipientAccountNumber
    self.recipientAccountType = recipientAccountType
    self.estimatedTimeOfArrival = estimatedTimeOfArrival
    self.completedAt = completedAt
    self.refundReviewActionedAt = refundReviewActionedAt
    self.refundReviewDetectedAt = refundReviewDetectedAt
    self.refundReviewReason = refundReviewReason
    self.returnedAmount = returnedAmount
    self.reviewContext = reviewContext
    self.reviewSource = reviewSource
    self.reviewSources = reviewSources
  }

  enum CodingKeys: String, CodingKey {
    case step
    case providerName = "provider_name"
    case providerTransactionId = "provider_transaction_id"
    case providerStatus = "provider_status"
    case recipientName = "recipient_name"
    case recipientTaxId = "recipient_tax_id"
    case recipientBankCode = "recipient_bank_code"
    case recipientBranchCode = "recipient_branch_code"
    case recipientAccountNumber = "recipient_account_number"
    case recipientAccountType = "recipient_account_type"
    case estimatedTimeOfArrival = "estimated_time_of_arrival"
    case completedAt = "completed_at"
    case refundReviewActionedAt = "refund_review_actioned_at"
    case refundReviewDetectedAt = "refund_review_detected_at"
    case refundReviewReason = "refund_review_reason"
    case returnedAmount = "returned_amount"
    case reviewContext = "review_context"
    case reviewSource = "review_source"
    case reviewSources = "review_sources"
  }
}

/// Liquidity tracking information for payout
public struct PayoutTrackingLiquidity: Codable, Sendable, Equatable {
  /// Step name
  public let step: TrackingStep

  /// Provider transaction ID
  public let providerTransactionId: String?

  /// Provider status
  public let providerStatus: ProviderStatus?

  /// Estimated time of arrival
  public let estimatedTimeOfArrival: EstimatedTimeOfArrival?

  /// Completion timestamp
  public let completedAt: String?

  public init(
    step: TrackingStep,
    providerTransactionId: String? = nil,
    providerStatus: ProviderStatus? = nil,
    estimatedTimeOfArrival: EstimatedTimeOfArrival? = nil,
    completedAt: String? = nil
  ) {
    self.step = step
    self.providerTransactionId = providerTransactionId
    self.providerStatus = providerStatus
    self.estimatedTimeOfArrival = estimatedTimeOfArrival
    self.completedAt = completedAt
  }

  enum CodingKeys: String, CodingKey {
    case step
    case providerTransactionId = "provider_transaction_id"
    case providerStatus = "provider_status"
    case estimatedTimeOfArrival = "estimated_time_of_arrival"
    case completedAt = "completed_at"
  }
}

/// Complete tracking information for payout
public struct PayoutTrackingComplete: Codable, Sendable, Equatable {
  /// Step name
  public let step: TrackingStep

  /// Status
  public let status: TrackingCompleteStatus?

  /// Transaction hash
  public let transactionHash: String?

  /// Completion timestamp
  public let completedAt: String?

  public init(
    step: TrackingStep,
    status: TrackingCompleteStatus? = nil,
    transactionHash: String? = nil,
    completedAt: String? = nil
  ) {
    self.step = step
    self.status = status
    self.transactionHash = transactionHash
    self.completedAt = completedAt
  }

  enum CodingKeys: String, CodingKey {
    case step
    case status
    case transactionHash = "transaction_hash"
    case completedAt = "completed_at"
  }
}

/// Partner fee tracking information for payout
public struct PayoutTrackingPartnerFee: Codable, Sendable, Equatable {
  /// Step name
  public let step: TrackingStep

  /// Transaction hash
  public let transactionHash: String?

  /// Completion timestamp
  public let completedAt: String?

  public init(
    step: TrackingStep,
    transactionHash: String? = nil,
    completedAt: String? = nil
  ) {
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

// MARK: - Payout

/// Represents a payout
public struct Payout: Codable, Sendable, Equatable {
  /// Unique identifier for the payout
  public let id: String

  /// Customer ID
  public let customerId: String

  /// Status of the payout
  public let status: PayoutStatus

  /// Sender wallet address
  public let senderWalletAddress: String

  /// Signed transaction (optional, for Stellar)
  public let signedTransaction: String?

  /// Quote ID
  public let quoteId: String

  /// Instance ID
  public let instanceId: String

  /// Transaction tracking information
  public let trackingTransaction: PayoutTrackingTransaction?

  /// Payment tracking information
  public let trackingPayment: PayoutTrackingPayment?

  /// Liquidity tracking information
  public let trackingLiquidity: PayoutTrackingLiquidity?

  /// Complete tracking information
  public let trackingComplete: PayoutTrackingComplete?

  /// Partner fee tracking information
  public let trackingPartnerFee: PayoutTrackingPartnerFee?

  /// Timestamp when the payout was created
  public let createdAt: String?

  /// Timestamp when the payout was last updated
  public let updatedAt: String?

  /// Image URL
  public let imageUrl: String?

  /// First name
  public let firstName: String?

  /// Last name
  public let lastName: String?

  /// Legal name
  public let legalName: String?

  /// Network
  public let network: Network

  /// Token
  public let token: StablecoinToken

  /// Description
  public let description: String?

  /// Sender amount (in smallest currency unit)
  public let senderAmount: Int?

  /// Receiver amount (in smallest currency unit)
  public let receiverAmount: Int?

  /// Partner fee amount (in smallest currency unit)
  public let partnerFeeAmount: Int?

  /// Partner fee ID
  public let partnerFeeId: String?

  /// Billing fee amount
  public let billingFeeAmount: Double?

  /// CPN payment ID
  public let cpnPaymentId: String?

  /// TED bank code
  public let tedBankCode: String?

  /// TED branch code
  public let tedBranchCode: String?

  /// TED CPF/CNPJ
  public let tedCpfCnpj: String?

  /// Commercial quotation
  public let commercialQuotation: Double?

  /// BlindPay quotation
  public let blindpayQuotation: Double?

  /// Total fee amount
  public let totalFeeAmount: Double?

  /// Customer local amount (in smallest currency unit)
  public let customerLocalAmount: Int?

  /// Currency
  public let currency: Currency

  /// Transaction document file URL
  public let transactionDocumentFile: String?

  /// Transaction document type
  public let transactionDocumentType: TransactionDocumentType?

  /// Transaction document ID
  public let transactionDocumentId: String?

  /// Name (null until known for some payment types)
  public let name: String?

  /// Payment type (nullable in the API)
  public let type: PaymentType?

  /// PIX key
  public let pixKey: String?

  /// PIX safe bank code
  public let pixSafeBankCode: String?

  /// PIX safe branch code
  public let pixSafeBranchCode: String?

  /// PIX safe CPF/CNPJ
  public let pixSafeCpfCnpj: String?

  /// Account number
  public let accountNumber: String?

  /// Routing number
  public let routingNumber: String?

  /// Country
  public let country: Country?

  /// Account class
  public let accountClass: AccountClass?

  /// Address line 1
  public let addressLine1: String?

  /// Address line 2
  public let addressLine2: String?

  /// City
  public let city: String?

  /// State/Province/Region
  public let stateProvinceRegion: String?

  /// Postal code
  public let postalCode: String?

  /// Account type
  public let accountType: AccountType?

  /// ACH COP beneficiary first name
  public let achCopBeneficiaryFirstName: String?

  /// ACH COP bank account
  public let achCopBankAccount: String?

  /// ACH COP bank code
  public let achCopBankCode: String?

  /// ACH COP beneficiary last name
  public let achCopBeneficiaryLastName: String?

  /// ACH COP document ID
  public let achCopDocumentId: String?

  /// ACH COP document type
  public let achCopDocumentType: AchCopDocumentType?

  /// ACH COP email
  public let achCopEmail: String?

  /// Beneficiary name
  public let beneficiaryName: String?

  /// SPEI CLABE
  public let speiClabe: String?

  /// SPEI protocol
  public let speiProtocol: SpeiProtocol?

  /// SPEI institution code
  public let speiInstitutionCode: String?

  /// SWIFT beneficiary country
  public let swiftBeneficiaryCountry: Country?

  /// SWIFT code BIC
  public let swiftCodeBic: String?

  /// SWIFT account holder name
  public let swiftAccountHolderName: String?

  /// SWIFT account number IBAN
  public let swiftAccountNumberIban: String?

  /// Transfers account
  public let transfersAccount: String?

  /// Transfers type
  public let transfersType: TransfersType?

  /// Has virtual account
  public let hasVirtualAccount: Bool?

  public let bankAccountId: String?

  public let fasterPaymentsAccountNumber: String?

  public let fasterPaymentsBeneficiaryAddressLine1: String?

  public let fasterPaymentsBeneficiaryCity: String?

  public let fasterPaymentsBeneficiaryCountry: Country?

  public let fasterPaymentsBeneficiaryLegalName: String?

  public let fasterPaymentsBeneficiaryPostalCode: String?

  public let fasterPaymentsSortCode: String?

  public let payableId: String?

  public let sepaBeneficiaryAddressLine1: String?

  public let sepaBeneficiaryCity: String?

  public let sepaBeneficiaryCountry: Country?

  public let sepaBeneficiaryLegalName: String?

  public let sepaBeneficiaryPostalCode: String?

  public let sepaIban: String?

  public init(
    id: String,
    customerId: String,
    status: PayoutStatus,
    senderWalletAddress: String,
    signedTransaction: String? = nil,
    quoteId: String,
    instanceId: String,
    trackingTransaction: PayoutTrackingTransaction? = nil,
    trackingPayment: PayoutTrackingPayment? = nil,
    trackingLiquidity: PayoutTrackingLiquidity? = nil,
    trackingComplete: PayoutTrackingComplete? = nil,
    trackingPartnerFee: PayoutTrackingPartnerFee? = nil,
    createdAt: String? = nil,
    updatedAt: String? = nil,
    imageUrl: String? = nil,
    firstName: String? = nil,
    lastName: String? = nil,
    legalName: String? = nil,
    network: Network,
    token: StablecoinToken,
    description: String? = nil,
    senderAmount: Int? = nil,
    receiverAmount: Int? = nil,
    partnerFeeAmount: Int? = nil,
    partnerFeeId: String? = nil,
    billingFeeAmount: Double? = nil,
    cpnPaymentId: String? = nil,
    tedBankCode: String? = nil,
    tedBranchCode: String? = nil,
    tedCpfCnpj: String? = nil,
    commercialQuotation: Double? = nil,
    blindpayQuotation: Double? = nil,
    totalFeeAmount: Double? = nil,
    customerLocalAmount: Int? = nil,
    currency: Currency,
    transactionDocumentFile: String? = nil,
    transactionDocumentType: TransactionDocumentType? = nil,
    transactionDocumentId: String? = nil,
    name: String? = nil,
    type: PaymentType? = nil,
    pixKey: String? = nil,
    pixSafeBankCode: String? = nil,
    pixSafeBranchCode: String? = nil,
    pixSafeCpfCnpj: String? = nil,
    accountNumber: String? = nil,
    routingNumber: String? = nil,
    country: Country? = nil,
    accountClass: AccountClass? = nil,
    addressLine1: String? = nil,
    addressLine2: String? = nil,
    city: String? = nil,
    stateProvinceRegion: String? = nil,
    postalCode: String? = nil,
    accountType: AccountType? = nil,
    achCopBeneficiaryFirstName: String? = nil,
    achCopBankAccount: String? = nil,
    achCopBankCode: String? = nil,
    achCopBeneficiaryLastName: String? = nil,
    achCopDocumentId: String? = nil,
    achCopDocumentType: AchCopDocumentType? = nil,
    achCopEmail: String? = nil,
    beneficiaryName: String? = nil,
    speiClabe: String? = nil,
    speiProtocol: SpeiProtocol? = nil,
    speiInstitutionCode: String? = nil,
    swiftBeneficiaryCountry: Country? = nil,
    swiftCodeBic: String? = nil,
    swiftAccountHolderName: String? = nil,
    swiftAccountNumberIban: String? = nil,
    transfersAccount: String? = nil,
    transfersType: TransfersType? = nil,
    hasVirtualAccount: Bool? = nil,
    bankAccountId: String? = nil,
    fasterPaymentsAccountNumber: String? = nil,
    fasterPaymentsBeneficiaryAddressLine1: String? = nil,
    fasterPaymentsBeneficiaryCity: String? = nil,
    fasterPaymentsBeneficiaryCountry: Country? = nil,
    fasterPaymentsBeneficiaryLegalName: String? = nil,
    fasterPaymentsBeneficiaryPostalCode: String? = nil,
    fasterPaymentsSortCode: String? = nil,
    payableId: String? = nil,
    sepaBeneficiaryAddressLine1: String? = nil,
    sepaBeneficiaryCity: String? = nil,
    sepaBeneficiaryCountry: Country? = nil,
    sepaBeneficiaryLegalName: String? = nil,
    sepaBeneficiaryPostalCode: String? = nil,
    sepaIban: String? = nil
  ) {
    self.id = id
    self.customerId = customerId
    self.status = status
    self.senderWalletAddress = senderWalletAddress
    self.signedTransaction = signedTransaction
    self.quoteId = quoteId
    self.instanceId = instanceId
    self.trackingTransaction = trackingTransaction
    self.trackingPayment = trackingPayment
    self.trackingLiquidity = trackingLiquidity
    self.trackingComplete = trackingComplete
    self.trackingPartnerFee = trackingPartnerFee
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.imageUrl = imageUrl
    self.firstName = firstName
    self.lastName = lastName
    self.legalName = legalName
    self.network = network
    self.token = token
    self.description = description
    self.senderAmount = senderAmount
    self.receiverAmount = receiverAmount
    self.partnerFeeAmount = partnerFeeAmount
    self.partnerFeeId = partnerFeeId
    self.billingFeeAmount = billingFeeAmount
    self.cpnPaymentId = cpnPaymentId
    self.tedBankCode = tedBankCode
    self.tedBranchCode = tedBranchCode
    self.tedCpfCnpj = tedCpfCnpj
    self.commercialQuotation = commercialQuotation
    self.blindpayQuotation = blindpayQuotation
    self.totalFeeAmount = totalFeeAmount
    self.customerLocalAmount = customerLocalAmount
    self.currency = currency
    self.transactionDocumentFile = transactionDocumentFile
    self.transactionDocumentType = transactionDocumentType
    self.transactionDocumentId = transactionDocumentId
    self.name = name
    self.type = type
    self.pixKey = pixKey
    self.pixSafeBankCode = pixSafeBankCode
    self.pixSafeBranchCode = pixSafeBranchCode
    self.pixSafeCpfCnpj = pixSafeCpfCnpj
    self.accountNumber = accountNumber
    self.routingNumber = routingNumber
    self.country = country
    self.accountClass = accountClass
    self.addressLine1 = addressLine1
    self.addressLine2 = addressLine2
    self.city = city
    self.stateProvinceRegion = stateProvinceRegion
    self.postalCode = postalCode
    self.accountType = accountType
    self.achCopBeneficiaryFirstName = achCopBeneficiaryFirstName
    self.achCopBankAccount = achCopBankAccount
    self.achCopBankCode = achCopBankCode
    self.achCopBeneficiaryLastName = achCopBeneficiaryLastName
    self.achCopDocumentId = achCopDocumentId
    self.achCopDocumentType = achCopDocumentType
    self.achCopEmail = achCopEmail
    self.beneficiaryName = beneficiaryName
    self.speiClabe = speiClabe
    self.speiProtocol = speiProtocol
    self.speiInstitutionCode = speiInstitutionCode
    self.swiftBeneficiaryCountry = swiftBeneficiaryCountry
    self.swiftCodeBic = swiftCodeBic
    self.swiftAccountHolderName = swiftAccountHolderName
    self.swiftAccountNumberIban = swiftAccountNumberIban
    self.transfersAccount = transfersAccount
    self.transfersType = transfersType
    self.hasVirtualAccount = hasVirtualAccount
    self.bankAccountId = bankAccountId
    self.fasterPaymentsAccountNumber = fasterPaymentsAccountNumber
    self.fasterPaymentsBeneficiaryAddressLine1 = fasterPaymentsBeneficiaryAddressLine1
    self.fasterPaymentsBeneficiaryCity = fasterPaymentsBeneficiaryCity
    self.fasterPaymentsBeneficiaryCountry = fasterPaymentsBeneficiaryCountry
    self.fasterPaymentsBeneficiaryLegalName = fasterPaymentsBeneficiaryLegalName
    self.fasterPaymentsBeneficiaryPostalCode = fasterPaymentsBeneficiaryPostalCode
    self.fasterPaymentsSortCode = fasterPaymentsSortCode
    self.payableId = payableId
    self.sepaBeneficiaryAddressLine1 = sepaBeneficiaryAddressLine1
    self.sepaBeneficiaryCity = sepaBeneficiaryCity
    self.sepaBeneficiaryCountry = sepaBeneficiaryCountry
    self.sepaBeneficiaryLegalName = sepaBeneficiaryLegalName
    self.sepaBeneficiaryPostalCode = sepaBeneficiaryPostalCode
    self.sepaIban = sepaIban
  }

  enum CodingKeys: String, CodingKey {
    case id
    case customerId = "customer_id"
    case status
    case senderWalletAddress = "sender_wallet_address"
    case signedTransaction = "signed_transaction"
    case quoteId = "quote_id"
    case instanceId = "instance_id"
    case trackingTransaction = "tracking_transaction"
    case trackingPayment = "tracking_payment"
    case trackingLiquidity = "tracking_liquidity"
    case trackingComplete = "tracking_complete"
    case trackingPartnerFee = "tracking_partner_fee"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case imageUrl = "image_url"
    case firstName = "first_name"
    case lastName = "last_name"
    case legalName = "legal_name"
    case network
    case token
    case description
    case senderAmount = "sender_amount"
    case receiverAmount = "receiver_amount"
    case partnerFeeAmount = "partner_fee_amount"
    case partnerFeeId = "partner_fee_id"
    case billingFeeAmount = "billing_fee_amount"
    case cpnPaymentId = "cpn_payment_id"
    case tedBankCode = "ted_bank_code"
    case tedBranchCode = "ted_branch_code"
    case tedCpfCnpj = "ted_cpf_cnpj"
    case commercialQuotation = "commercial_quotation"
    case blindpayQuotation = "blindpay_quotation"
    case totalFeeAmount = "total_fee_amount"
    case customerLocalAmount = "customer_local_amount"
    case currency
    case transactionDocumentFile = "transaction_document_file"
    case transactionDocumentType = "transaction_document_type"
    case transactionDocumentId = "transaction_document_id"
    case name
    case type
    case pixKey = "pix_key"
    case pixSafeBankCode = "pix_safe_bank_code"
    case pixSafeBranchCode = "pix_safe_branch_code"
    case pixSafeCpfCnpj = "pix_safe_cpf_cnpj"
    case accountNumber = "account_number"
    case routingNumber = "routing_number"
    case country
    case accountClass = "account_class"
    case addressLine1 = "address_line_1"
    case addressLine2 = "address_line_2"
    case city
    case stateProvinceRegion = "state_province_region"
    case postalCode = "postal_code"
    case accountType = "account_type"
    case achCopBeneficiaryFirstName = "ach_cop_beneficiary_first_name"
    case achCopBankAccount = "ach_cop_bank_account"
    case achCopBankCode = "ach_cop_bank_code"
    case achCopBeneficiaryLastName = "ach_cop_beneficiary_last_name"
    case achCopDocumentId = "ach_cop_document_id"
    case achCopDocumentType = "ach_cop_document_type"
    case achCopEmail = "ach_cop_email"
    case beneficiaryName = "beneficiary_name"
    case speiClabe = "spei_clabe"
    case speiProtocol = "spei_protocol"
    case speiInstitutionCode = "spei_institution_code"
    case swiftBeneficiaryCountry = "swift_beneficiary_country"
    case swiftCodeBic = "swift_code_bic"
    case swiftAccountHolderName = "swift_account_holder_name"
    case swiftAccountNumberIban = "swift_account_number_iban"
    case transfersAccount = "transfers_account"
    case transfersType = "transfers_type"
    case hasVirtualAccount = "has_virtual_account"
    case bankAccountId = "bank_account_id"
    case fasterPaymentsAccountNumber = "faster_payments_account_number"
    case fasterPaymentsBeneficiaryAddressLine1 = "faster_payments_beneficiary_address_line_1"
    case fasterPaymentsBeneficiaryCity = "faster_payments_beneficiary_city"
    case fasterPaymentsBeneficiaryCountry = "faster_payments_beneficiary_country"
    case fasterPaymentsBeneficiaryLegalName = "faster_payments_beneficiary_legal_name"
    case fasterPaymentsBeneficiaryPostalCode = "faster_payments_beneficiary_postal_code"
    case fasterPaymentsSortCode = "faster_payments_sort_code"
    case payableId = "payable_id"
    case sepaBeneficiaryAddressLine1 = "sepa_beneficiary_address_line_1"
    case sepaBeneficiaryCity = "sepa_beneficiary_city"
    case sepaBeneficiaryCountry = "sepa_beneficiary_country"
    case sepaBeneficiaryLegalName = "sepa_beneficiary_legal_name"
    case sepaBeneficiaryPostalCode = "sepa_beneficiary_postal_code"
    case sepaIban = "sepa_iban"
  }
}

// MARK: - Response Types

/// One page of payouts (see ``ListResult``).
public typealias ListPayoutsResponse = ListResult<Payout>

/// Response type for single payout
public typealias PayoutResponse = Payout

/// Response type for creating a payout
public struct CreatePayoutResponse: Codable, Sendable {
  /// Unique identifier for the created payout
  public let id: String

  /// Status of the payout
  public let status: PayoutStatus

  /// Sender wallet address
  public let senderWalletAddress: String

  /// Complete tracking information
  public let trackingComplete: PayoutTrackingComplete

  /// Payment tracking information
  public let trackingPayment: PayoutTrackingPayment

  /// Transaction tracking information
  public let trackingTransaction: PayoutTrackingTransaction

  /// Partner fee tracking information
  public let trackingPartnerFee: PayoutTrackingPartnerFee?

  /// Liquidity tracking information
  public let trackingLiquidity: PayoutTrackingLiquidity?

  /// Customer ID
  public let customerId: String?

  public let payableId: String?

  public init(
    id: String,
    status: PayoutStatus,
    senderWalletAddress: String,
    trackingComplete: PayoutTrackingComplete,
    trackingPayment: PayoutTrackingPayment,
    trackingTransaction: PayoutTrackingTransaction,
    trackingPartnerFee: PayoutTrackingPartnerFee? = nil,
    trackingLiquidity: PayoutTrackingLiquidity? = nil,
    customerId: String? = nil,
    payableId: String? = nil
  ) {
    self.id = id
    self.status = status
    self.senderWalletAddress = senderWalletAddress
    self.trackingComplete = trackingComplete
    self.trackingPayment = trackingPayment
    self.trackingTransaction = trackingTransaction
    self.trackingPartnerFee = trackingPartnerFee
    self.trackingLiquidity = trackingLiquidity
    self.customerId = customerId
    self.payableId = payableId
  }

  enum CodingKeys: String, CodingKey {
    case id
    case status
    case senderWalletAddress = "sender_wallet_address"
    case trackingComplete = "tracking_complete"
    case trackingPayment = "tracking_payment"
    case trackingTransaction = "tracking_transaction"
    case trackingPartnerFee = "tracking_partner_fee"
    case trackingLiquidity = "tracking_liquidity"
    case customerId = "customer_id"
    case payableId = "payable_id"
  }
}

/// Response type for authorizing Stellar token
public struct AuthorizeStellarResponse: Codable, Sendable {
  /// Transaction hash
  public let transactionHash: String

  public init(transactionHash: String) {
    self.transactionHash = transactionHash
  }

  enum CodingKeys: String, CodingKey {
    case transactionHash = "transaction_hash"
  }
}

// MARK: - Input Types

/// Filters and cursors for listing payouts. Every value is optional; unset ones are not sent.
public struct ListPayoutsInput: CursorPaginatedInput {
  /// Page size (10, 50, 100, 200, 500 or 1000).
  public var limit: Int?

  /// Return items after this id (the previous page's `pagination.nextPage`).
  public var startingAfter: String?

  /// Return items before this id.
  public var endingBefore: String?

  /// Only this customer.
  public var customerId: String?

  /// Only this status.
  public var status: PayoutStatus?

  /// Customer name contains this text.
  public var customerName: String?

  /// Only this bank account.
  public var bankAccountId: String?

  /// Only this country.
  public var country: Country?

  /// Only this rail.
  public var paymentMethod: Rail?

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
    status: PayoutStatus? = nil,
    customerName: String? = nil,
    bankAccountId: String? = nil,
    country: Country? = nil,
    paymentMethod: Rail? = nil,
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

/// Input for creating a payout on an EVM chain (`PayoutOnEvmIn`).
///
/// Set exactly one of `senderWalletAddress` or `walletId`; the API rejects
/// both or neither with a 400 (no client-side check).
public struct CreatePayoutEvmInput: Codable, Sendable {
  /// The quote to execute. Quotes are single-use.
  public let quoteId: String

  /// The wallet that sends the stablecoins. Exactly one of this or `walletId`.
  public let senderWalletAddress: String?

  /// A managed wallet (`bw_...`) to pay from. Exactly one of this or `senderWalletAddress`.
  public let walletId: String?

  public init(quoteId: String, senderWalletAddress: String? = nil, walletId: String? = nil) {
    self.quoteId = quoteId
    self.senderWalletAddress = senderWalletAddress
    self.walletId = walletId
  }

  enum CodingKeys: String, CodingKey {
    case quoteId = "quote_id"
    case senderWalletAddress = "sender_wallet_address"
    case walletId = "wallet_id"
  }
}

/// Input for creating a payout on Stellar (`PayoutOnStellarIn`).
///
/// Set exactly one of `senderWalletAddress` or `walletId`; the API rejects
/// both or neither with a 400 (no client-side check).
public struct CreatePayoutStellarInput: Codable, Sendable {
  /// The quote to execute. Quotes are single-use.
  public let quoteId: String

  /// The wallet that sends the stablecoins. Exactly one of this or `walletId`.
  public let senderWalletAddress: String?

  /// A managed wallet (`bw_...`) to pay from. Exactly one of this or `senderWalletAddress`.
  public let walletId: String?

  /// The signed transaction, when you sign it yourself.
  public let signedTransaction: String?

  public init(quoteId: String, senderWalletAddress: String? = nil, walletId: String? = nil, signedTransaction: String? = nil) {
    self.quoteId = quoteId
    self.senderWalletAddress = senderWalletAddress
    self.walletId = walletId
    self.signedTransaction = signedTransaction
  }

  enum CodingKeys: String, CodingKey {
    case quoteId = "quote_id"
    case senderWalletAddress = "sender_wallet_address"
    case walletId = "wallet_id"
    case signedTransaction = "signed_transaction"
  }
}

/// Input for creating a payout on Solana (`PayoutOnSolanaIn`).
///
/// Set exactly one of `senderWalletAddress` or `walletId`; the API rejects
/// both or neither with a 400 (no client-side check).
public struct CreatePayoutSolanaInput: Codable, Sendable {
  /// The quote to execute. Quotes are single-use.
  public let quoteId: String

  /// The wallet that sends the stablecoins. Exactly one of this or `walletId`.
  public let senderWalletAddress: String?

  /// A managed wallet (`bw_...`) to pay from. Exactly one of this or `senderWalletAddress`.
  public let walletId: String?

  /// The signed transaction, when you sign it yourself.
  public let signedTransaction: String?

  public init(quoteId: String, senderWalletAddress: String? = nil, walletId: String? = nil, signedTransaction: String? = nil) {
    self.quoteId = quoteId
    self.senderWalletAddress = senderWalletAddress
    self.walletId = walletId
    self.signedTransaction = signedTransaction
  }

  enum CodingKeys: String, CodingKey {
    case quoteId = "quote_id"
    case senderWalletAddress = "sender_wallet_address"
    case walletId = "wallet_id"
    case signedTransaction = "signed_transaction"
  }
}

/// Input for authorizing a Stellar payout (`PayoutOnStellarAuthorizeIn`).
///
/// Set exactly one of `senderWalletAddress` or `walletId`; the API rejects
/// both or neither with a 400 (no client-side check).
public struct AuthorizeStellarInput: Codable, Sendable {
  /// The quote to execute. Quotes are single-use.
  public let quoteId: String

  /// The wallet that sends the stablecoins. Exactly one of this or `walletId`.
  public let senderWalletAddress: String?

  /// A managed wallet (`bw_...`) to pay from. Exactly one of this or `senderWalletAddress`.
  public let walletId: String?

  public init(quoteId: String, senderWalletAddress: String? = nil, walletId: String? = nil) {
    self.quoteId = quoteId
    self.senderWalletAddress = senderWalletAddress
    self.walletId = walletId
  }

  enum CodingKeys: String, CodingKey {
    case quoteId = "quote_id"
    case senderWalletAddress = "sender_wallet_address"
    case walletId = "wallet_id"
  }
}

/// Input for submitting payout documents (required for SWIFT payouts)
public struct SubmitPayoutDocumentsInput: Codable, Sendable {
    /// Transaction document type
    public let transactionDocumentType: TransactionDocumentType

    /// Transaction document ID (max 512 characters)
    public let transactionDocumentId: String

    /// Transaction document file URL (from upload endpoint)
    public let transactionDocumentFile: String

    /// Description (max 128 characters)
    public let description: String?

    public init(
        transactionDocumentType: TransactionDocumentType,
        transactionDocumentId: String,
        transactionDocumentFile: String,
        description: String? = nil
    ) {
        self.transactionDocumentType = transactionDocumentType
        self.transactionDocumentId = transactionDocumentId
        self.transactionDocumentFile = transactionDocumentFile
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case transactionDocumentType = "transaction_document_type"
        case transactionDocumentId = "transaction_document_id"
        case transactionDocumentFile = "transaction_document_file"
        case description
    }
}

/// Response for submitting payout documents
public struct SubmitPayoutDocumentsResponse: Codable, Sendable {
    /// Success status
    public let success: Bool

    public init(success: Bool) {
        self.success = success
    }
}

// MARK: - Documents tracking

/// Status of a payout's documents step.
public struct PayoutDocumentsStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let waitingDocuments = PayoutDocumentsStatus(rawValue: "waiting_documents")
    public static let complianceReviewing = PayoutDocumentsStatus(rawValue: "compliance_reviewing")
}

/// Documents step of a payout that needs supporting documents.
public struct PayoutTrackingDocuments: Codable, Sendable, Equatable {
    /// Documents step
    public let step: TrackingStep
    /// Documents status
    public let status: PayoutDocumentsStatus?
    /// Reviewer email/name
    public let reviewedBy: String?
    /// Documents completed date
    public let completedAt: String?

    public init(
        step: TrackingStep,
        status: PayoutDocumentsStatus? = nil,
        reviewedBy: String? = nil,
        completedAt: String? = nil
    ) {
        self.step = step
        self.status = status
        self.reviewedBy = reviewedBy
        self.completedAt = completedAt
    }

    enum CodingKeys: String, CodingKey {
        case step
        case status
        case reviewedBy = "reviewed_by"
        case completedAt = "completed_at"
    }
}

