//
//  Fee.swift
//  blindpay-swift
//

import Foundation

// MARK: - Fee

/// Represents fee options for a specific rail
public struct FeeOptions: Codable, Sendable, Equatable {
    /// Flat fee for payins
    public let payinFlat: Double

    /// Percentage fee for payins
    public let payinPercentage: Double

    /// Flat fee for payouts
    public let payoutFlat: Double

    /// Percentage fee for payouts
    public let payoutPercentage: Double

    public init(payinFlat: Double, payinPercentage: Double, payoutFlat: Double, payoutPercentage: Double) {
        self.payinFlat = payinFlat
        self.payinPercentage = payinPercentage
        self.payoutFlat = payoutFlat
        self.payoutPercentage = payoutPercentage
    }

    enum CodingKeys: String, CodingKey {
        case payinFlat = "payin_flat"
        case payinPercentage = "payin_percentage"
        case payoutFlat = "payout_flat"
        case payoutPercentage = "payout_percentage"
    }
}

/// Response type for getting instance fees
public struct FeesResponse: Codable, Sendable, Equatable {
    /// Unique identifier
    public let id: String

    /// Instance ID
    public let instanceId: String

    /// ACH fees
    public let ach: FeeOptions?

    /// Domestic wire fees
    public let domesticWire: FeeOptions?

    /// RTP fees
    public let rtp: FeeOptions?

    /// International SWIFT fees
    public let internationalSwift: FeeOptions?

    /// PIX fees
    public let pix: FeeOptions?

    /// PIX Safe fees
    public let pixSafe: FeeOptions?

    /// ACH Colombia fees
    public let achColombia: FeeOptions?

    /// Argentina transfers fees
    public let transfers3: FeeOptions?

    /// SPEI fees
    public let spei: FeeOptions?

    /// Tron fees
    public let tron: FeeOptions?

    /// Ethereum fees
    public let ethereum: FeeOptions?

    /// Polygon fees
    public let polygon: FeeOptions?

    /// Base fees
    public let base: FeeOptions?

    /// Arbitrum fees
    public let arbitrum: FeeOptions?

    /// Stellar fees
    public let stellar: FeeOptions?

    /// Solana fees
    public let solana: FeeOptions?

    /// Timestamp when the fees were created
    public let createdAt: String

    /// Timestamp when the fees were last updated
    public let updatedAt: String

    public init(
        id: String,
        instanceId: String,
        ach: FeeOptions? = nil,
        domesticWire: FeeOptions? = nil,
        rtp: FeeOptions? = nil,
        internationalSwift: FeeOptions? = nil,
        pix: FeeOptions? = nil,
        pixSafe: FeeOptions? = nil,
        achColombia: FeeOptions? = nil,
        transfers3: FeeOptions? = nil,
        spei: FeeOptions? = nil,
        tron: FeeOptions? = nil,
        ethereum: FeeOptions? = nil,
        polygon: FeeOptions? = nil,
        base: FeeOptions? = nil,
        arbitrum: FeeOptions? = nil,
        stellar: FeeOptions? = nil,
        solana: FeeOptions? = nil,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.instanceId = instanceId
        self.ach = ach
        self.domesticWire = domesticWire
        self.rtp = rtp
        self.internationalSwift = internationalSwift
        self.pix = pix
        self.pixSafe = pixSafe
        self.achColombia = achColombia
        self.transfers3 = transfers3
        self.spei = spei
        self.tron = tron
        self.ethereum = ethereum
        self.polygon = polygon
        self.base = base
        self.arbitrum = arbitrum
        self.stellar = stellar
        self.solana = solana
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case instanceId = "instance_id"
        case ach
        case domesticWire = "domestic_wire"
        case rtp
        case internationalSwift = "international_swift"
        case pix
        case pixSafe = "pix_safe"
        case achColombia = "ach_colombia"
        case transfers3 = "transfers_3"
        case spei
        case tron
        case ethereum
        case polygon
        case base
        case arbitrum
        case stellar
        case solana
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
