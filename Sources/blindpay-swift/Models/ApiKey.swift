//
//  ApiKey.swift
//  blindpay-swift
//
//  Created by Eric Viana on 31/10/25.
//

import Foundation

/// Represents the permission level for an API key
public enum ApiKeyPermission: String, Codable, Sendable {
    case fullAccess = "full_access"
}

/// Represents an API key
public struct ApiKey: Codable, Sendable, Equatable {
    /// Unique identifier for the API key
    public let id: String
    
    /// Name of the API key
    public let name: String
    
    /// Permission level of the API key
    public let permission: ApiKeyPermission
    
    /// The API key token (only returned when creating or getting a single key)
    public let token: String
    
    /// Optional list of IP addresses allowed to use this key
    public let ipWhitelist: [String]?
    
    /// Unkey identifier associated with this API key
    public let unkeyId: String
    
    /// Timestamp when the key was last used (null if never used)
    public let lastUsedAt: String?
    
    /// Instance ID this key belongs to
    public let instanceId: String
    
    /// Timestamp when the key was created
    public let createdAt: String
    
    /// Timestamp when the key was last updated
    public let updatedAt: String
    
    public init(
        id: String,
        name: String,
        permission: ApiKeyPermission,
        token: String,
        ipWhitelist: [String]? = nil,
        unkeyId: String,
        lastUsedAt: String? = nil,
        instanceId: String,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.name = name
        self.permission = permission
        self.token = token
        self.ipWhitelist = ipWhitelist
        self.unkeyId = unkeyId
        self.lastUsedAt = lastUsedAt
        self.instanceId = instanceId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case permission
        case token
        case ipWhitelist = "ip_whitelist"
        case unkeyId = "unkey_id"
        case lastUsedAt = "last_used_at"
        case instanceId = "instance_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

/// Response type for listing API keys
public typealias ApiKeysResponse = [ApiKey]

/// Input for creating a new API key
public struct CreateApiKeyInput: Codable, Sendable {
    /// Name for the API key
    public let name: String
    
    /// Permission level for the API key
    public let permission: ApiKeyPermission
    
    /// Optional list of IP addresses allowed to use this key
    public let ipWhitelist: [String]?
    
    public init(name: String, permission: ApiKeyPermission = .fullAccess, ipWhitelist: [String]? = nil) {
        self.name = name
        self.permission = permission
        self.ipWhitelist = ipWhitelist
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case permission
        case ipWhitelist = "ip_whitelist"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(permission, forKey: .permission)
        if let ipWhitelist = ipWhitelist {
            try container.encode(ipWhitelist, forKey: .ipWhitelist)
        }
    }
}

/// Response type for creating an API key
public struct CreateApiKeyResponse: Codable, Sendable {
    /// Unique identifier for the created API key
    public let id: String
    
    /// The API key token (only shown once at creation)
    public let token: String
    
    public init(id: String, token: String) {
        self.id = id
        self.token = token
    }
}

