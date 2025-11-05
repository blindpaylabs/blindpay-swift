//
//  TermsOfService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

/// Input for initiating a new terms of service
public struct InitiateTosInput: Codable, Sendable {
    /// Idempotency key for the request (UUID format)
    public let idempotencyKey: String
    
    /// Optional receiver ID (15 characters)
    public let receiverId: String?
    
    /// Optional redirect URL (URI format)
    public let redirectUrl: String?
    
    public init(idempotencyKey: String, receiverId: String? = nil, redirectUrl: String? = nil) {
        self.idempotencyKey = idempotencyKey
        self.receiverId = receiverId
        self.redirectUrl = redirectUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case idempotencyKey = "idempotency_key"
        case receiverId = "receiver_id"
        case redirectUrl = "redirect_url"
    }
}

/// Response type for initiating terms of service
public struct InitiateTosResponse: Codable, Sendable {
    /// URL for the terms of service session
    public let url: String
    
    public init(url: String) {
        self.url = url
    }
}

/// Input for accepting terms of service
public struct AcceptTosInput: Codable, Sendable {
    /// Idempotency key for the request (UUID format)
    public let idempotencyKey: String
    
    /// Session identifier
    public let session: String
    
    /// Session token (JWT format)
    public let sessionToken: String
    
    /// Optional receiver ID (15 characters)
    public let receiverId: String?
    
    public init(idempotencyKey: String, session: String, sessionToken: String, receiverId: String? = nil) {
        self.idempotencyKey = idempotencyKey
        self.session = session
        self.sessionToken = sessionToken
        self.receiverId = receiverId
    }
    
    enum CodingKeys: String, CodingKey {
        case idempotencyKey = "idempotency_key"
        case session
        case sessionToken = "session_token"
        case receiverId = "receiver_id"
    }
}

/// Response type for accepting terms of service
public struct AcceptTosResponse: Codable, Sendable {
    /// Unique identifier for the terms of service
    public let tosId: String
    
    /// Idempotency key used for the request
    public let idempotencyKey: String
    
    /// Receiver ID associated with the acceptance
    public let receiverId: String?
    
    /// Version of the terms of service
    public let version: String
    
    public init(tosId: String, idempotencyKey: String, receiverId: String?, version: String) {
        self.tosId = tosId
        self.idempotencyKey = idempotencyKey
        self.receiverId = receiverId
        self.version = version
    }
    
    enum CodingKeys: String, CodingKey {
        case tosId = "tos_id"
        case idempotencyKey = "idempotency_key"
        case receiverId = "receiver_id"
        case version
    }
}

