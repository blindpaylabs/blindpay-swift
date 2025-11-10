//
//  WebhookEndpoint.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

/// Represents a webhook event type
public enum WebhookEvent: String, Codable, Sendable {
    case receiverNew = "receiver.new"
    case receiverUpdate = "receiver.update"
    case bankAccountNew = "bankAccount.new"
    case payoutNew = "payout.new"
    case payoutUpdate = "payout.update"
}

/// Represents a webhook endpoint
public struct WebhookEndpoint: Codable, Sendable, Equatable {
    /// Unique identifier for the webhook endpoint
    public let id: String
    
    /// URL where webhooks will be sent
    public let url: String
    
    /// List of events this endpoint is subscribed to
    public let events: [WebhookEvent]
    
    /// Timestamp of the last event sent to this endpoint (null if no events sent)
    public let lastEventAt: String?
    
    /// Instance ID this endpoint belongs to
    public let instanceId: String
    
    /// Timestamp when the endpoint was created
    public let createdAt: String
    
    /// Timestamp when the endpoint was last updated
    public let updatedAt: String
    
    public init(
        id: String,
        url: String,
        events: [WebhookEvent],
        lastEventAt: String? = nil,
        instanceId: String,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.url = url
        self.events = events
        self.lastEventAt = lastEventAt
        self.instanceId = instanceId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case events
        case lastEventAt = "last_event_at"
        case instanceId = "instance_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

/// Response type for listing webhook endpoints
public typealias WebhookEndpointsResponse = [WebhookEndpoint]

/// Input for creating a new webhook endpoint
public struct CreateWebhookEndpointInput: Codable, Sendable {
    /// URL where webhooks will be sent
    public let url: String
    
    /// List of events to subscribe to
    public let events: [WebhookEvent]
    
    public init(url: String, events: [WebhookEvent]) {
        self.url = url
        self.events = events
    }
}

/// Response type for creating a webhook endpoint
public struct CreateWebhookEndpointResponse: Codable, Sendable {
    /// Unique identifier for the created webhook endpoint
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

/// Response type for getting webhook endpoint secret
public struct WebhookEndpointSecret: Codable, Sendable {
    /// The webhook secret key
    public let key: String
    
    public init(key: String) {
        self.key = key
    }
}

/// Response type for getting webhook portal access URL
public struct WebhookPortalAccess: Codable, Sendable {
    /// The portal access URL
    public let url: String
    
    public init(url: String) {
        self.url = url
    }
}

/// Response type for deleting a webhook endpoint
public struct DeleteWebhookEndpointResponse: Codable, Sendable {
    /// Indicates if the deletion was successful
    public let success: Bool
    
    public init(success: Bool) {
        self.success = success
    }
}

