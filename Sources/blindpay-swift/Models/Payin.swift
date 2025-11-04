//
//  Payin.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

// MARK: - Enums

/// Payin status
public enum PayinStatus: String, Codable, Sendable {
  case processing = "processing"
  case onHold = "on_hold"
  case failed = "failed"
  case refunded = "refunded"
  case completed = "completed"
}

/// Payment method for payin
public enum PaymentMethod: String, Codable, Sendable {
  case pix = "pix"
}

/// Payin type
public enum PayinType: String, Codable, Sendable {
  case individual = "individual"
  case company = "company"
}

// MARK: - Tracking Types

/// Transaction tracking information for payin
public struct PayinTrackingTransaction: Codable, Sendable, Equatable {
  /// Step name
  public let step: String

  /// Status of the step
  public let status: String

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

  public init(
    step: String,
    status: String,
    externalId: String? = nil,
    completedAt: String? = nil,
    senderName: String? = nil,
    senderTaxId: String? = nil,
    senderBankCode: String? = nil,
    senderAccountNumber: String? = nil,
    traceNumber: String? = nil,
    transactionReference: String? = nil,
    description: String? = nil
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
  }
}

/// Payment tracking information for payin
public struct PayinTrackingPayment: Codable, Sendable, Equatable {
  /// Step name
  public let step: String

  /// Provider name
  public let providerName: String?

  /// Completion timestamp
  public let completedAt: String?

  public init(step: String, providerName: String? = nil, completedAt: String? = nil) {
    self.step = step
    self.providerName = providerName
    self.completedAt = completedAt
  }

  enum CodingKeys: String, CodingKey {
    case step
    case providerName = "provider_name"
    case completedAt = "completed_at"
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
  public let name: String

  /// Address line 1
  public let addressLine1: String

  /// Address line 2
  public let addressLine2: String

  public init(name: String, addressLine1: String, addressLine2: String) {
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
  public let name: String

  /// Address line 1
  public let addressLine1: String

  /// Address line 2
  public let addressLine2: String

  public init(name: String, addressLine1: String, addressLine2: String) {
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
  public let routingNumber: String

  /// Account number
  public let accountNumber: String

  /// Account type
  public let accountType: String

  /// SWIFT BIC code
  public let swiftBicCode: String

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
    routingNumber: String,
    accountNumber: String,
    accountType: String,
    swiftBicCode: String,
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

  /// Receiver ID
  public let receiverId: String

  /// PIX code for payment
  public let pixCode: String?

  /// Memo code for payment
  public let memoCode: String?

  /// CLABE code for payment
  public let clabe: String?

  /// Status of the payin
  public let status: PayinStatus

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
  public let createdAt: String

  /// Timestamp when the payin was last updated
  public let updatedAt: String

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
  public let token: String?

  /// Partner fee amount
  public let partnerFeeAmount: Int?

  /// Total fee amount
  public let totalFeeAmount: Double?

  /// Commercial quotation
  public let commercialQuotation: Int?

  /// BlindPay quotation
  public let blindpayQuotation: Int?

  /// Currency
  public let currency: String?

  /// Billing fee
  public let billingFee: Int?

  /// Wallet display name
  public let name: String?

  /// Wallet address
  public let address: String?

  /// Network
  public let network: String?

  /// BlindPay bank details
  public let blindpayBankDetails: BlindPayBankDetails?

  public init(
    id: String,
    receiverId: String,
    pixCode: String? = nil,
    memoCode: String? = nil,
    clabe: String? = nil,
    status: PayinStatus,
    payinQuoteId: String? = nil,
    instanceId: String,
    trackingTransaction: PayinTrackingTransaction? = nil,
    trackingPayment: PayinTrackingPayment? = nil,
    trackingComplete: PayinTrackingComplete? = nil,
    trackingPartnerFee: PayinTrackingPartnerFee? = nil,
    createdAt: String,
    updatedAt: String,
    imageUrl: String? = nil,
    firstName: String? = nil,
    lastName: String? = nil,
    legalName: String? = nil,
    type: PayinType? = nil,
    paymentMethod: PaymentMethod? = nil,
    senderAmount: Int? = nil,
    receiverAmount: Int? = nil,
    token: String? = nil,
    partnerFeeAmount: Int? = nil,
    totalFeeAmount: Double? = nil,
    commercialQuotation: Int? = nil,
    blindpayQuotation: Int? = nil,
    currency: String? = nil,
    billingFee: Int? = nil,
    name: String? = nil,
    address: String? = nil,
    network: String? = nil,
    blindpayBankDetails: BlindPayBankDetails? = nil
  ) {
    self.id = id
    self.receiverId = receiverId
    self.pixCode = pixCode
    self.memoCode = memoCode
    self.clabe = clabe
    self.status = status
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
    self.totalFeeAmount = totalFeeAmount
    self.commercialQuotation = commercialQuotation
    self.blindpayQuotation = blindpayQuotation
    self.currency = currency
    self.billingFee = billingFee
    self.name = name
    self.address = address
    self.network = network
    self.blindpayBankDetails = blindpayBankDetails
  }

  enum CodingKeys: String, CodingKey {
    case id
    case receiverId = "receiver_id"
    case pixCode = "pix_code"
    case memoCode = "memo_code"
    case clabe
    case status
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
    case totalFeeAmount = "total_fee_amount"
    case commercialQuotation = "commercial_quotation"
    case blindpayQuotation = "blindpay_quotation"
    case currency
    case billingFee = "billing_fee"
    case name
    case address
    case network
    case blindpayBankDetails = "blindpay_bank_details"
  }
}

// MARK: - Pagination Response

/// Pagination metadata for payin list responses
public struct PayinPaginationMetadata: Codable, Sendable, Equatable {
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

/// Response type for listing payins with pagination
public struct ListPayinsResponse: Codable, Sendable {
  /// Array of payins
  public let data: [Payin]

  /// Pagination metadata
  public let pagination: PayinPaginationMetadata

  public init(data: [Payin], pagination: PayinPaginationMetadata) {
    self.data = data
    self.pagination = pagination
  }
}

/// Response type for single payin
public typealias PayinResponse = Payin

// MARK: - Input Types

/// Input parameters for listing payins
public struct ListPayinsInput: Codable, Sendable {
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
  public let status: PayinStatus?

  public init(
    limit: String? = nil,
    offset: String? = nil,
    startingAfter: String? = nil,
    endingBefore: String? = nil,
    receiverId: String? = nil,
    status: PayinStatus? = nil
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
  public let trackingComplete: PayinTrackingComplete?

  /// Payment tracking information
  public let trackingPayment: PayinTrackingPayment?

  /// Transaction tracking information
  public let trackingTransaction: PayinTrackingTransaction?

  /// Partner fee tracking information
  public let trackingPartnerFee: PayinTrackingPartnerFee?

  /// BlindPay bank details
  public let blindpayBankDetails: BlindPayBankDetails?

  /// Receiver ID
  public let receiverId: String

  /// Receiver amount
  public let receiverAmount: Int

  /// Payment method
  public let paymentMethod: PaymentMethod

  /// Billing fee
  public let billingFee: Int

  /// Sender amount
  public let senderAmount: Int

  public init(
    id: String,
    status: PayinStatus,
    pixCode: String? = nil,
    memoCode: String? = nil,
    clabe: String? = nil,
    trackingComplete: PayinTrackingComplete? = nil,
    trackingPayment: PayinTrackingPayment? = nil,
    trackingTransaction: PayinTrackingTransaction? = nil,
    trackingPartnerFee: PayinTrackingPartnerFee? = nil,
    blindpayBankDetails: BlindPayBankDetails? = nil,
    receiverId: String,
    receiverAmount: Int,
    paymentMethod: PaymentMethod,
    billingFee: Int,
    senderAmount: Int
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
    self.receiverId = receiverId
    self.receiverAmount = receiverAmount
    self.paymentMethod = paymentMethod
    self.billingFee = billingFee
    self.senderAmount = senderAmount
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
    case receiverId = "receiver_id"
    case receiverAmount = "receiver_amount"
    case paymentMethod = "payment_method"
    case billingFee = "billing_fee"
    case senderAmount = "sender_amount"
  }
}
