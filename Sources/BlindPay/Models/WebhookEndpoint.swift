//
//  WebhookEndpoint.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

/// Represents a webhook event type
public struct WebhookEventType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let customerNew = WebhookEventType(rawValue: "customer.new")
    public static let customerUpdate = WebhookEventType(rawValue: "customer.update")
    public static let customerDelete = WebhookEventType(rawValue: "customer.delete")
    public static let bankAccountNew = WebhookEventType(rawValue: "bankAccount.new")
    public static let payoutNew = WebhookEventType(rawValue: "payout.new")
    public static let payoutUpdate = WebhookEventType(rawValue: "payout.update")
    public static let payoutComplete = WebhookEventType(rawValue: "payout.complete")
    public static let payoutPartnerFee = WebhookEventType(rawValue: "payout.partnerFee")
    public static let blockchainWalletNew = WebhookEventType(rawValue: "blockchainWallet.new")
    public static let payinNew = WebhookEventType(rawValue: "payin.new")
    public static let payinUpdate = WebhookEventType(rawValue: "payin.update")
    public static let payinComplete = WebhookEventType(rawValue: "payin.complete")
    public static let payinPartnerFee = WebhookEventType(rawValue: "payin.partnerFee")
    public static let tosAccept = WebhookEventType(rawValue: "tos.accept")
    public static let limitIncreaseNew = WebhookEventType(rawValue: "limitIncrease.new")
    public static let limitIncreaseUpdate = WebhookEventType(rawValue: "limitIncrease.update")
    public static let virtualAccountNew = WebhookEventType(rawValue: "virtualAccount.new")
    public static let virtualAccountComplete = WebhookEventType(rawValue: "virtualAccount.complete")
    public static let transferNew = WebhookEventType(rawValue: "transfer.new")
    public static let transferUpdate = WebhookEventType(rawValue: "transfer.update")
    public static let transferComplete = WebhookEventType(rawValue: "transfer.complete")
    public static let walletNew = WebhookEventType(rawValue: "wallet.new")
    public static let walletInbound = WebhookEventType(rawValue: "wallet.inbound")
    public static let walletUpdate = WebhookEventType(rawValue: "wallet.update")
    public static let blockchainWalletUpdate = WebhookEventType(rawValue: "blockchainWallet.update")
    public static let payableNew = WebhookEventType(rawValue: "payable.new")
    public static let payableUpdate = WebhookEventType(rawValue: "payable.update")
    public static let payableComplete = WebhookEventType(rawValue: "payable.complete")
}

/// Represents a webhook endpoint
public struct WebhookEndpoint: Codable, Sendable, Equatable {
    /// Unique identifier for the webhook endpoint
    public let id: String
    
    /// URL where webhooks will be sent
    public let url: String
    
    /// List of events this endpoint is subscribed to
    public let events: [WebhookEventType]
    
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
        events: [WebhookEventType],
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
    public let events: [WebhookEventType]
    
    public init(url: String, events: [WebhookEventType]) {
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
