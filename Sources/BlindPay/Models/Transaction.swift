//
//  Transaction.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

// MARK: - Enums

/// Transaction status
public enum TransactionStatus: String, Codable, Sendable {
    case refunded = "refunded"
    case processing = "processing"
    case completed = "completed"
    case failed = "failed"
    case onHold = "on_hold"
}

// MARK: - Tracking Types

/// Transaction tracking information
public struct TrackingTransaction: Codable, Sendable, Equatable {
    /// Step name
    public let step: String
    
    /// Status of the step
    public let status: String
    
    /// Transaction hash
    public let transactionHash: String
    
    /// Completion timestamp
    public let completedAt: String
    
    public init(step: String, status: String, transactionHash: String, completedAt: String) {
        self.step = step
        self.status = status
        self.transactionHash = transactionHash
        self.completedAt = completedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case step
        case status
        case transactionHash = "transaction_hash"
        case completedAt = "completed_at"
    }
}

/// Payment tracking information
public struct TrackingPayment: Codable, Sendable, Equatable {
    /// Step name
    public let step: String
    
    /// Provider name
    public let providerName: String
    
    /// Provider transaction ID
    public let providerTransactionId: String
    
    /// Provider status
    public let providerStatus: String
    
    /// Estimated time of arrival
    public let estimatedTimeOfArrival: String
    
    /// Completion timestamp
    public let completedAt: String
    
    public init(
        step: String,
        providerName: String,
        providerTransactionId: String,
        providerStatus: String,
        estimatedTimeOfArrival: String,
        completedAt: String
    ) {
        self.step = step
        self.providerName = providerName
        self.providerTransactionId = providerTransactionId
        self.providerStatus = providerStatus
        self.estimatedTimeOfArrival = estimatedTimeOfArrival
        self.completedAt = completedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case step
        case providerName = "provider_name"
        case providerTransactionId = "provider_transaction_id"
        case providerStatus = "provider_status"
        case estimatedTimeOfArrival = "estimated_time_of_arrival"
        case completedAt = "completed_at"
    }
}

/// Liquidity tracking information
public struct TrackingLiquidity: Codable, Sendable, Equatable {
    /// Step name
    public let step: String
    
    /// Provider transaction ID
    public let providerTransactionId: String
    
    /// Provider status
    public let providerStatus: String
    
    /// Estimated time of arrival
    public let estimatedTimeOfArrival: String
    
    /// Completion timestamp
    public let completedAt: String
    
    public init(
        step: String,
        providerTransactionId: String,
        providerStatus: String,
        estimatedTimeOfArrival: String,
        completedAt: String
    ) {
        self.step = step
        self.providerTransactionId = providerTransactionId
        self.providerStatus = providerStatus
        self.estimatedTimeOfArrival = estimatedTimeOfArrival
        self.completedAt = completedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case step
        case providerTransactionId = "provider_transaction_id"
        case providerStatus = "provider_status"
        case estimatedTimeOfArrival = "estimated_time_of_arrival"
        case completedAt = "completed_at"
    }
}

/// Complete tracking information
public struct TrackingComplete: Codable, Sendable, Equatable {
    /// Step name
    public let step: String
    
    /// Status of the step
    public let status: String
    
    /// Transaction hash
    public let transactionHash: String
    
    /// Completion timestamp
    public let completedAt: String
    
    public init(step: String, status: String, transactionHash: String, completedAt: String) {
        self.step = step
        self.status = status
        self.transactionHash = transactionHash
        self.completedAt = completedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case step
        case status
        case transactionHash = "transaction_hash"
        case completedAt = "completed_at"
    }
}

/// Partner fee tracking information
public struct TrackingPartnerFee: Codable, Sendable, Equatable {
    /// Step name
    public let step: String
    
    /// Transaction hash
    public let transactionHash: String
    
    /// Completion timestamp
    public let completedAt: String
    
    public init(step: String, transactionHash: String, completedAt: String) {
        self.step = step
        self.transactionHash = transactionHash
        self.completedAt = completedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case step
        case transactionHash = "transaction_hash"
        case completedAt = "completed_at"
    }
}

