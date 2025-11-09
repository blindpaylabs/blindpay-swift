//
//  ReceiverLimits.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

// MARK: - Supporting Document Type

/// Type of supporting document for limit increase requests
public enum SupportingDocumentType: String, Codable, Sendable {
    case individualBankStatement = "individual_bank_statement"
    case individualTaxReturn = "individual_tax_return"
    case individualProofOfIncome = "individual_proof_of_income"
    case businessBankStatement = "business_bank_statement"
    case businessFinancialStatements = "business_financial_statements"
    case businessTaxReturn = "business_tax_return"
}

// MARK: - Limit Increase Request Status

/// Status of a limit increase request
public enum LimitIncreaseRequestStatus: String, Codable, Sendable {
    case inReview = "in_review"
    case approved = "approved"
    case rejected = "rejected"
}

// MARK: - Payin Limits

/// Payin limits for a receiver
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

/// Payout limits for a receiver
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

// MARK: - Receiver Limits Response

/// Response containing receiver limits
public struct ReceiverLimitsResponse: Codable, Sendable, Equatable {
    /// Limits object containing payin and payout limits
    public let limits: ReceiverLimitsDetail
    
    public init(limits: ReceiverLimitsDetail) {
        self.limits = limits
    }
}

/// Detailed limits information
public struct ReceiverLimitsDetail: Codable, Sendable, Equatable {
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
    /// Per transaction limit (optional, max: 100000000000)
    public let perTransaction: Int?
    
    /// Daily limit (optional, max: 100000000000)
    public let daily: Int?
    
    /// Monthly limit (optional, max: 100000000000)
    public let monthly: Int?
    
    /// Supporting document type
    public let supportingDocumentType: SupportingDocumentType
    
    /// Supporting document file URL
    public let supportingDocumentFile: String
    
    public init(
        perTransaction: Int? = nil,
        daily: Int? = nil,
        monthly: Int? = nil,
        supportingDocumentType: SupportingDocumentType,
        supportingDocumentFile: String
    ) {
        self.perTransaction = perTransaction
        self.daily = daily
        self.monthly = monthly
        self.supportingDocumentType = supportingDocumentType
        self.supportingDocumentFile = supportingDocumentFile
    }
    
    enum CodingKeys: String, CodingKey {
        case perTransaction = "per_transaction"
        case daily
        case monthly
        case supportingDocumentType = "supporting_document_type"
        case supportingDocumentFile = "supporting_document_file"
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
    
    /// Receiver ID
    public let receiverId: String
    
    /// Status of the request
    public let status: LimitIncreaseRequestStatus
    
    /// Created at timestamp
    public let createdAt: String
    
    /// Updated at timestamp
    public let updatedAt: String
    
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
    
    public init(
        id: String,
        receiverId: String,
        status: LimitIncreaseRequestStatus,
        createdAt: String,
        updatedAt: String,
        perTransaction: Int? = nil,
        daily: Int? = nil,
        monthly: Int? = nil,
        supportingDocumentFile: String? = nil,
        supportingDocumentType: SupportingDocumentType? = nil
    ) {
        self.id = id
        self.receiverId = receiverId
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.perTransaction = perTransaction
        self.daily = daily
        self.monthly = monthly
        self.supportingDocumentFile = supportingDocumentFile
        self.supportingDocumentType = supportingDocumentType
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case receiverId = "receiver_id"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case perTransaction = "per_transaction"
        case daily
        case monthly
        case supportingDocumentFile = "supporting_document_file"
        case supportingDocumentType = "supporting_document_type"
    }
}

