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
    
    /// Bank account ID
    public let bankAccountId: String
    
    /// Instance ID
    public let instanceId: String
    
    /// Receiver ID
    public let receiverId: String
    
    /// Timestamp when the wallet was created
    public let createdAt: String
    
    /// Timestamp when the wallet was last updated
    public let updatedAt: String
    
    public init(
        id: String,
        externalId: String? = nil,
        network: Network,
        address: String,
        bankAccountId: String,
        instanceId: String,
        receiverId: String,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.externalId = externalId
        self.network = network
        self.address = address
        self.bankAccountId = bankAccountId
        self.instanceId = instanceId
        self.receiverId = receiverId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case externalId = "external_id"
        case network
        case address
        case bankAccountId = "bank_account_id"
        case instanceId = "instance_id"
        case receiverId = "receiver_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
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

