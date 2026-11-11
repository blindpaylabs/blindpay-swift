//
//  CustodialWallet.swift
//  blindpay-swift
//
//  Created by Eric Viana on 09/04/26.
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
    public let address: String?

    /// Blockchain network
    public let network: Network

    /// Timestamp when the wallet was created
    public let createdAt: String?

    public let yieldStatus: WalletYieldStatus?

    public init(
        id: String,
        name: String,
        externalId: String? = nil,
        address: String? = nil,
        network: Network,
        createdAt: String? = nil,
        yieldStatus: WalletYieldStatus? = nil
    ) {
        self.id = id
        self.name = name
        self.externalId = externalId
        self.address = address
        self.network = network
        self.createdAt = createdAt
        self.yieldStatus = yieldStatus
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case externalId = "external_id"
        case address
        case network
        case createdAt = "created_at"
        case yieldStatus = "yield_status"
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

    public let eurb: WalletTokenBalance?

    public let eurc: WalletTokenBalance?

    public init(usdc: WalletTokenBalance? = nil, usdt: WalletTokenBalance? = nil, usdb: WalletTokenBalance? = nil, eurb: WalletTokenBalance? = nil, eurc: WalletTokenBalance? = nil) {
        self.usdc = usdc
        self.usdt = usdt
        self.usdb = usdb
        self.eurb = eurb
        self.eurc = eurc
    }

    enum CodingKeys: String, CodingKey {
        case usdc = "USDC"
        case usdt = "USDT"
        case usdb = "USDB"
        case eurb = "EURB"
        case eurc = "EURC"
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

// MARK: - Yield

/// Whether yield is on for a managed wallet.
public struct WalletYieldStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let disabled = WalletYieldStatus(rawValue: "disabled")
    public static let enabled = WalletYieldStatus(rawValue: "enabled")
    public static let disabling = WalletYieldStatus(rawValue: "disabling")
}

// MARK: - Deposits

/// Status of a deposit into a managed wallet.
public struct WalletDepositStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let processing = WalletDepositStatus(rawValue: "processing")
    public static let completed = WalletDepositStatus(rawValue: "completed")
    public static let onHold = WalletDepositStatus(rawValue: "on_hold")
    public static let refunded = WalletDepositStatus(rawValue: "refunded")
}

/// A deposit into a managed wallet. `amount` is in cents; `tokenAmount` is the token amount as a decimal string.
public struct WalletDeposit: Codable, Sendable, Equatable {
    public let id: String
    public let walletId: String
    public let network: Network
    public let token: StablecoinToken
    /// In cents
    public let amount: Int
    /// Exact amount in token units, as a decimal string
    public let tokenAmount: String?
    /// processing while the deposit is being checked, on_hold while the funds are held, refunded once returned to the sender
    public let status: WalletDepositStatus
    public let transactionHash: String
    public let senderAddress: String?
    public let createdAt: String

    public init(
        id: String,
        walletId: String,
        network: Network,
        token: StablecoinToken,
        amount: Int,
        tokenAmount: String? = nil,
        status: WalletDepositStatus,
        transactionHash: String,
        senderAddress: String? = nil,
        createdAt: String
    ) {
        self.id = id
        self.walletId = walletId
        self.network = network
        self.token = token
        self.amount = amount
        self.tokenAmount = tokenAmount
        self.status = status
        self.transactionHash = transactionHash
        self.senderAddress = senderAddress
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case walletId = "wallet_id"
        case network
        case token
        case amount
        case tokenAmount = "token_amount"
        case status
        case transactionHash = "transaction_hash"
        case senderAddress = "sender_address"
        case createdAt = "created_at"
    }
}


/// One page of wallet deposits (the API always paginates this list).
public typealias WalletDepositsResponse = ListResult<WalletDeposit>

/// Filters and cursors for listing a managed wallet's deposits. Every value is optional; unset ones are not sent.
public struct ListWalletDepositsInput: CursorPaginatedInput {
    /// Page size (5, 10, 50, 100 or 200).
    public var limit: Int?

    /// Return items after this id (the previous page's `pagination.nextPage`).
    public var startingAfter: String?

    /// Return items before this id.
    public var endingBefore: String?

    /// Only this token.
    public var token: StablecoinToken?

    /// Only this status.
    public var status: WalletDepositStatus?

    public init(
        limit: Int? = nil,
        startingAfter: String? = nil,
        endingBefore: String? = nil,
        token: StablecoinToken? = nil,
        status: WalletDepositStatus? = nil
    ) {
        self.limit = limit
        self.startingAfter = startingAfter
        self.endingBefore = endingBefore
        self.token = token
        self.status = status
    }

    func toQueryParameters() -> QueryParameters {
        var params = QueryParameters()
        params["limit"] = limit.map(String.init)
        params["starting_after"] = startingAfter
        params["ending_before"] = endingBefore
        params["token"] = token?.rawValue
        params["status"] = status?.rawValue
        return params
    }
}
