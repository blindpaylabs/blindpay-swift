//
//  BlockchainWallet.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Represents a blockchain wallet
public struct BlockchainWallet: Codable, Sendable, Equatable {
    /// Unique identifier for the blockchain wallet
    public let id: String
    
    /// Display name for the wallet
    public let name: String
    
    /// Blockchain network
    public let network: Network
    
    /// Receiver ID this wallet belongs to
    public let receiverId: String
    
    /// Wallet address (optional)
    public let address: String?
    
    /// Whether this is an account abstraction wallet
    public let isAccountAbstraction: Bool?
    
    /// Signature transaction hash (optional)
    public let signatureTxHash: String?
    
    public init(
        id: String,
        name: String,
        network: Network,
        receiverId: String,
        address: String? = nil,
        isAccountAbstraction: Bool? = nil,
        signatureTxHash: String? = nil
    ) {
        self.id = id
        self.name = name
        self.network = network
        self.receiverId = receiverId
        self.address = address
        self.isAccountAbstraction = isAccountAbstraction
        self.signatureTxHash = signatureTxHash
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case network
        case receiverId = "receiver_id"
        case address
        case isAccountAbstraction = "is_account_abstraction"
        case signatureTxHash = "signature_tx_hash"
    }
}

// MARK: - Response Types

/// Response type for listing blockchain wallets
public typealias BlockchainWalletsResponse = [BlockchainWallet]

/// Response type for single blockchain wallet
public typealias BlockchainWalletResponse = BlockchainWallet

/// Response type for creating a blockchain wallet
public typealias CreateBlockchainWalletResponse = BlockchainWallet

/// Response type for sign message
public struct BlockchainWalletSignMessageResponse: Codable, Sendable, Equatable {
    /// Message to sign
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}

// MARK: - Input Types

/// Input for creating a blockchain wallet
public struct CreateBlockchainWalletInput: Codable, Sendable {
    /// Display name for the wallet
    public let name: String
    
    /// Blockchain network
    public let network: Network
    
    /// Wallet address (optional)
    public let address: String?
    
    /// Whether this is an account abstraction wallet (optional)
    public let isAccountAbstraction: Bool?
    
    /// Signature transaction hash (optional)
    public let signatureTxHash: String?
    
    public init(
        name: String,
        network: Network,
        address: String? = nil,
        isAccountAbstraction: Bool? = nil,
        signatureTxHash: String? = nil
    ) {
        self.name = name
        self.network = network
        self.address = address
        self.isAccountAbstraction = isAccountAbstraction
        self.signatureTxHash = signatureTxHash
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case network
        case address
        case isAccountAbstraction = "is_account_abstraction"
        case signatureTxHash = "signature_tx_hash"
    }
}

// MARK: - Asset Trustline

/// Input for creating an asset trustline
public struct CreateAssetTrustlineInput: Codable, Sendable {
    /// Wallet address
    public let address: String
    
    public init(address: String) {
        self.address = address
    }
}

/// Response for creating an asset trustline
public struct CreateAssetTrustlineResponse: Codable, Sendable, Equatable {
    /// XDR (Transaction Envelope) string
    public let xdr: String
    
    public init(xdr: String) {
        self.xdr = xdr
    }
}

// MARK: - Mint USDB

/// Input for minting USDB on Stellar
public struct MintUsdbStellarInput: Codable, Sendable {
    /// Wallet address
    public let address: String
    
    /// Amount to mint
    public let amount: String
    
    /// Signed XDR (optional)
    public let signedXdr: String?
    
    public init(address: String, amount: String, signedXdr: String? = nil) {
        self.address = address
        self.amount = amount
        self.signedXdr = signedXdr
    }
    
    enum CodingKeys: String, CodingKey {
        case address
        case amount
        case signedXdr = "signedXdr"
    }
}

/// Response for minting USDB on Stellar
public struct MintUsdbStellarResponse: Codable, Sendable, Equatable {
    /// Whether the operation was successful
    public let success: Bool
    
    public init(success: Bool) {
        self.success = success
    }
}

/// Input for minting USDB on Solana Devnet
public struct MintUsdbSolanaInput: Codable, Sendable {
    /// Wallet address
    public let address: String
    
    /// Amount to mint
    public let amount: String
    
    public init(address: String, amount: String) {
        self.address = address
        self.amount = amount
    }
}

/// Response for minting USDB on Solana Devnet
public struct MintUsdbSolanaResponse: Codable, Sendable, Equatable {
    /// Whether the operation was successful
    public let success: Bool
    
    /// Transaction signature (optional)
    public let signature: String?
    
    /// Error message (optional)
    public let error: String?
    
    public init(success: Bool, signature: String? = nil, error: String? = nil) {
        self.success = success
        self.signature = signature
        self.error = error
    }
}

// MARK: - Solana Delegate

/// Input for preparing a Solana delegate transaction
public struct PrepareDelegateSolanaInput: Codable, Sendable {
    /// Amount to delegate
    public let amount: String
    
    /// Owner address
    public let ownerAddress: String
    
    /// Token address
    public let tokenAddress: String
    
    public init(amount: String, ownerAddress: String, tokenAddress: String) {
        self.amount = amount
        self.ownerAddress = ownerAddress
        self.tokenAddress = tokenAddress
    }
    
    enum CodingKeys: String, CodingKey {
        case amount
        case ownerAddress = "owner_address"
        case tokenAddress = "token_address"
    }
}

/// Response for preparing a Solana delegate transaction
public struct PrepareDelegateSolanaResponse: Codable, Sendable, Equatable {
    /// Whether the operation was successful
    public let success: Bool
    
    /// Transaction string (optional)
    public let transaction: String?
    
    /// Debug information (optional)
    public let debug: String?
    
    public init(success: Bool, transaction: String? = nil, debug: String? = nil) {
        self.success = success
        self.transaction = transaction
        self.debug = debug
    }
}

