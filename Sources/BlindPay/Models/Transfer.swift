//
//  Transfer.swift
//  blindpay-swift
//
//  Created by Eric Viana on 09/04/26.
//

import Foundation

// MARK: - Transfer Tracking

/// Tracking step for a transfer
public struct TransferTrackingStep: Codable, Sendable, Equatable {
    /// Step name
    public let step: String

    /// Transaction hash
    public let transactionHash: String?

    /// Gas fee
    public let gasFee: String?

    /// Timestamp when this step completed
    public let completedAt: String?

    /// Error message if step failed
    public let errorMessage: String?

    public init(step: String, transactionHash: String? = nil, gasFee: String? = nil, completedAt: String? = nil, errorMessage: String? = nil) {
        self.step = step
        self.transactionHash = transactionHash
        self.gasFee = gasFee
        self.completedAt = completedAt
        self.errorMessage = errorMessage
    }

    enum CodingKeys: String, CodingKey {
        case step
        case transactionHash = "transaction_hash"
        case gasFee = "gas_fee"
        case completedAt = "completed_at"
        case errorMessage = "error_message"
    }
}

/// Transaction monitoring tracking for transfers
public struct TransferTrackingTransactionMonitoring: Codable, Sendable, Equatable {
    /// Step name
    public let step: String

    /// Blockchain screening score (0-100)
    public let blockchainScreening: Double?

    /// Risk score (0-100)
    public let riskScore: Double?

    /// Timestamp when monitoring completed
    public let completedAt: String?

    public init(step: String, blockchainScreening: Double? = nil, riskScore: Double? = nil, completedAt: String? = nil) {
        self.step = step
        self.blockchainScreening = blockchainScreening
        self.riskScore = riskScore
        self.completedAt = completedAt
    }

    enum CodingKeys: String, CodingKey {
        case step
        case blockchainScreening = "blockchain_screening"
        case riskScore = "risk_score"
        case completedAt = "completed_at"
    }
}

// MARK: - Transfer

/// Represents a transfer
public struct Transfer: Codable, Sendable, Equatable {
    /// Unique identifier for the transfer
    public let id: String

    /// Transfer status
    public let status: TransactionStatus

    /// Transfer quote ID
    public let transferQuoteId: String?

    /// Instance ID
    public let instanceId: String?

    /// Transaction monitoring tracking
    public let trackingTransactionMonitoring: TransferTrackingTransactionMonitoring?

    /// Paymaster tracking
    public let trackingPaymaster: TransferTrackingStep?

    /// Bridge/swap tracking
    public let trackingBridgeSwap: TransferTrackingStep?

    /// Complete tracking
    public let trackingComplete: TransferTrackingStep?

    /// Partner fee tracking
    public let trackingPartnerFee: TransferTrackingStep?

    /// Wallet ID
    public let walletId: String?

    /// Sender token
    public let senderToken: String?

    /// Sender amount
    public let senderAmount: Double?

    /// Receiver amount
    public let receiverAmount: Double?

    /// Receiver network
    public let receiverNetwork: String?

    /// Receiver token
    public let receiverToken: String?

    /// Receiver wallet address
    public let receiverWalletAddress: String?

    /// Partner fee amount
    public let partnerFeeAmount: Double?

    /// External ID for your own reference
    public let externalId: String?

    /// Receiver ID
    public let receiverId: String?

    /// Sender wallet address
    public let address: String?

    /// Sender blockchain network
    public let network: String?

    /// Receiver first name
    public let firstName: String?

    /// Receiver last name
    public let lastName: String?

    /// Receiver legal name
    public let legalName: String?

    /// Receiver image URL
    public let imageUrl: String?

    /// Timestamp when the transfer was created
    public let createdAt: String?

    /// Timestamp when the transfer was last updated
    public let updatedAt: String?

    public init(
        id: String,
        status: TransactionStatus,
        transferQuoteId: String? = nil,
        instanceId: String? = nil,
        trackingTransactionMonitoring: TransferTrackingTransactionMonitoring? = nil,
        trackingPaymaster: TransferTrackingStep? = nil,
        trackingBridgeSwap: TransferTrackingStep? = nil,
        trackingComplete: TransferTrackingStep? = nil,
        trackingPartnerFee: TransferTrackingStep? = nil,
        walletId: String? = nil,
        senderToken: String? = nil,
        senderAmount: Double? = nil,
        receiverAmount: Double? = nil,
        receiverNetwork: String? = nil,
        receiverToken: String? = nil,
        receiverWalletAddress: String? = nil,
        partnerFeeAmount: Double? = nil,
        externalId: String? = nil,
        receiverId: String? = nil,
        address: String? = nil,
        network: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        legalName: String? = nil,
        imageUrl: String? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil
    ) {
        self.id = id
        self.status = status
        self.transferQuoteId = transferQuoteId
        self.instanceId = instanceId
        self.trackingTransactionMonitoring = trackingTransactionMonitoring
        self.trackingPaymaster = trackingPaymaster
        self.trackingBridgeSwap = trackingBridgeSwap
        self.trackingComplete = trackingComplete
        self.trackingPartnerFee = trackingPartnerFee
        self.walletId = walletId
        self.senderToken = senderToken
        self.senderAmount = senderAmount
        self.receiverAmount = receiverAmount
        self.receiverNetwork = receiverNetwork
        self.receiverToken = receiverToken
        self.receiverWalletAddress = receiverWalletAddress
        self.partnerFeeAmount = partnerFeeAmount
        self.externalId = externalId
        self.receiverId = receiverId
        self.address = address
        self.network = network
        self.firstName = firstName
        self.lastName = lastName
        self.legalName = legalName
        self.imageUrl = imageUrl
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case transferQuoteId = "transfer_quote_id"
        case instanceId = "instance_id"
        case trackingTransactionMonitoring = "tracking_transaction_monitoring"
        case trackingPaymaster = "tracking_paymaster"
        case trackingBridgeSwap = "tracking_bridge_swap"
        case trackingComplete = "tracking_complete"
        case trackingPartnerFee = "tracking_partner_fee"
        case walletId = "wallet_id"
        case senderToken = "sender_token"
        case senderAmount = "sender_amount"
        case receiverAmount = "receiver_amount"
        case receiverNetwork = "receiver_network"
        case receiverToken = "receiver_token"
        case receiverWalletAddress = "receiver_wallet_address"
        case partnerFeeAmount = "partner_fee_amount"
        case externalId = "external_id"
        case receiverId = "receiver_id"
        case address
        case network
        case firstName = "first_name"
        case lastName = "last_name"
        case legalName = "legal_name"
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Response Types

/// Response type for a single transfer
public typealias TransferResponse = Transfer

/// Response type for listing transfers
public struct ListTransfersResponse: Codable, Sendable, Equatable {
    /// Array of transfers
    public let data: [Transfer]

    /// Pagination metadata
    public let pagination: PaginationMetadata

    public init(data: [Transfer], pagination: PaginationMetadata) {
        self.data = data
        self.pagination = pagination
    }
}

// MARK: - Input Types

/// Input for creating a transfer quote
public struct CreateTransferQuoteInput: Codable, Sendable {
    /// Wallet ID to send from
    public let walletId: String

    /// Sender token
    public let senderToken: StablecoinToken

    /// Receiver wallet address
    public let receiverWalletAddress: String

    /// Receiver token
    public let receiverToken: StablecoinToken

    /// Receiver network
    public let receiverNetwork: Network

    /// Request amount
    public let requestAmount: Double

    /// Whether to cover fees
    public let coverFees: Bool?

    /// Amount reference (sender or receiver)
    public let amountReference: String

    /// Optional partner fee ID
    public let partnerFeeId: String?

    public init(
        walletId: String,
        senderToken: StablecoinToken,
        receiverWalletAddress: String,
        receiverToken: StablecoinToken,
        receiverNetwork: Network,
        requestAmount: Double,
        coverFees: Bool? = nil,
        amountReference: String,
        partnerFeeId: String? = nil
    ) {
        self.walletId = walletId
        self.senderToken = senderToken
        self.receiverWalletAddress = receiverWalletAddress
        self.receiverToken = receiverToken
        self.receiverNetwork = receiverNetwork
        self.requestAmount = requestAmount
        self.coverFees = coverFees
        self.amountReference = amountReference
        self.partnerFeeId = partnerFeeId
    }

    enum CodingKeys: String, CodingKey {
        case walletId = "wallet_id"
        case senderToken = "sender_token"
        case receiverWalletAddress = "receiver_wallet_address"
        case receiverToken = "receiver_token"
        case receiverNetwork = "receiver_network"
        case requestAmount = "request_amount"
        case coverFees = "cover_fees"
        case amountReference = "amount_reference"
        case partnerFeeId = "partner_fee_id"
    }
}

/// Response for creating a transfer quote
public struct CreateTransferQuoteResponse: Codable, Sendable, Equatable {
    /// Quote ID
    public let id: String

    /// Expiration timestamp
    public let expiresAt: Double

    /// Commercial quotation rate
    public let commercialQuotation: Double?

    /// BlindPay quotation rate
    public let blindpayQuotation: Double?

    /// Receiver amount
    public let receiverAmount: Double

    /// Sender amount
    public let senderAmount: Double

    /// Partner fee amount
    public let partnerFeeAmount: Double?

    /// Flat fee
    public let flatFee: Double?

    public init(
        id: String,
        expiresAt: Double,
        commercialQuotation: Double? = nil,
        blindpayQuotation: Double? = nil,
        receiverAmount: Double,
        senderAmount: Double,
        partnerFeeAmount: Double? = nil,
        flatFee: Double? = nil
    ) {
        self.id = id
        self.expiresAt = expiresAt
        self.commercialQuotation = commercialQuotation
        self.blindpayQuotation = blindpayQuotation
        self.receiverAmount = receiverAmount
        self.senderAmount = senderAmount
        self.partnerFeeAmount = partnerFeeAmount
        self.flatFee = flatFee
    }

    enum CodingKeys: String, CodingKey {
        case id
        case expiresAt = "expires_at"
        case commercialQuotation = "commercial_quotation"
        case blindpayQuotation = "blindpay_quotation"
        case receiverAmount = "receiver_amount"
        case senderAmount = "sender_amount"
        case partnerFeeAmount = "partner_fee_amount"
        case flatFee = "flat_fee"
    }
}

/// Input for creating a transfer
public struct CreateTransferInput: Codable, Sendable {
    /// Transfer quote ID
    public let transferQuoteId: String

    public init(transferQuoteId: String) {
        self.transferQuoteId = transferQuoteId
    }

    enum CodingKeys: String, CodingKey {
        case transferQuoteId = "transfer_quote_id"
    }
}

/// Response for creating a transfer
public typealias CreateTransferResponse = Transfer

/// Input for listing transfers
public struct ListTransfersInput: Sendable {
    /// Number of items per page
    public let limit: String?

    /// Offset for pagination
    public let offset: String?

    /// Cursor for pagination (starting after this ID)
    public let startingAfter: String?

    /// Cursor for pagination (ending before this ID)
    public let endingBefore: String?

    public init(
        limit: String? = nil,
        offset: String? = nil,
        startingAfter: String? = nil,
        endingBefore: String? = nil
    ) {
        self.limit = limit
        self.offset = offset
        self.startingAfter = startingAfter
        self.endingBefore = endingBefore
    }

    func toQueryParameters() -> [String: String] {
        var params: [String: String] = [:]
        if let limit = limit { params["limit"] = limit }
        if let offset = offset { params["offset"] = offset }
        if let startingAfter = startingAfter { params["starting_after"] = startingAfter }
        if let endingBefore = endingBefore { params["ending_before"] = endingBefore }
        return params
    }
}
