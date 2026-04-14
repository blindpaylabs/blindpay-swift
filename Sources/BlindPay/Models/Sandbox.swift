//
//  Sandbox.swift
//  blindpay-swift
//

import Foundation

// MARK: - Enums

/// Represents the status of a sandbox item
public enum SandboxStatus: String, Codable, Sendable {
    case active = "active"
    case inactive = "inactive"
}

// MARK: - SandboxItem

/// Represents a sandbox item
public struct Sandbox: Codable, Sendable, Equatable {
    /// Unique identifier for the sandbox item
    public let id: String

    /// Name of the sandbox item
    public let name: String

    /// Status of the sandbox item
    public let status: SandboxStatus

    /// Optional metadata key-value pairs
    public let metadata: [String: String]?

    /// Timestamp when the sandbox item was created
    public let createdAt: String?

    /// Timestamp when the sandbox item was last updated
    public let updatedAt: String?

    public init(
        id: String,
        name: String,
        status: SandboxStatus,
        metadata: [String: String]? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.metadata = metadata
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case metadata
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Response Types

/// Response type for listing sandbox items
public typealias SandboxesResponse = [Sandbox]

/// Response type for creating a sandbox item
public struct CreateSandboxResponse: Codable, Sendable, Equatable {
    /// Unique identifier for the created sandbox item
    public let id: String

    /// Name of the sandbox item
    public let name: String

    /// Status of the sandbox item
    public let status: SandboxStatus

    /// Optional metadata key-value pairs
    public let metadata: [String: String]?

    public init(
        id: String,
        name: String,
        status: SandboxStatus,
        metadata: [String: String]? = nil
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.metadata = metadata
    }
}

/// Response type for deleting a sandbox item
public struct DeleteSandboxResponse: Codable, Sendable, Equatable {
    /// Whether the deletion was successful
    public let success: Bool

    public init(success: Bool) {
        self.success = success
    }
}

// MARK: - Input Types

/// Input for creating a new sandbox item
public struct CreateSandboxInput: Codable, Sendable {
    /// Name for the sandbox item
    public let name: String

    /// Optional metadata key-value pairs
    public let metadata: [String: String]?

    public init(name: String, metadata: [String: String]? = nil) {
        self.name = name
        self.metadata = metadata
    }
}

/// Input for updating an existing sandbox item
public struct UpdateSandboxInput: Codable, Sendable {
    /// Optional new name for the sandbox item
    public let name: String?

    /// Optional metadata key-value pairs
    public let metadata: [String: String]?

    public init(name: String? = nil, metadata: [String: String]? = nil) {
        self.name = name
        self.metadata = metadata
    }
}
