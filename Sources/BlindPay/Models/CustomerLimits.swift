//
//  CustomerLimits.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

// MARK: - Supporting Document Type

/// Type of supporting document for limit increase requests
public struct SupportingDocumentType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let individualBankStatement = SupportingDocumentType(rawValue: "individual_bank_statement")
    public static let individualTaxReturn = SupportingDocumentType(rawValue: "individual_tax_return")
    public static let individualProofOfIncome = SupportingDocumentType(rawValue: "individual_proof_of_income")
    public static let businessBankStatement = SupportingDocumentType(rawValue: "business_bank_statement")
    public static let businessFinancialStatements = SupportingDocumentType(rawValue: "business_financial_statements")
    public static let businessTaxReturn = SupportingDocumentType(rawValue: "business_tax_return")
}

// MARK: - Limit Increase Request Status

/// Status of a limit increase request
public struct LimitIncreaseRequestStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let inReview = LimitIncreaseRequestStatus(rawValue: "in_review")
    public static let approved = LimitIncreaseRequestStatus(rawValue: "approved")
    public static let rejected = LimitIncreaseRequestStatus(rawValue: "rejected")
}

// MARK: - Payin Limits

/// Payin limits for a customer
public struct PayinLimits: Codable, Sendable, Equatable {
    /// Daily limit
    public let daily: Int
    
    /// Monthly limit
    public let monthly: Int
    
    public init(daily: Int, monthly: Int) {
        self.daily = daily
        self.monthly = monthly
    }
}

// MARK: - Payout Limits

/// Payout limits for a customer
public struct PayoutLimits: Codable, Sendable, Equatable {
    /// Daily limit
    public let daily: Int
    
    /// Monthly limit
    public let monthly: Int
    
    public init(daily: Int, monthly: Int) {
        self.daily = daily
        self.monthly = monthly
    }
}

// MARK: - Customer Limits Response

/// Response containing customer limits
public struct CustomerLimitsResponse: Codable, Sendable, Equatable {
    /// Limits object containing payin and payout limits
    public let limits: CustomerLimitsDetail
    
    public init(limits: CustomerLimitsDetail) {
        self.limits = limits
    }
}

/// Detailed limits information
public struct CustomerLimitsDetail: Codable, Sendable, Equatable {
    /// Payin limits
    public let payin: PayinLimits
    
    /// Payout limits
    public let payout: PayoutLimits
    
    public init(payin: PayinLimits, payout: PayoutLimits) {
        self.payin = payin
        self.payout = payout
    }
}

// MARK: - Request Limit Increase Input

/// Input for requesting a limit increase
public struct RequestLimitIncreaseInput: Codable, Sendable {
    /// Requested per-transaction limit in cents; `nil` leaves it unchanged (sent as `null`).
    public let perTransaction: Int?

    /// Requested daily limit in cents; `nil` leaves it unchanged (sent as `null`).
    public let daily: Int?

    /// Requested monthly limit in cents; `nil` leaves it unchanged (sent as `null`).
    public let monthly: Int?

    /// Single supporting document type (legacy; prefer `supportingDocuments`).
    public let supportingDocumentType: SupportingDocumentType?

    /// Single supporting document file URL (legacy; prefer `supportingDocuments`).
    public let supportingDocumentFile: String?

    /// Supporting documents (upload each file first).
    public let supportingDocuments: [LimitIncreaseSupportingDocument]?

    public init(
        perTransaction: Int?,
        daily: Int?,
        monthly: Int?,
        supportingDocumentType: SupportingDocumentType? = nil,
        supportingDocumentFile: String? = nil,
        supportingDocuments: [LimitIncreaseSupportingDocument]? = nil
    ) {
        self.perTransaction = perTransaction
        self.daily = daily
        self.monthly = monthly
        self.supportingDocumentType = supportingDocumentType
        self.supportingDocumentFile = supportingDocumentFile
        self.supportingDocuments = supportingDocuments
    }

    enum CodingKeys: String, CodingKey {
        case perTransaction = "per_transaction"
        case daily
        case monthly
        case supportingDocumentType = "supporting_document_type"
        case supportingDocumentFile = "supporting_document_file"
        case supportingDocuments = "supporting_documents"
    }

    /// The three limits are required keys that accept `null`.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(perTransaction, forKey: .perTransaction)
        try container.encode(daily, forKey: .daily)
        try container.encode(monthly, forKey: .monthly)
        try container.encodeIfPresent(supportingDocumentType, forKey: .supportingDocumentType)
        try container.encodeIfPresent(supportingDocumentFile, forKey: .supportingDocumentFile)
        try container.encodeIfPresent(supportingDocuments, forKey: .supportingDocuments)
    }
}

/// One supporting document of a limit increase request.
public struct LimitIncreaseSupportingDocument: Codable, Sendable, Equatable {
    public let type: SupportingDocumentType
    /// URL of the uploaded file.
    public let file: String

    public init(type: SupportingDocumentType, file: String) {
        self.type = type
        self.file = file
    }
}

// MARK: - Request Limit Increase Response

/// Response for requesting a limit increase
public struct RequestLimitIncreaseResponse: Codable, Sendable, Equatable {
    /// Unique identifier for the limit increase request
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

// MARK: - Limit Increase Request

/// Limit increase request information
public struct LimitIncreaseRequest: Codable, Sendable, Equatable {
    /// Unique identifier
    public let id: String
    
    /// Customer ID
    public let customerId: String
    
    /// Status of the request
    public let status: LimitIncreaseRequestStatus
    
    /// Created at timestamp
    public let createdAt: String?
    
    /// Updated at timestamp
    public let updatedAt: String?
    
    /// Per transaction limit (optional)
    public let perTransaction: Int?
    
    /// Daily limit (optional)
    public let daily: Int?
    
    /// Monthly limit (optional)
    public let monthly: Int?
    
    /// Supporting document file URL (optional)
    public let supportingDocumentFile: String?
    
    /// Supporting document type (optional)
    public let supportingDocumentType: SupportingDocumentType?
    
    /// Every supporting document attached to the request (up to 5).
    public let supportingDocuments: [LimitIncreaseSupportingDocument]?

    public init(
        id: String,
        customerId: String,
        status: LimitIncreaseRequestStatus,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        perTransaction: Int? = nil,
        daily: Int? = nil,
        monthly: Int? = nil,
        supportingDocumentFile: String? = nil,
        supportingDocumentType: SupportingDocumentType? = nil,
        supportingDocuments: [LimitIncreaseSupportingDocument]? = nil
    ) {
        self.id = id
        self.customerId = customerId
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.perTransaction = perTransaction
        self.daily = daily
        self.monthly = monthly
        self.supportingDocumentFile = supportingDocumentFile
        self.supportingDocumentType = supportingDocumentType
        self.supportingDocuments = supportingDocuments
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case customerId = "customer_id"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case perTransaction = "per_transaction"
        case daily
        case monthly
        case supportingDocumentFile = "supporting_document_file"
        case supportingDocumentType = "supporting_document_type"
        case supportingDocuments = "supporting_documents"
    }
}
