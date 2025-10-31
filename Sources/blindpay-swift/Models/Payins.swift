//
//  Payins.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Payin model
public struct Payin: Codable, Sendable {
    public let id: String
    public let amount: Int
    public let currency: String
    public let status: String
    public let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case currency
        case status
        case createdAt = "created_at"
    }
}

