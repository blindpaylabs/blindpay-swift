//
//  RfiService.swift
//  blindpay-swift
//

import Foundation

/// The open request for information (RFI) of the instance
/// (`blindPay.instances.rfi`) or of one customer
/// (`blindPay.customers(customerId:).rfi`).
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class InstanceRfiService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String

    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }

    /// Retrieves the instance's open RFI. `data` is `nil` when none is open.
    public func get(options: RequestOptions? = nil) async throws -> APIResponse<InstanceRfi> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/rfi",
            method: .get,
            options: options
        )
    }

    /// Submits answers to the open RFI. `response` is sent as the whole JSON
    /// body, keyed by field key.
    public func submit(response: RfiResponse, options: RequestOptions? = nil) async throws -> APIResponse<RfiSubmitResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/rfi",
            method: .post,
            body: response,
            options: options
        )
    }
}

/// A customer's open request for information. See ``InstanceRfiService``.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class CustomerRfiService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    private let customerId: String

    init(apiClient: APIClient, instanceId: String, customerId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.customerId = customerId
    }

    /// Retrieves the customer's open RFI. `data` is `nil` when none is open.
    public func get(options: RequestOptions? = nil) async throws -> APIResponse<Rfi> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)/rfi",
            method: .get,
            options: options
        )
    }

    /// Submits answers to the open RFI. `response` is sent as the whole JSON
    /// body, keyed by field key.
    ///
    /// ```swift
    /// _ = try await blindPay.customers(customerId: "cu_123").rfi.submit(response: [
    ///     "occupation": "Engineer",
    ///     "proof_of_income": ["https://..."],
    /// ])
    /// ```
    public func submit(response: RfiResponse, options: RequestOptions? = nil) async throws -> APIResponse<RfiSubmitResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)/rfi",
            method: .post,
            body: response,
            options: options
        )
    }
}
