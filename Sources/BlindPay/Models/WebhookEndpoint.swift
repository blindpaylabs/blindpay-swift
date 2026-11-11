//
//  WebhookEndpoint.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

/// Represents a webhook event type
public struct WebhookEvent: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let customerNew = WebhookEvent(rawValue: "customer.new")
    public static let customerUpdate = WebhookEvent(rawValue: "customer.update")
    public static let customerDelete = WebhookEvent(rawValue: "customer.delete")
    public static let bankAccountNew = WebhookEvent(rawValue: "bankAccount.new")
    public static let payoutNew = WebhookEvent(rawValue: "payout.new")
    public static let payoutUpdate = WebhookEvent(rawValue: "payout.update")
    public static let payoutComplete = WebhookEvent(rawValue: "payout.complete")
    public static let payoutPartnerFee = WebhookEvent(rawValue: "payout.partnerFee")
    public static let blockchainWalletNew = WebhookEvent(rawValue: "blockchainWallet.new")
    public static let payinNew = WebhookEvent(rawValue: "payin.new")
    public static let payinUpdate = WebhookEvent(rawValue: "payin.update")
    public static let payinComplete = WebhookEvent(rawValue: "payin.complete")
    public static let payinPartnerFee = WebhookEvent(rawValue: "payin.partnerFee")
    public static let tosAccept = WebhookEvent(rawValue: "tos.accept")
    public static let limitIncreaseNew = WebhookEvent(rawValue: "limitIncrease.new")
    public static let limitIncreaseUpdate = WebhookEvent(rawValue: "limitIncrease.update")
    public static let virtualAccountNew = WebhookEvent(rawValue: "virtualAccount.new")
    public static let virtualAccountComplete = WebhookEvent(rawValue: "virtualAccount.complete")
    public static let transferNew = WebhookEvent(rawValue: "transfer.new")
    public static let transferUpdate = WebhookEvent(rawValue: "transfer.update")
    public static let transferComplete = WebhookEvent(rawValue: "transfer.complete")
    public static let walletNew = WebhookEvent(rawValue: "wallet.new")
    public static let walletInbound = WebhookEvent(rawValue: "wallet.inbound")
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
    public let createdAt: String?
    
    /// Timestamp when the endpoint was last updated
    public let updatedAt: String?
    
    public init(
        id: String,
        url: String,
        events: [WebhookEvent],
        lastEventAt: String? = nil,
        instanceId: String,
        createdAt: String? = nil,
        updatedAt: String? = nil
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
