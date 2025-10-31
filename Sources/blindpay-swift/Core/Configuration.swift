//
//  Configuration.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Configuration for the BlindPay client
public struct Configuration: Sendable {
    /// Base URL for the API
    public let baseURL: String
    
    /// Default configuration
    public static let `default` = Configuration(
        baseURL: "https://api.blindpay.com"
    )
    
    /// Create a custom configuration
    /// - Parameter baseURL: Custom base URL for the API
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
}

