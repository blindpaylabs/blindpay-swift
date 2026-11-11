//
//  OfframpWallet.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Represents an offramp wallet
public struct OfframpWallet: Codable, Sendable, Equatable {
    /// Unique identifier for the offramp wallet
    public let id: String
    
    /// External ID (optional)
    public let externalId: String?
    
    /// Blockchain network
    public let network: Network
    
    /// Wallet address
    public let address: String
    
    /// Bank account ID (omitted when nested inside a bank account)
    public let bankAccountId: String?

    /// Instance ID (omitted when nested inside a bank account)
    public let instanceId: String?

    /// Customer ID (omitted when nested inside a bank account)
    public let customerId: String?

    /// Timestamp when the wallet was created (omitted when nested inside a bank account)
    public let createdAt: String?

    /// Timestamp when the wallet was last updated (omitted when nested inside a bank account)
    public let updatedAt: String?

    public let partnerFeeId: String?

    public init(
        id: String,
        externalId: String? = nil,
        network: Network,
        address: String,
        bankAccountId: String? = nil,
        instanceId: String? = nil,
        customerId: String? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        partnerFeeId: String? = nil
    ) {
        self.id = id
        self.externalId = externalId
        self.network = network
        self.address = address
        self.bankAccountId = bankAccountId
        self.instanceId = instanceId
        self.customerId = customerId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.partnerFeeId = partnerFeeId
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case externalId = "external_id"
        case network
        case address
        case bankAccountId = "bank_account_id"
        case instanceId = "instance_id"
        case customerId = "customer_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case partnerFeeId = "partner_fee_id"
    }
}

// MARK: - Response Types

/// Response type for listing offramp wallets
public typealias OfframpWalletsResponse = [OfframpWallet]

/// Response type for single offramp wallet
public typealias OfframpWalletResponse = OfframpWallet

/// Response type for creating an offramp wallet
public struct CreateOfframpWalletResponse: Codable, Sendable, Equatable {
    /// Unique identifier for the created offramp wallet
    public let id: String
    
    /// External ID (optional)
    public let externalId: String?
    
    /// Blockchain network
    public let network: Network
    
    /// Wallet address
    public let address: String
    
    public init(id: String, externalId: String? = nil, network: Network, address: String) {
        self.id = id
        self.externalId = externalId
        self.network = network
        self.address = address
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case externalId = "external_id"
        case network
        case address
    }
}

// MARK: - Input Types

/// Input for creating an offramp wallet
public struct CreateOfframpWalletInput: Codable, Sendable {
    /// Blockchain network (tron or solana)
    public let network: Network
    
    /// External ID (optional)
    public let externalId: String?
    
    public init(network: Network, externalId: String? = nil) {
        self.network = network
        self.externalId = externalId
    }
    
    enum CodingKeys: String, CodingKey {
        case network
        case externalId = "external_id"
    }
}


// MARK: - Update

/// Input for updating an offramp wallet. `partner_fee_id` is tri-state:
/// leave it unchanged, set it, or clear it (sent as `null`).
public struct UpdateOfframpWalletInput: Encodable, Sendable, Equatable {
    /// What to do with the wallet's partner fee.
    public enum PartnerFee: Sendable, Equatable {
        case unchanged
        case set(String)
        case clear
    }

    public let partnerFee: PartnerFee

    public init(partnerFee: PartnerFee) {
        self.partnerFee = partnerFee
    }

    enum CodingKeys: String, CodingKey {
        case partnerFeeId = "partner_fee_id"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch partnerFee {
        case .unchanged: break
        case .set(let id): try container.encode(id, forKey: .partnerFeeId)
        case .clear: try container.encodeNil(forKey: .partnerFeeId)
        }
    }
}
