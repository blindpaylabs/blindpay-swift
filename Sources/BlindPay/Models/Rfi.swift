//
//  Rfi.swift
//  blindpay-swift
//

import Foundation

/// Status of a request for information.
public struct RfiStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let pending = RfiStatus(rawValue: "pending")
    public static let submitted = RfiStatus(rawValue: "submitted")
    public static let expired = RfiStatus(rawValue: "expired")
    public static let cancelled = RfiStatus(rawValue: "cancelled")
}

/// One answer in an RFI response: text, or the URLs of uploaded files
/// (upload them first with ``UploadService/create(data:options:)``).
public enum RfiValue: Codable, Sendable, Equatable, ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
    case text(String)
    case files([String])

    public init(stringLiteral value: String) { self = .text(value) }
    public init(arrayLiteral elements: String...) { self = .files(elements) }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let text = try? container.decode(String.self) {
            self = .text(text)
        } else {
            self = .files(try container.decode([String].self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let text): try container.encode(text)
        case .files(let urls): try container.encode(urls)
        }
    }
}

/// RFI answers keyed by field key (``RfiField/key``). Submitted as the whole
/// JSON body.
public typealias RfiResponse = [String: RfiValue]

/// Result of submitting an RFI. `success` is false (with `reason`) when no
/// RFI is pending.
public struct RfiSubmitResponse: Codable, Sendable, Equatable {
    public let success: Bool
    public let reason: String?

    public init(success: Bool, reason: String? = nil) {
        self.success = success
        self.reason = reason
    }
}

/// One field to answer in an RFI section.
public struct RfiField: Codable, Sendable, Equatable {
    public let key: String
    public let label: String
    public let regex: String?
    public let required: Bool
    public let items: [String]?
    public let multiple: Bool?

    public init(
        key: String,
        label: String,
        regex: String? = nil,
        required: Bool,
        items: [String]? = nil,
        multiple: Bool? = nil
    ) {
        self.key = key
        self.label = label
        self.regex = regex
        self.required = required
        self.items = items
        self.multiple = multiple
    }

    enum CodingKeys: String, CodingKey {
        case key
        case label
        case regex
        case required
        case items
        case multiple
    }
}

/// A section of an RFI.
public struct RfiSection: Codable, Sendable, Equatable {
    public let title: String
    public let description: String
    public let supportingDocument: String?
    public let fields: [RfiField]

    public init(
        title: String,
        description: String,
        supportingDocument: String? = nil,
        fields: [RfiField]
    ) {
        self.title = title
        self.description = description
        self.supportingDocument = supportingDocument
        self.fields = fields
    }

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case supportingDocument = "supporting_document"
        case fields
    }
}

/// A customer's request for information (RFI): the documents and answers compliance needs.
public struct Rfi: Codable, Sendable, Equatable {
    public let id: String
    public let customerId: String
    public let instanceId: String
    public let status: RfiStatus
    public let request: [RfiSection]
    public let response: RfiResponse
    public let expiresAt: String
    public let submittedAt: String?
    public let createdAt: String
    public let customerType: CustomerType?
    public let customerKycStatus: String?

    public init(
        id: String,
        customerId: String,
        instanceId: String,
        status: RfiStatus,
        request: [RfiSection],
        response: RfiResponse,
        expiresAt: String,
        submittedAt: String? = nil,
        createdAt: String,
        customerType: CustomerType? = nil,
        customerKycStatus: String? = nil
    ) {
        self.id = id
        self.customerId = customerId
        self.instanceId = instanceId
        self.status = status
        self.request = request
        self.response = response
        self.expiresAt = expiresAt
        self.submittedAt = submittedAt
        self.createdAt = createdAt
        self.customerType = customerType
        self.customerKycStatus = customerKycStatus
    }

    enum CodingKeys: String, CodingKey {
        case id
        case customerId = "customer_id"
        case instanceId = "instance_id"
        case status
        case request
        case response
        case expiresAt = "expires_at"
        case submittedAt = "submitted_at"
        case createdAt = "created_at"
        case customerType = "customer_type"
        case customerKycStatus = "customer_kyc_status"
    }
}

/// An RFI addressed to the instance itself (your business).
public struct InstanceRfi: Codable, Sendable, Equatable {
    public let id: String
    public let instanceId: String
    public let status: RfiStatus
    public let request: [RfiSection]
    public let response: RfiResponse
    public let expiresAt: String
    public let submittedAt: String?
    public let createdAt: String

    public init(
        id: String,
        instanceId: String,
        status: RfiStatus,
        request: [RfiSection],
        response: RfiResponse,
        expiresAt: String,
        submittedAt: String? = nil,
        createdAt: String
    ) {
        self.id = id
        self.instanceId = instanceId
        self.status = status
        self.request = request
        self.response = response
        self.expiresAt = expiresAt
        self.submittedAt = submittedAt
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case instanceId = "instance_id"
        case status
        case request
        case response
        case expiresAt = "expires_at"
        case submittedAt = "submitted_at"
        case createdAt = "created_at"
    }
}

