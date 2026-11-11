//
//  WebhookPayloads.swift
//  blindpay-swift
//
//  Payloads of webhook events that have no matching resource model. Events
//  whose payload is a resource (customer, bank account, transfer, ...) reuse
//  that model; see ``WebhookEvent``.
//

import Foundation

/// Payload of the `payout.*` webhook events.
public struct PayoutWebhook: Codable, Sendable, Equatable {
    public let id: String
    /// Payout general status
    public let status: PayoutStatus
    /// Payout wallet address
    public let senderWalletAddress: String
    /// Billing fee in cents (charged via invoice at the end of the month)
    public let billingFeeAmount: Int?
    /// Transaction fee in cents (percentage-based fee)
    public let transactionFeeAmount: Int?
    /// Payout partner fee amount in cents (can be negative for rebates)
    public let partnerFee: Int?
    public let trackingComplete: PayoutTrackingComplete
    public let trackingPayment: PayoutTrackingPayment
    public let trackingTransaction: PayoutTrackingTransaction
    public let trackingLiquidity: PayoutTrackingLiquidity?
    public let trackingDocuments: PayoutTrackingDocuments?
    public let customerId: String?
    public let bankAccountId: String?
    public let offrampWalletId: String?
    /// The payable this payout executes, when it pays a payable instead of a bank account.
    public let payableId: String?

    public init(
        id: String,
        status: PayoutStatus,
        senderWalletAddress: String,
        billingFeeAmount: Int? = nil,
        transactionFeeAmount: Int? = nil,
        partnerFee: Int? = nil,
        trackingComplete: PayoutTrackingComplete,
        trackingPayment: PayoutTrackingPayment,
        trackingTransaction: PayoutTrackingTransaction,
        trackingLiquidity: PayoutTrackingLiquidity? = nil,
        trackingDocuments: PayoutTrackingDocuments? = nil,
        customerId: String? = nil,
        bankAccountId: String? = nil,
        offrampWalletId: String? = nil,
        payableId: String? = nil
    ) {
        self.id = id
        self.status = status
        self.senderWalletAddress = senderWalletAddress
        self.billingFeeAmount = billingFeeAmount
        self.transactionFeeAmount = transactionFeeAmount
        self.partnerFee = partnerFee
        self.trackingComplete = trackingComplete
        self.trackingPayment = trackingPayment
        self.trackingTransaction = trackingTransaction
        self.trackingLiquidity = trackingLiquidity
        self.trackingDocuments = trackingDocuments
        self.customerId = customerId
        self.bankAccountId = bankAccountId
        self.offrampWalletId = offrampWalletId
        self.payableId = payableId
    }

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case senderWalletAddress = "sender_wallet_address"
        case billingFeeAmount = "billing_fee_amount"
        case transactionFeeAmount = "transaction_fee_amount"
        case partnerFee = "partner_fee"
        case trackingComplete = "tracking_complete"
        case trackingPayment = "tracking_payment"
        case trackingTransaction = "tracking_transaction"
        case trackingLiquidity = "tracking_liquidity"
        case trackingDocuments = "tracking_documents"
        case customerId = "customer_id"
        case bankAccountId = "bank_account_id"
        case offrampWalletId = "offramp_wallet_id"
        case payableId = "payable_id"
    }
}

/// Payload of the `payin.*` webhook events.
public struct PayinWebhook: Codable, Sendable, Equatable {
    public let id: String
    /// Payin general status
    public let status: PayinStatus
    /// PIX code
    public let pixCode: String?
    /// Memo code
    public let memoCode: String?
    /// CLABE code
    public let clabe: String?
    /// Payin partner fee amount in cents
    public let partnerFee: Int?
    public let trackingComplete: PayinTrackingComplete
    public let trackingPayment: PayinTrackingPayment
    public let trackingTransaction: PayinTrackingTransaction
    /// BlindPay fee in cents accrued to your billing cycle (charged at the end of the month). Virtual account deposits below $100.00 always accrue here, so small deposits are delivered in full.
    public let billingFeeAmount: Int?
    /// BlindPay fee in cents deducted from the transaction at the time it is processed. Virtual account deposits of $100.00 or more are charged here (unless your instance is configured for end-of-month billing, in which case every fee accrues to billing_fee_amount).
    public let transactionFeeAmount: Int?
    public let blindpayBankDetails: BlindPayBankDetails
    public let customerId: String?
    /// 10.10 USDC
    public let receiverAmount: Int?
    public let paymentMethod: PaymentMethod?
    /// 52.40 BRL needs to be sent in a pix transfer
    public let senderAmount: Int?

    public init(
        id: String,
        status: PayinStatus,
        pixCode: String? = nil,
        memoCode: String? = nil,
        clabe: String? = nil,
        partnerFee: Int? = nil,
        trackingComplete: PayinTrackingComplete,
        trackingPayment: PayinTrackingPayment,
        trackingTransaction: PayinTrackingTransaction,
        billingFeeAmount: Int? = nil,
        transactionFeeAmount: Int? = nil,
        blindpayBankDetails: BlindPayBankDetails,
        customerId: String? = nil,
        receiverAmount: Int? = nil,
        paymentMethod: PaymentMethod? = nil,
        senderAmount: Int? = nil
    ) {
        self.id = id
        self.status = status
        self.pixCode = pixCode
        self.memoCode = memoCode
        self.clabe = clabe
        self.partnerFee = partnerFee
        self.trackingComplete = trackingComplete
        self.trackingPayment = trackingPayment
        self.trackingTransaction = trackingTransaction
        self.billingFeeAmount = billingFeeAmount
        self.transactionFeeAmount = transactionFeeAmount
        self.blindpayBankDetails = blindpayBankDetails
        self.customerId = customerId
        self.receiverAmount = receiverAmount
        self.paymentMethod = paymentMethod
        self.senderAmount = senderAmount
    }

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case pixCode = "pix_code"
        case memoCode = "memo_code"
        case clabe
        case partnerFee = "partner_fee"
        case trackingComplete = "tracking_complete"
        case trackingPayment = "tracking_payment"
        case trackingTransaction = "tracking_transaction"
        case billingFeeAmount = "billing_fee_amount"
        case transactionFeeAmount = "transaction_fee_amount"
        case blindpayBankDetails = "blindpay_bank_details"
        case customerId = "customer_id"
        case receiverAmount = "receiver_amount"
        case paymentMethod = "payment_method"
        case senderAmount = "sender_amount"
    }
}

/// Payload of the `customer.delete` webhook event.
public struct CustomerDeleteWebhook: Codable, Sendable, Equatable {
    public let id: String
    public let customerId: String
    public let instanceId: String
    public let type: CustomerType
    /// Use standard for individuals and businesses, or enhanced for individuals. light is not available for new customers, and businesses only support standard.
    public let kycType: KYCType
    public let kycStatus: KYCStatus
    public let deletedAt: String

    public init(
        id: String,
        customerId: String,
        instanceId: String,
        type: CustomerType,
        kycType: KYCType,
        kycStatus: KYCStatus,
        deletedAt: String
    ) {
        self.id = id
        self.customerId = customerId
        self.instanceId = instanceId
        self.type = type
        self.kycType = kycType
        self.kycStatus = kycStatus
        self.deletedAt = deletedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case customerId = "customer_id"
        case instanceId = "instance_id"
        case type
        case kycType = "kyc_type"
        case kycStatus = "kyc_status"
        case deletedAt = "deleted_at"
    }
}

/// WalletInboundToken.
public struct WalletInboundToken: Codable, Sendable, Equatable {
    public let address: String
    public let id: String
    public let symbol: StablecoinToken
    public let amount: Double

    public init(
        address: String,
        id: String,
        symbol: StablecoinToken,
        amount: Double
    ) {
        self.address = address
        self.id = id
        self.symbol = symbol
        self.amount = amount
    }

    enum CodingKeys: String, CodingKey {
        case address
        case id
        case symbol
        case amount
    }
}

/// Payload of the `wallet.inbound` webhook event (a deposit reached a managed wallet).
public struct WalletInboundWebhook: Codable, Sendable, Equatable {
    public let id: String
    public let address: String
    public let network: Network
    public let token: WalletInboundToken
    /// Matches the id returned by the wallet deposits list
    public let depositId: String
    public let transactionHash: String

    public init(
        id: String,
        address: String,
        network: Network,
        token: WalletInboundToken,
        depositId: String,
        transactionHash: String
    ) {
        self.id = id
        self.address = address
        self.network = network
        self.token = token
        self.depositId = depositId
        self.transactionHash = transactionHash
    }

    enum CodingKeys: String, CodingKey {
        case id
        case address
        case network
        case token
        case depositId = "deposit_id"
        case transactionHash = "transaction_hash"
    }
}

/// Payload of the `tos.accept` webhook event.
public struct TosAcceptWebhook: Codable, Sendable, Equatable {
    public let tosId: String
    public let idempotencyKey: String
    public let customerId: String?
    public let version: String?

    public init(
        tosId: String,
        idempotencyKey: String,
        customerId: String? = nil,
        version: String? = nil
    ) {
        self.tosId = tosId
        self.idempotencyKey = idempotencyKey
        self.customerId = customerId
        self.version = version
    }

    enum CodingKeys: String, CodingKey {
        case tosId = "tos_id"
        case idempotencyKey = "idempotency_key"
        case customerId = "customer_id"
        case version
    }
}

