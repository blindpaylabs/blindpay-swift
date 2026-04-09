//
//  CustodialWallet.swift
//  blindpay-swift
//

import Foundation

// MARK: - Custodial Wallet

/// Represents a custodial wallet
public struct CustodialWallet: Codable, Sendable, Equatable {
    /// Unique identifier for the wallet
    public let id: String

    /// Wallet name
    public let name: String

    /// External ID
    public let externalId: String?

    /// Wallet address
    public let address: String

    /// Blockchain network
    public let network: Network

    /// Timestamp when the wallet was created
    public let createdAt: String

    public init(
        id: String,
        name: String,
        externalId: String? = nil,
        address: String,
        network: Network,
        createdAt: String
    ) {
        self.id = id
        self.name = name
        self.externalId = externalId
        self.address = address
        self.network = network
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case externalId = "external_id"
        case address
        case network
        case createdAt = "created_at"
    }
}

// MARK: - Response Types

/// Response type for listing custodial wallets
public typealias CustodialWalletsResponse = [CustodialWallet]

/// Response type for a single custodial wallet
public typealias CustodialWalletResponse = CustodialWallet

/// Response type for creating a custodial wallet
public typealias CreateCustodialWalletResponse = CustodialWallet

// MARK: - Balance Types

/// Represents a token balance in a custodial wallet
public struct WalletTokenBalance: Codable, Sendable, Equatable {
    /// Token contract address
    public let address: String

    /// Token ID
    public let id: String

    /// Token symbol
    public let symbol: String

    /// Token balance amount
    public let amount: Double

    public init(address: String, id: String, symbol: String, amount: Double) {
        self.address = address
        self.id = id
        self.symbol = symbol
        self.amount = amount
    }
}

/// Response type for getting wallet balance
public struct CustodialWalletBalanceResponse: Codable, Sendable, Equatable {
    /// USDC balance
    public let usdc: WalletTokenBalance?

    /// USDT balance
    public let usdt: WalletTokenBalance?

    /// USDB balance
    public let usdb: WalletTokenBalance?

    public init(usdc: WalletTokenBalance? = nil, usdt: WalletTokenBalance? = nil, usdb: WalletTokenBalance? = nil) {
        self.usdc = usdc
        self.usdt = usdt
        self.usdb = usdb
    }

    enum CodingKeys: String, CodingKey {
        case usdc = "USDC"
        case usdt = "USDT"
        case usdb = "USDB"
    }
}

// MARK: - Input Types

/// Input for creating a custodial wallet
public struct CreateCustodialWalletInput: Codable, Sendable {
    /// Wallet name
    public let name: String

    /// Blockchain network
    public let network: Network

    /// External ID
    public let externalId: String?

    public init(name: String, network: Network, externalId: String? = nil) {
        self.name = name
        self.network = network
        self.externalId = externalId
    }

    enum CodingKeys: String, CodingKey {
        case name
        case network
        case externalId = "external_id"
    }
}
