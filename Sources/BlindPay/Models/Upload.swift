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
    case documents = "documents"
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
