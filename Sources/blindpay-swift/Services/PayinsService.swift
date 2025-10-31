//
//  PayinsService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Service for managing pay-ins
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class PayinsService: Sendable {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    /// List all pay-ins
    /// - Returns: APIResponse containing an array of Payins or an error
    public func list() async throws -> APIResponse<[Payin]> {
        return try await apiClient.request(endpoint: "/v1/payins", method: .get)
    }
}

