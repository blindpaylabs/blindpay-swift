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
