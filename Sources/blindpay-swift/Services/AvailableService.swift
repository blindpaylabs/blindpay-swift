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
        return try await apiClient.request(
            endpoint: "/v1/available/rails",
            method: .get
        )
    }

    /// Retrieves bank detail fields required for a specific payment rail
    ///
    /// This method fetches the configuration and requirements for bank detail fields
    /// needed to process payments using the specified rail. Each field includes
    /// validation rules, display labels, and optional predefined values.
    ///
    /// - Parameter rail: The payment rail identifier (e.g., "wire", "ach", "pix")
    /// - Returns: An `APIResponse` containing an array of `BankDetailField` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.available.getBankDetails(rail: "wire")
    /// if let fields = response.data {
    ///     for field in fields {
    ///         print("\(field.label): required=\(field.required), key=\(field.key)")
    ///         if let items = field.items {
    ///             print("  Options: \(items.map { $0.label }.joined(separator: ", "))")
    ///         }
    ///     }
    /// }
    /// ```
    public func getBankDetails(rail: String) async throws -> APIResponse<
        BankDetailResponse
    > {
        return try await apiClient.request(
            endpoint: "/v1/available/bank-details",
            method: .get,
            queryParameters: ["rail": rail]
        )
    }

    /// Retrieves bank information for a specific SWIFT code
    ///
    /// This method fetches bank details associated with the given SWIFT/BIC code,
    /// including bank name, address, city, branch, and other relevant information.
    ///
    /// - Parameter swift: The SWIFT/BIC code to look up (e.g., "CHASUS33")
    ///   Must be exactly 8 characters, containing only uppercase letters and numbers.
    /// - Returns: An `APIResponse` containing an array of `SwiftCodeResponse` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.available.getSwiftCode(swift: "CHASUS33")
    /// if let swiftCodes = response.data {
    ///     for swiftCode in swiftCodes {
    ///         print("\(swiftCode.bank) - \(swiftCode.city), \(swiftCode.country)")
    ///     }
    /// }
    /// ```
    public func getSwiftCode(swift: String) async throws -> APIResponse<
        [SwiftCodeResponse]
    > {
        return try await apiClient.request(
            endpoint: "/v1/available/swift/\(swift)",
            method: .get
        )
    }
}
