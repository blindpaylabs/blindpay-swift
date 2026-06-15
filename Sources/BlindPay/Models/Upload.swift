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

/// Represents the document approval rate
public enum ApprovalRate: String, Codable, Sendable {
    case high = "high"
    case medium = "medium"
    case low = "low"
}

/// Represents the Aiprise document type
public enum AipriseDocumentType: String, Codable, Sendable {
    case addressProofDocument = "ADDRESS_PROOF_DOCUMENT"
    case bankStatementDocument = "BANK_STATEMENT_DOCUMENT"
    case other = "OTHER"
    case sourceOfFundsDocument = "SOURCE_OF_FUNDS_DOCUMENT"
    case taxCertificate = "TAX_CERTIFICATE"
    case userSelfie = "USER_SELFIE"
    case visaDocument = "VISA_DOCUMENT"
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
    /// The file to analyze (base64 encoded or URL)
    public let file: String

    /// The document type
    public let documentType: AipriseDocumentType

    /// Additional metadata for analysis
    public let metadata: String?

    public init(file: String, documentType: AipriseDocumentType, metadata: String? = nil) {
        self.file = file
        self.documentType = documentType
        self.metadata = metadata
    }

    enum CodingKeys: String, CodingKey {
        case file
        case documentType = "document_type"
        case metadata
    }
}

/// Response type for document analysis
public struct UploadAnalyzeResponse: Codable, Sendable, Equatable {
    /// The approval rate for the analyzed document
    public let approvalRate: ApprovalRate

    /// Description of the analysis result
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
