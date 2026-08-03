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
    
    /// Optional customer ID (15 characters)
    public let customerId: String?

    /// Optional redirect URL (URI format)
    public let redirectUrl: String?

    public init(idempotencyKey: String, customerId: String? = nil, redirectUrl: String? = nil) {
        self.idempotencyKey = idempotencyKey
        self.customerId = customerId
        self.redirectUrl = redirectUrl
    }

    enum CodingKeys: String, CodingKey {
        case idempotencyKey = "idempotency_key"
        case customerId = "customer_id"
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

