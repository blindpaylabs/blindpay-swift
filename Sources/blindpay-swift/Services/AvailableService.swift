//
//  AvailableService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Service for querying available payment rails
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class AvailableService: Sendable {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    /// Get available payment rails
    /// - Returns: APIResponse containing an array of Rails or an error
    public func getRails() async throws -> APIResponse<[Rail]> {
        return try await apiClient.request(endpoint: "/v1/available/rails", method: .get)
    }
}

