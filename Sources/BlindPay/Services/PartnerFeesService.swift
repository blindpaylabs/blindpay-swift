//
//  PartnerFeesService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 31/10/25.
//

import Foundation

/// Service for managing partner fees
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class PartnerFeesService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }
    
    /// Lists all partner fees for the instance
    ///
    /// This method fetches a list of all partner fees associated with the instance.
    ///
    /// - Returns: An `APIResponse` containing an array of `PartnerFee` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.partnerFees.list()
    /// if let fees = response.data {
    ///     for fee in fees {
    ///         print("\(fee.name): \(fee.payoutPercentageFee)% + \(fee.payoutFlatFee) flat")
    ///     }
    /// }
    /// ```
    public func list() async throws -> APIResponse<PartnerFeesResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/partner-fees",
            method: .get
        )
    }
    
    /// Creates a new partner fee for the instance
    ///
    /// This method creates a new partner fee with the specified configuration.
    ///
    /// - Parameter data: The input data containing fee configuration
    /// - Returns: An `APIResponse` containing the created partner fee
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreatePartnerFeeInput(
    ///     evmWalletAddress: "0x123...",
    ///     name: "My Partner Fee",
    ///     payinFlatFee: 10,
    ///     payinPercentageFee: 1,
    ///     payoutFlatFee: 5,
    ///     payoutPercentageFee: 0.5
    /// )
    /// let response = try await blindPay.instances.partnerFees.create(data: input)
    /// if let created = response.data {
    ///     print("Created fee: \(created.id)")
    /// }
    /// ```
    public func create(data: CreatePartnerFeeInput) async throws -> APIResponse<CreatePartnerFeeResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/partner-fees",
            method: .post,
            body: data
        )
    }
    
    /// Retrieves a specific partner fee by ID
    ///
    /// This method fetches the details of a specific partner fee.
    ///
    /// - Parameter id: The unique identifier of the partner fee
    /// - Returns: An `APIResponse` containing the `PartnerFee` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.partnerFees.get(id: "pf_123")
    /// if let fee = response.data {
    ///     print("Fee: \(fee.name)")
    /// }
    /// ```
    public func get(id: String) async throws -> APIResponse<PartnerFee> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/partner-fees/\(id)",
            method: .get
        )
    }
    
    /// Deletes a partner fee
    ///
    /// This method permanently deletes a partner fee. This action cannot be undone.
    ///
    /// - Parameter id: The unique identifier of the partner fee to delete
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.partnerFees.delete(id: "pf_123")
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Partner fee deleted successfully")
    /// }
    /// ```
    public func delete(id: String) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/partner-fees/\(id)",
            method: .delete
        )
    }
}

