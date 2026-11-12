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

    public let completedAt: String?

    public let errorMessage: String?

    public let gasFee: String?

    public let transactionHash: String?

    public init(step: String, completedAt: String? = nil, errorMessage: String? = nil, gasFee: String? = nil, transactionHash: String? = nil) {
        self.step = step
        self.completedAt = completedAt
        self.errorMessage = errorMessage
        self.gasFee = gasFee
        self.transactionHash = transactionHash
    }
    enum CodingKeys: String, CodingKey {
        case step
        case completedAt = "completed_at"
        case errorMessage = "error_message"
        case gasFee = "gas_fee"
        case transactionHash = "transaction_hash"
    }
}

/// Transaction monitoring tracking for transfers
public struct TransferTrackingTransactionMonitoring: Codable, Sendable, Equatable {
    /// Step name
    public let step: String

    /// Transaction hash
    public let transactionHash: String?

    /// Sender wallet address
    public let senderWalletAddress: String?

    public init(step: String, transactionHash: String? = nil, senderWalletAddress: String? = nil) {
        self.step = step
        self.transactionHash = transactionHash
        self.senderWalletAddress = senderWalletAddress
    }

    enum CodingKeys: String, CodingKey {
        case step
        case transactionHash = "transaction_hash"
        case senderWalletAddress = "sender_wallet_address"
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
    public let senderAmount: Int?

    /// Receiver amount
    public let receiverAmount: Int?

    /// Customer network
    public let customerNetwork: String?

    /// Customer token
    public let customerToken: String?

    /// Customer wallet address
    public let customerWalletAddress: String?

    /// Timestamp when the transfer was created
    public let createdAt: String?

    /// Timestamp when the transfer was last updated
    public let updatedAt: String?

    /// External identifier
    public let externalId: String?

    /// Customer ID
    public let customerId: String?

    /// Address
    public let address: String?

    /// Network
    public let network: String?

    /// Partner fee amount
    public let partnerFeeAmount: Int?

    /// Image URL
    public let imageUrl: String?

    /// First name
    public let firstName: String?

    /// Last name
    public let lastName: String?

    /// Legal name
    public let legalName: String?

    public let partnerFlatFee: Int?

    public let partnerPercentageFee: Int?

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
        senderAmount: Int? = nil,
        receiverAmount: Int? = nil,
        customerNetwork: String? = nil,
        customerToken: String? = nil,
        customerWalletAddress: String? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        externalId: String? = nil,
        customerId: String? = nil,
        address: String? = nil,
        network: String? = nil,
        partnerFeeAmount: Int? = nil,
        imageUrl: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        legalName: String? = nil,
        partnerFlatFee: Int? = nil,
        partnerPercentageFee: Int? = nil
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
        self.customerNetwork = customerNetwork
        self.customerToken = customerToken
        self.customerWalletAddress = customerWalletAddress
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.externalId = externalId
        self.customerId = customerId
        self.address = address
        self.network = network
        self.partnerFeeAmount = partnerFeeAmount
        self.imageUrl = imageUrl
        self.firstName = firstName
        self.lastName = lastName
        self.legalName = legalName
        self.partnerFlatFee = partnerFlatFee
        self.partnerPercentageFee = partnerPercentageFee
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
        case customerNetwork = "customer_network"
        case customerToken = "customer_token"
        case customerWalletAddress = "customer_wallet_address"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case externalId = "external_id"
        case customerId = "customer_id"
        case address
        case network
        case partnerFeeAmount = "partner_fee_amount"
        case imageUrl = "image_url"
        case firstName = "first_name"
        case lastName = "last_name"
        case legalName = "legal_name"
        case partnerFlatFee = "partner_flat_fee"
        case partnerPercentageFee = "partner_percentage_fee"
    }
}

// MARK: - Response Types

/// Response type for a single transfer
public typealias TransferResponse = Transfer

/// Response type for listing transfers (always paginated).
public typealias ListTransfersResponse = ListResult<Transfer>

// MARK: - Input Types

/// Input for creating a transfer quote.
///
/// A swap between different tokens (`senderToken` differs from
/// `customerToken`) needs at least 100 USDC, measured on the USDC side;
/// smaller amounts fail with 400 ``ErrorCode/transfersSwapAmountBelowMinimum``.
public struct CreateTransferQuoteInput: Codable, Sendable {
    /// Wallet ID to send from
    public let walletId: String

    /// Sender token
    public let senderToken: StablecoinToken

    /// Customer wallet address
    public let customerWalletAddress: String

    /// Customer token
    public let customerToken: StablecoinToken

    /// Customer network
    public let customerNetwork: Network

    /// Amount in integer cents (`1999` = 19.99). Convert with ``Amount/cents(fromMajorUnits:)``.
    public let requestAmount: Int

    /// Whether to cover fees
    public let coverFees: Bool?

    /// Amount reference (sender or receiver)
    public let amountReference: String

    /// Partner fee ID (optional)
    public let partnerFeeId: String?

    public let partnerFlatFee: Int?

    public let partnerPercentageFee: Int?

    public init(
        walletId: String,
        senderToken: StablecoinToken,
        customerWalletAddress: String,
        customerToken: StablecoinToken,
        customerNetwork: Network,
        requestAmount: Int,
        coverFees: Bool? = nil,
        amountReference: String,
        partnerFeeId: String? = nil,
        partnerFlatFee: Int? = nil,
        partnerPercentageFee: Int? = nil
    ) {
        self.walletId = walletId
        self.senderToken = senderToken
        self.customerWalletAddress = customerWalletAddress
        self.customerToken = customerToken
        self.customerNetwork = customerNetwork
        self.requestAmount = requestAmount
        self.coverFees = coverFees
        self.amountReference = amountReference
        self.partnerFeeId = partnerFeeId
        self.partnerFlatFee = partnerFlatFee
        self.partnerPercentageFee = partnerPercentageFee
    }

    enum CodingKeys: String, CodingKey {
        case walletId = "wallet_id"
        case senderToken = "sender_token"
        case customerWalletAddress = "customer_wallet_address"
        case customerToken = "customer_token"
        case customerNetwork = "customer_network"
        case requestAmount = "request_amount"
        case coverFees = "cover_fees"
        case amountReference = "amount_reference"
        case partnerFeeId = "partner_fee_id"
        case partnerFlatFee = "partner_flat_fee"
        case partnerPercentageFee = "partner_percentage_fee"
    }
}

/// Response for creating a transfer quote
public struct CreateTransferQuoteResponse: Codable, Sendable, Equatable {
    /// Quote ID
    public let id: String

    /// Expiration timestamp
    public let expiresAt: Double?

    /// Commercial quotation rate
    public let commercialQuotation: Double?

    /// BlindPay quotation rate
    public let blindpayQuotation: Double?

    /// Receiver amount
    public let receiverAmount: Int

    /// Sender amount
    public let senderAmount: Int

    /// Partner fee amount
    public let partnerFeeAmount: Int?

    /// Flat fee
    public let flatFee: Double?

    public let partnerFlatFee: Int?

    public let partnerPercentageFee: Int?

    public init(
        id: String,
        expiresAt: Double? = nil,
        commercialQuotation: Double? = nil,
        blindpayQuotation: Double? = nil,
        receiverAmount: Int,
        senderAmount: Int,
        partnerFeeAmount: Int? = nil,
        flatFee: Double? = nil,
        partnerFlatFee: Int? = nil,
        partnerPercentageFee: Int? = nil
    ) {
        self.id = id
        self.expiresAt = expiresAt
        self.commercialQuotation = commercialQuotation
        self.blindpayQuotation = blindpayQuotation
        self.receiverAmount = receiverAmount
        self.senderAmount = senderAmount
        self.partnerFeeAmount = partnerFeeAmount
        self.flatFee = flatFee
        self.partnerFlatFee = partnerFlatFee
        self.partnerPercentageFee = partnerPercentageFee
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
        case partnerFlatFee = "partner_flat_fee"
        case partnerPercentageFee = "partner_percentage_fee"
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

/// Filters and cursors for listing transfers. Every value is optional; unset ones are not sent.
public struct ListTransfersInput: CursorPaginatedInput {
    /// Page size (10, 50, 100, 200, 500 or 1000).
    public var limit: Int?

    /// Return items after this id (the previous page's `pagination.nextPage`).
    public var startingAfter: String?

    /// Return items before this id.
    public var endingBefore: String?

    /// Only this customer.
    public var customerId: String?

    /// Only this wallet.
    public var walletId: String?

    /// Only this status.
    public var status: TransactionStatus?

    /// Only this network.
    public var network: Network?

    /// Only this token.
    public var token: StablecoinToken?

    /// Deprecated: the API ignores `offset`. Use `startingAfter`.
    @available(*, deprecated, message: "Ignored by the API; use startingAfter.")
    public var offset: Int? {
        get { legacyOffset }
        set { legacyOffset = newValue }
    }
    private var legacyOffset: Int?

    public init(
        limit: Int? = nil,
        startingAfter: String? = nil,
        endingBefore: String? = nil,
        customerId: String? = nil,
        walletId: String? = nil,
        status: TransactionStatus? = nil,
        network: Network? = nil,
        token: StablecoinToken? = nil
    ) {
        self.limit = limit
        self.startingAfter = startingAfter
        self.endingBefore = endingBefore
        self.customerId = customerId
        self.walletId = walletId
        self.status = status
        self.network = network
        self.token = token
    }

    func toQueryParameters() -> QueryParameters {
        var params = QueryParameters()
        params["limit"] = limit.map(String.init)
        params["offset"] = legacyOffset.map(String.init)
        params["starting_after"] = startingAfter
        params["ending_before"] = endingBefore
        params["customer_id"] = customerId
        params["wallet_id"] = walletId
        params["status"] = status?.rawValue
        params["network"] = network?.rawValue
        params["token"] = token?.rawValue
        return params
    }
}
