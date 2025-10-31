//
//  APIResponse.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Response structure for all API calls
public struct APIResponse<T: Codable>: Codable, Sendable where T: Sendable {
    public let data: T?
    public let error: APIError?

    internal init(data: T?, error: APIError?) {
        self.data = data
        self.error = error
    }
}

/// Error structure returned by the API
public struct APIError: Codable, Sendable {
    public let message: String
}
