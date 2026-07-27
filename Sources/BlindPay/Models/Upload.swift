//
//  Upload.swift
//  blindpay-swift
//

import Foundation

// MARK: - Enums

/// Represents the available upload bucket types
public enum UploadBucket: String, Codable, Sendable {
    case avatar = "avatar"
    case onboarding = "onboarding"
    case limitIncrease = "limit_increase"
}

/// Confidence that an analyzed document should be approved
public enum ApprovalRate: String, Codable, Sendable {
    case high = "high"
    case medium = "medium"
    case low = "low"
}

/// The kind of document being analyzed, selecting the rule set used for the analysis
public enum AipriseDocumentType: String, Codable, Sendable {
    case proofOfAddress = "proof_of_address"
    case identityDocument = "identity_document"
    case incorporationDocument = "incorporation_document"
    case proofOfOwnership = "proof_of_ownership"
    case sourceOfFunds = "source_of_funds"
    case selfie = "selfie"
    case bankStatement = "bank_statement"
    case taxReturn = "tax_return"
    case proofOfIncome = "proof_of_income"
    case financialStatement = "financial_statement"
    case invoice = "invoice"
    case transactionDocument = "transaction_document"
    case passport = "passport"
    case payStub = "pay_stub"
    case employmentLetter = "employment_letter"
    case investment = "investment"
    case cryptoExchange = "crypto_exchange"
    case blockchainWallet = "blockchain_wallet"
    case contract = "contract"
    case accountsReceivable = "accounts_receivable"
    case merchantProcessor = "merchant_processor"
    case shareholderLoan = "shareholder_loan"
}

// MARK: - Input Types

/// Input for creating an upload
public struct UploadInput: Codable, Sendable {
    /// The bucket to upload to
    public let bucket: UploadBucket

    /// The file to upload (base64 encoded or URL)
    public let file: String

    public init(bucket: UploadBucket, file: String) {
        self.bucket = bucket
        self.file = file
    }
}

// MARK: - Response Types

/// Response type for upload operations
public struct UploadResponse: Codable, Sendable, Equatable {
    /// The URL of the uploaded file
    public let url: String

    public init(url: String) {
        self.url = url
    }
}

/// Input for analyzing a document upload
public struct UploadAnalyzeInput: Codable, Sendable {
    /// The document to analyze (base64 encoded or URL), PDF, JPG, or PNG
    public let file: String

    /// The kind of document being analyzed
    public let documentType: AipriseDocumentType

    /// Optional JSON object of expected values to verify against the document. When provided, a clear mismatch caps the rating at low.
    public let metadata: String?

    public init(file: String, documentType: AipriseDocumentType, metadata: String? = nil) {
        self.file = file
        self.documentType = documentType
        self.metadata = metadata
    }

    enum CodingKeys: String, CodingKey {
        case file
        case documentType = "type"
        case metadata
    }
}

/// Response type for document analysis
public struct UploadAnalyzeResponse: Codable, Sendable, Equatable {
    /// Confidence that the document should be approved
    public let approvalRate: ApprovalRate

    /// Short explanation of why the document should or should not be approved
    public let description: String

    public init(approvalRate: ApprovalRate, description: String) {
        self.approvalRate = approvalRate
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case approvalRate = "approval_rate"
        case description
    }
}
