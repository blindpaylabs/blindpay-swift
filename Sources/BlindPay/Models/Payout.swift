//
//  Payout.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

// MARK: - Enums

/// Payout status
public enum PayoutStatus: String, Codable, Sendable {
  case processing = "processing"
  case onHold = "on_hold"
  case failed = "failed"
  case refunded = "refunded"
  case completed = "completed"
}

/// Tracking step
public enum TrackingStep: String, Codable, Sendable {
  case processing = "processing"
  case onHold = "on_hold"
  case completed = "completed"
}

/// Provider status for liquidity tracking
public enum ProviderStatus: String, Codable, Sendable {
  case deposited = "deposited"
  case converted = "converted"
  case withdrawn = "withdrawn"
}

/// Provider status for payment tracking
public enum PaymentProviderStatus: String, Codable, Sendable {
  case canceled = "canceled"
  case failed = "failed"
  case returned = "returned"
  case sent = "sent"
}

/// Payment type for payout
public enum PaymentType: String, Codable, Sendable {
  case wire = "wire"
  case ach = "ach"
  case pix = "pix"
  case pixSafe = "pix_safe"
  case speiBitso = "spei_bitso"
  case transfersBitso = "transfers_bitso"
  case achCopBitso = "ach_cop_bitso"
  case internationalSwift = "international_swift"
  case rtp = "rtp"
}

/// Account type
public enum AccountType: String, Codable, Sendable {
  case checking = "checking"
  case saving = "saving"
}


/// ACH COP document type
public enum AchCopDocumentType: String, Codable, Sendable {
  case cc = "CC"
  case ce = "CE"
  case nit = "NIT"
  case pass = "PASS"
  case pep = "PEP"
}

/// Estimated time of arrival
public enum EstimatedTimeOfArrival: String, Codable, Sendable {
  case fiveMin = "5_min"
  case thirtyMin = "30_min"
  case twoHours = "2_hours"
  case oneBusinessDay = "1_business_day"
  case twoBusinessDays = "2_business_days"
  case fiveBusinessDays = "5_business_days"
}

/// Tracking complete status
public enum TrackingCompleteStatus: String, Codable, Sendable {
  case tokensRefunded = "tokens_refunded"
  case paid = "paid"
}

/// Tracking transaction status
public enum TrackingTransactionStatus: String, Codable, Sendable {
  case failed = "failed"
  case found = "found"
}

/// SPEI protocol
public enum SpeiProtocol: String, Codable, Sendable {
  case clabe = "clabe"
  case debitcard = "debitcard"
  case phonenum = "phonenum"
}

/// Transfers type
public enum TransfersType: String, Codable, Sendable {
  case cvu = "CVU"
  case cbu = "CBU"
  case alias = "ALIAS"
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
    completedAt: String? = nil
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

  /// Receiver ID
  public let receiverId: String

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
  public let createdAt: String

  /// Timestamp when the payout was last updated
  public let updatedAt: String

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
  public let senderAmount: Int

  /// Receiver amount (in smallest currency unit)
  public let receiverAmount: Int

  /// Partner fee amount (in smallest currency unit)
  public let partnerFeeAmount: Int?

  /// Commercial quotation
  public let commercialQuotation: Double?

  /// BlindPay quotation
  public let blindpayQuotation: Double?

  /// Total fee amount
  public let totalFeeAmount: Double?

  /// Receiver local amount (in smallest currency unit)
  public let receiverLocalAmount: Int?

  /// Currency
  public let currency: Currency

  /// Transaction document file URL
  public let transactionDocumentFile: String?

  /// Transaction document type
  public let transactionDocumentType: TransactionDocumentType?

  /// Transaction document ID
  public let transactionDocumentId: String?

  /// Name
  public let name: String

  /// Payment type
  public let type: PaymentType

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

  public init(
    id: String,
    receiverId: String,
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
    createdAt: String,
    updatedAt: String,
    imageUrl: String? = nil,
    firstName: String? = nil,
    lastName: String? = nil,
    legalName: String? = nil,
    network: Network,
    token: StablecoinToken,
    description: String? = nil,
    senderAmount: Int,
    receiverAmount: Int,
    partnerFeeAmount: Int? = nil,
    commercialQuotation: Double? = nil,
    blindpayQuotation: Double? = nil,
    totalFeeAmount: Double? = nil,
    receiverLocalAmount: Int? = nil,
    currency: Currency,
    transactionDocumentFile: String? = nil,
    transactionDocumentType: TransactionDocumentType? = nil,
    transactionDocumentId: String? = nil,
    name: String,
    type: PaymentType,
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
    hasVirtualAccount: Bool? = nil
  ) {
    self.id = id
    self.receiverId = receiverId
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
    self.commercialQuotation = commercialQuotation
    self.blindpayQuotation = blindpayQuotation
    self.totalFeeAmount = totalFeeAmount
    self.receiverLocalAmount = receiverLocalAmount
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
  }

  enum CodingKeys: String, CodingKey {
    case id
    case receiverId = "receiver_id"
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
    case commercialQuotation = "commercial_quotation"
    case blindpayQuotation = "blindpay_quotation"
    case totalFeeAmount = "total_fee_amount"
    case receiverLocalAmount = "receiver_local_amount"
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
  }
}

// MARK: - Pagination Response

/// Pagination metadata for payout list responses
public struct PayoutPaginationMetadata: Codable, Sendable, Equatable {
  /// Whether there are more pages available
  public let hasMore: Bool

  /// Next page cursor (ID)
  public let nextPage: String?

  /// Previous page cursor (ID)
  public let prevPage: String?

  public init(hasMore: Bool, nextPage: String? = nil, prevPage: String? = nil) {
    self.hasMore = hasMore
    self.nextPage = nextPage
    self.prevPage = prevPage
  }

  enum CodingKeys: String, CodingKey {
    case hasMore = "has_more"
    case nextPage = "next_page"
    case prevPage = "prev_page"
  }
}

// MARK: - Response Types

/// Response type for listing payouts with pagination
public struct ListPayoutsResponse: Codable, Sendable {
  /// Array of payouts
  public let data: [Payout]

  /// Pagination metadata
  public let pagination: PayoutPaginationMetadata

  public init(data: [Payout], pagination: PayoutPaginationMetadata) {
    self.data = data
    self.pagination = pagination
  }
}

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

  /// Receiver ID
  public let receiverId: String?

  public init(
    id: String,
    status: PayoutStatus,
    senderWalletAddress: String,
    trackingComplete: PayoutTrackingComplete,
    trackingPayment: PayoutTrackingPayment,
    trackingTransaction: PayoutTrackingTransaction,
    trackingPartnerFee: PayoutTrackingPartnerFee? = nil,
    trackingLiquidity: PayoutTrackingLiquidity? = nil,
    receiverId: String? = nil
  ) {
    self.id = id
    self.status = status
    self.senderWalletAddress = senderWalletAddress
    self.trackingComplete = trackingComplete
    self.trackingPayment = trackingPayment
    self.trackingTransaction = trackingTransaction
    self.trackingPartnerFee = trackingPartnerFee
    self.trackingLiquidity = trackingLiquidity
    self.receiverId = receiverId
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
    case receiverId = "receiver_id"
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

/// Input parameters for listing payouts
public struct ListPayoutsInput: Codable, Sendable {
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

  /// Filter by status
  public let status: PayoutStatus?

  public init(
    limit: String? = nil,
    offset: String? = nil,
    startingAfter: String? = nil,
    endingBefore: String? = nil,
    receiverId: String? = nil,
    status: PayoutStatus? = nil
  ) {
    self.limit = limit
    self.offset = offset
    self.startingAfter = startingAfter
    self.endingBefore = endingBefore
    self.receiverId = receiverId
    self.status = status
  }

  enum CodingKeys: String, CodingKey {
    case limit
    case offset
    case startingAfter = "starting_after"
    case endingBefore = "ending_before"
    case receiverId = "receiver_id"
    case status
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
    if let status = status {
      params["status"] = status.rawValue
    }
    return params
  }
}

/// Input for creating a payout on EVM chains
public struct CreatePayoutEvmInput: Codable, Sendable {
  /// Quote ID
  public let quoteId: String

  /// Sender wallet address
  public let senderWalletAddress: String

  public init(quoteId: String, senderWalletAddress: String) {
    self.quoteId = quoteId
    self.senderWalletAddress = senderWalletAddress
  }

  enum CodingKeys: String, CodingKey {
    case quoteId = "quote_id"
    case senderWalletAddress = "sender_wallet_address"
  }
}

/// Input for creating a payout on Stellar
public struct CreatePayoutStellarInput: Codable, Sendable {
  /// Quote ID
  public let quoteId: String

  /// Sender wallet address
  public let senderWalletAddress: String

  /// Signed transaction (optional)
  public let signedTransaction: String?

  public init(quoteId: String, senderWalletAddress: String, signedTransaction: String? = nil) {
    self.quoteId = quoteId
    self.senderWalletAddress = senderWalletAddress
    self.signedTransaction = signedTransaction
  }

  enum CodingKeys: String, CodingKey {
    case quoteId = "quote_id"
    case senderWalletAddress = "sender_wallet_address"
    case signedTransaction = "signed_transaction"
  }
}

/// Input for authorizing Stellar token
public struct AuthorizeStellarInput: Codable, Sendable {
  /// Quote ID
  public let quoteId: String

  /// Sender wallet address
  public let senderWalletAddress: String

  public init(quoteId: String, senderWalletAddress: String) {
    self.quoteId = quoteId
    self.senderWalletAddress = senderWalletAddress
  }

  enum CodingKeys: String, CodingKey {
    case quoteId = "quote_id"
    case senderWalletAddress = "sender_wallet_address"
  }
}

