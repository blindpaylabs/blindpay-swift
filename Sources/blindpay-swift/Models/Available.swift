//
//  Available.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Available payment rail model
public struct Rail: Codable, Sendable {
    public let id: String
    public let name: String
    public let type: String
    public let enabled: Bool
}

