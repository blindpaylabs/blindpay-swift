//
//  Upload.swift
//  blindpay-swift
//

import Foundation

// MARK: - Enums

/// Represents the available upload bucket types
public struct UploadBucket: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let avatar = UploadBucket(rawValue: "avatar")
    public static let onboarding = UploadBucket(rawValue: "onboarding")
    public static let limitIncrease = UploadBucket(rawValue: "limit_increase")
    public static let documents = UploadBucket(rawValue: "documents")
}

// MARK: - Input Types

/// Input for uploading a file (`UploadIn`), sent as `multipart/form-data`
/// with the parts `file` and `bucket`.
public struct UploadInput: Sendable {
    /// The raw file bytes
    public let file: Data

    /// File name sent with the `file` part (e.g. `"passport.pdf"`)
    public let fileName: String

    /// MIME type sent with the `file` part (e.g. `"application/pdf"`)
    public let contentType: String

    /// The bucket to upload to
    public let bucket: UploadBucket

    public init(file: Data, fileName: String, contentType: String = "application/octet-stream", bucket: UploadBucket) {
        self.file = file
        self.fileName = fileName
        self.contentType = contentType
        self.bucket = bucket
    }
}

// MARK: - Response Types

/// Response type for upload operations (`UploadOut`)
public struct UploadResponse: Codable, Sendable, Equatable {
    /// The URL of the uploaded file
    public let fileUrl: String

    public init(fileUrl: String) {
        self.fileUrl = fileUrl
    }

    enum CodingKeys: String, CodingKey {
        case fileUrl = "file_url"
    }
}

// MARK: - Analyze

/// The kind of document ``UploadService/analyze(data:options:)`` checks.
public struct UploadAnalyzeType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let proofOfAddress = UploadAnalyzeType(rawValue: "proof_of_address")
    public static let identityDocument = UploadAnalyzeType(rawValue: "identity_document")
    public static let incorporationDocument = UploadAnalyzeType(rawValue: "incorporation_document")
    public static let proofOfOwnership = UploadAnalyzeType(rawValue: "proof_of_ownership")
    public static let sourceOfFunds = UploadAnalyzeType(rawValue: "source_of_funds")
    public static let selfie = UploadAnalyzeType(rawValue: "selfie")
    public static let bankStatement = UploadAnalyzeType(rawValue: "bank_statement")
    public static let taxReturn = UploadAnalyzeType(rawValue: "tax_return")
    public static let proofOfIncome = UploadAnalyzeType(rawValue: "proof_of_income")
    public static let financialStatement = UploadAnalyzeType(rawValue: "financial_statement")
    public static let invoice = UploadAnalyzeType(rawValue: "invoice")
    public static let transactionDocument = UploadAnalyzeType(rawValue: "transaction_document")
    public static let passport = UploadAnalyzeType(rawValue: "passport")
    public static let payStub = UploadAnalyzeType(rawValue: "pay_stub")
    public static let employmentLetter = UploadAnalyzeType(rawValue: "employment_letter")
    public static let investment = UploadAnalyzeType(rawValue: "investment")
    public static let cryptoExchange = UploadAnalyzeType(rawValue: "crypto_exchange")
    public static let blockchainWallet = UploadAnalyzeType(rawValue: "blockchain_wallet")
    public static let contract = UploadAnalyzeType(rawValue: "contract")
    public static let accountsReceivable = UploadAnalyzeType(rawValue: "accounts_receivable")
    public static let merchantProcessor = UploadAnalyzeType(rawValue: "merchant_processor")
    public static let shareholderLoan = UploadAnalyzeType(rawValue: "shareholder_loan")
}

/// How likely compliance is to approve an analyzed document.
public struct ApprovalRate: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let low = ApprovalRate(rawValue: "low")
    public static let medium = ApprovalRate(rawValue: "medium")
    public static let high = ApprovalRate(rawValue: "high")
}

/// Input for analyzing a document before submitting it (`UploadAnalyzeIn`),
/// sent as `multipart/form-data` with the parts `file`, `type` and, when
/// set, `metadata` (a JSON object string).
public struct UploadAnalyzeInput: Sendable {
    public let file: Data
    public let fileName: String
    public let contentType: String
    public let type: UploadAnalyzeType
    /// Expected values to check against the document (e.g.
    /// `["full_name": "Jane Doe"]`). A clear mismatch caps the rating at low.
    public let metadata: [String: String]?

    public init(file: Data, fileName: String, contentType: String = "application/octet-stream", type: UploadAnalyzeType, metadata: [String: String]? = nil) {
        self.file = file
        self.fileName = fileName
        self.contentType = contentType
        self.type = type
        self.metadata = metadata
    }
}

/// Result of analyzing a document (`UploadAnalyzeOut`).
public struct UploadAnalyzeResponse: Codable, Sendable, Equatable {
    public let approvalRate: ApprovalRate
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

// MARK: - Presign

/// Body of `POST /v1/presign`.
struct PresignInput: Codable, Sendable {
    let fileUrl: String

    enum CodingKeys: String, CodingKey {
        case fileUrl = "file_url"
    }
}

/// A temporary signed URL for a file you uploaded (`PresignOut`).
public struct PresignResponse: Codable, Sendable, Equatable {
    public let fileUrl: String
    public let expiresAt: String

    public init(fileUrl: String, expiresAt: String) {
        self.fileUrl = fileUrl
        self.expiresAt = expiresAt
    }

    enum CodingKeys: String, CodingKey {
        case fileUrl = "file_url"
        case expiresAt = "expires_at"
    }
}
