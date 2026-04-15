//
//  Upload.swift
//  blindpay-swift
//

import Foundation

// MARK: - Enums

/// Storage bucket for file uploads
public enum UploadBucket: String, Codable, Sendable {
    case avatar = "avatar"
    case onboarding = "onboarding"
    case limitIncrease = "limit_increase"
}

// MARK: - Response Types

/// Response for a file upload
public struct UploadResponse: Codable, Sendable, Equatable {
    /// URL of the uploaded file
    public let fileUrl: String

    public init(fileUrl: String) {
        self.fileUrl = fileUrl
    }

    enum CodingKeys: String, CodingKey {
        case fileUrl = "file_url"
    }
}
