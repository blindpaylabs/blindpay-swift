//
//  Rfi.swift
//  blindpay-swift
//

import Foundation

// MARK: - Enums

/// RFI status
public enum RfiStatus: String, Codable, Sendable {
    case pending = "pending"
    case submitted = "submitted"
    case expired = "expired"
    case cancelled = "cancelled"
}

// MARK: - RFI Section

/// RFI section structure
public struct RfiSection: Codable, Sendable, Equatable {
    // This will be a flexible structure as the API doesn't specify exact fields
    // We'll use AnyCodable to handle the dynamic nature of RFI sections
    public let value: [String: AnyCodable]

    public init(value: [String: AnyCodable]) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dictionary = try container.decode([String: AnyCodable].self)
        self.value = dictionary
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

// MARK: - RFI

/// Request for Information (RFI) model
public struct Rfi: Codable, Sendable, Equatable {
    /// RFI ID
    public let id: String

    /// Receiver ID
    public let receiverId: String

    /// Instance ID
    public let instanceId: String

    /// RFI status
    public let status: RfiStatus

    /// RFI request sections
    public let request: [RfiSection]

    /// RFI response (flexible object structure)
    public let response: [String: AnyCodable]

    /// RFI expiration timestamp
    public let expiresAt: String

    /// RFI submission timestamp (nullable)
    public let submittedAt: String?

    /// RFI creation timestamp
    public let createdAt: String

    /// Receiver type
    public let receiverType: ReceiverType

    /// Receiver Aiprise session ID (nullable)
    public let receiverAipriseSessionId: String?

    /// Receiver KYC status
    public let receiverKycStatus: String

    public init(
        id: String,
        receiverId: String,
        instanceId: String,
        status: RfiStatus,
        request: [RfiSection],
        response: [String: AnyCodable],
        expiresAt: String,
        submittedAt: String? = nil,
        createdAt: String,
        receiverType: ReceiverType,
        receiverAipriseSessionId: String? = nil,
        receiverKycStatus: String
    ) {
        self.id = id
        self.receiverId = receiverId
        self.instanceId = instanceId
        self.status = status
        self.request = request
        self.response = response
        self.expiresAt = expiresAt
        self.submittedAt = submittedAt
        self.createdAt = createdAt
        self.receiverType = receiverType
        self.receiverAipriseSessionId = receiverAipriseSessionId
        self.receiverKycStatus = receiverKycStatus
    }

    enum CodingKeys: String, CodingKey {
        case id
        case receiverId = "receiver_id"
        case instanceId = "instance_id"
        case status
        case request
        case response
        case expiresAt = "expires_at"
        case submittedAt = "submitted_at"
        case createdAt = "created_at"
        case receiverType = "receiver_type"
        case receiverAipriseSessionId = "receiver_aiprise_session_id"
        case receiverKycStatus = "receiver_kyc_status"
    }
}

// MARK: - Input Types

/// Input for submitting RFI response
public struct SubmitRfiInput: Codable, Sendable {
    /// RFI response data (flexible structure)
    public let response: [String: AnyCodable]

    public init(response: [String: AnyCodable]) {
        self.response = response
    }
}

// MARK: - Response Types

/// Response type for getting an RFI
public typealias RfiResponse = Rfi

/// Response type for submitting RFI
public struct SubmitRfiResponse: Codable, Sendable, Equatable {
    /// Whether the submission was successful
    public let success: Bool

    public init(success: Bool) {
        self.success = success
    }
}