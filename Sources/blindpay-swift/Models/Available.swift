//
//  Available.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Represents an available payment rail
public struct RailResponse: Codable, Sendable, Equatable {
    /// Display name of the rail (e.g., "Domestic Wire")
    public let label: String
    
    /// Rail identifier (e.g., "wire", "ach", "pix")
    public let value: String
    
    /// Country code where this rail is available (e.g., "US", "BR", "MX")
    public let country: String
    
    public init(label: String, value: String, country: String) {
        self.label = label
        self.value = value
        self.country = country
    }
}

