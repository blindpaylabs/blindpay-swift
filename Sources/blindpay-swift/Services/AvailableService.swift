//
//  AvailableService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Service for querying available payment rails and bank details
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class AvailableService: Sendable {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    /// Retrieves all available payment rails
    ///
    /// This method fetches a list of all payment rails that are available for use,
    /// including their display names, identifiers, and supported countries.
    ///
    /// - Returns: An `APIResponse` containing an array of `RailResponse` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.available.getRails()
    /// if let rails = response.data {
    ///     for rail in rails {
    ///         print("\(rail.label) (\(rail.value)) - \(rail.country)")
    ///     }
    /// }
    /// ```
    public func getRails() async throws -> APIResponse<[RailResponse]> {
        return try await apiClient.request(endpoint: "/v1/available/rails", method: .get)
    }
}

