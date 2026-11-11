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
    public func getRails(options: RequestOptions? = nil) async throws -> APIResponse<[RailResponse]> {
        return try await apiClient.request(
            endpoint: "/v1/available/rails",
            method: .get,
            options: options
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
    /// let response = try await blindPay.available.getBankDetails(rail: .wire)
    /// if let fields = response.data {
    ///     for field in fields {
    ///         print("\(field.label): required=\(field.required), key=\(field.key)")
    ///         if let items = field.items {
    ///             print("  Options: \(items.map { $0.label }.joined(separator: ", "))")
    ///         }
    ///     }
    /// }
    /// ```
    public func getBankDetails(rail: Rail, options: RequestOptions? = nil) async throws -> APIResponse<BankDetailResponse> {
        return try await apiClient.request(
            endpoint: "/v1/available/bank-details",
            method: .get,
            queryParameters: ["rail": rail.rawValue],
            options: options
        )
    }

    /// Pass a ``Rail`` instead (`.pix`, or `Rail(rawValue:)` for any value).
    @available(*, deprecated, message: "Pass a Rail: getBankDetails(rail: .pix).")
    @_disfavoredOverload
    public func getBankDetails(rail: String, options: RequestOptions? = nil) async throws -> APIResponse<BankDetailResponse> {
        return try await getBankDetails(rail: Rail(rawValue: rail), options: options)
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
    public func getSwiftCode(swift: String, options: RequestOptions? = nil) async throws -> APIResponse<
        [SwiftCodeResponse]
    > {
        return try await apiClient.request(
            endpoint: "/v1/available/swift/\(swift)",
            method: .get,
            options: options
        )
    }

    /// Retrieves all available NAICS business industry codes
    ///
    /// This method fetches a list of NAICS (North American Industry Classification System)
    /// codes that can be used to classify a customer's business industry.
    ///
    /// - Returns: An `APIResponse` containing an array of `NaicsCode` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.available.getNaicsCodes()
    /// if let codes = response.data {
    ///     for code in codes {
    ///         print("\(code.value) - \(code.label)")
    ///     }
    /// }
    /// ```
    public func getNaicsCodes(options: RequestOptions? = nil) async throws -> APIResponse<[NaicsCode]> {
        return try await apiClient.request(
            endpoint: "/v1/available/naics",
            method: .get,
            options: options
        )
    }
}
