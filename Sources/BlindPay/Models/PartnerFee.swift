//
//  PartnerFee.swift
//  blindpay-swift
//
//  Created by Eric Viana on 31/10/25.
//

import Foundation

/// Represents a partner fee
public struct PartnerFee: Codable, Sendable, Equatable {
    /// Unique identifier for the partner fee
    public let id: String
    
    /// Instance ID this fee belongs to
    public let instanceId: String
    
    /// Name or description of the partner fee
    public let name: String
    
    /// Payout percentage fee
    public let payoutPercentageFee: Int
    
    /// Payout flat fee
    public let payoutFlatFee: Int
    
    /// Payin percentage fee
    public let payinPercentageFee: Int
    
    /// Payin flat fee
    public let payinFlatFee: Int
    
    
    
    /// Whether virtual account is set (optional, may not be present in get response)
    public let virtualAccountSet: Bool?
    
    /// Timestamp when the fee was created (optional, may not be present in get response)
    public let createdAt: String?
    
    /// Timestamp when the fee was last updated (optional, may not be present in get response)
    public let updatedAt: String?
    
    public init(
        id: String,
        instanceId: String,
        name: String,
        payoutPercentageFee: Int,
        payoutFlatFee: Int,
        payinPercentageFee: Int,
        payinFlatFee: Int,
        virtualAccountSet: Bool? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil
    ) {
        self.id = id
        self.instanceId = instanceId
        self.name = name
        self.payoutPercentageFee = payoutPercentageFee
        self.payoutFlatFee = payoutFlatFee
        self.payinPercentageFee = payinPercentageFee
        self.payinFlatFee = payinFlatFee
        self.virtualAccountSet = virtualAccountSet
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case instanceId = "instance_id"
        case name
        case payoutPercentageFee = "payout_percentage_fee"
        case payoutFlatFee = "payout_flat_fee"
        case payinPercentageFee = "payin_percentage_fee"
        case payinFlatFee = "payin_flat_fee"
        case virtualAccountSet = "virtual_account_set"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

/// Response type for listing partner fees
public typealias PartnerFeesResponse = [PartnerFee]

/// Input for creating a new partner fee
public struct CreatePartnerFeeInput: Codable, Sendable {
    /// Whether virtual account is set
    public let virtualAccountSet: Bool?
    
    
    /// Name or description of the partner fee
    public let name: String
    
    /// Payin flat fee
    public let payinFlatFee: Int
    
    /// Payin percentage fee
    public let payinPercentageFee: Int
    
    /// Payout flat fee
    public let payoutFlatFee: Int
    
    /// Payout percentage fee
    public let payoutPercentageFee: Int
    
    
    public init(
        name: String,
        payinFlatFee: Int,
        payinPercentageFee: Int,
        payoutFlatFee: Int,
        payoutPercentageFee: Int,
        virtualAccountSet: Bool? = nil
    ) {
        self.name = name
        self.payinFlatFee = payinFlatFee
        self.payinPercentageFee = payinPercentageFee
        self.payoutFlatFee = payoutFlatFee
        self.payoutPercentageFee = payoutPercentageFee
        self.virtualAccountSet = virtualAccountSet
    }
    
    enum CodingKeys: String, CodingKey {
        case virtualAccountSet = "virtual_account_set"
        case name
        case payinFlatFee = "payin_flat_fee"
        case payinPercentageFee = "payin_percentage_fee"
        case payoutFlatFee = "payout_flat_fee"
        case payoutPercentageFee = "payout_percentage_fee"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(payinFlatFee, forKey: .payinFlatFee)
        try container.encode(payinPercentageFee, forKey: .payinPercentageFee)
        try container.encode(payoutFlatFee, forKey: .payoutFlatFee)
        try container.encode(payoutPercentageFee, forKey: .payoutPercentageFee)
        if let virtualAccountSet = virtualAccountSet {
            try container.encode(virtualAccountSet, forKey: .virtualAccountSet)
        }
    }
}

/// Response type for creating a partner fee
public struct CreatePartnerFeeResponse: Codable, Sendable {
    /// Unique identifier for the created partner fee
    public let id: String
    
    /// Instance ID this fee belongs to
    public let instanceId: String
    
    /// Name or description of the partner fee
    public let name: String
    
    /// Payout percentage fee
    public let payoutPercentageFee: Int
    
    /// Payout flat fee
    public let payoutFlatFee: Int
    
    /// Payin percentage fee
    public let payinPercentageFee: Int
    
    /// Payin flat fee
    public let payinFlatFee: Int
    
    
    
    public init(
        id: String,
        instanceId: String,
        name: String,
        payoutPercentageFee: Int,
        payoutFlatFee: Int,
        payinPercentageFee: Int,
        payinFlatFee: Int
    ) {
        self.id = id
        self.instanceId = instanceId
        self.name = name
        self.payoutPercentageFee = payoutPercentageFee
        self.payoutFlatFee = payoutFlatFee
        self.payinPercentageFee = payinPercentageFee
        self.payinFlatFee = payinFlatFee
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case instanceId = "instance_id"
        case name
        case payoutPercentageFee = "payout_percentage_fee"
        case payoutFlatFee = "payout_flat_fee"
        case payinPercentageFee = "payin_percentage_fee"
        case payinFlatFee = "payin_flat_fee"
    }
}

