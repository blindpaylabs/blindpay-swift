//
//  CustomersService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// One customer: the customer itself, its limits and RFI, and its
/// sub-resources. Get one with ``BlindPay/customers(customerId:)``.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class CustomersService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    private let customerId: String
    
    /// Blockchain wallets management service
    public let blockchainWallets: BlockchainWalletsService

    /// Virtual accounts management service
    public let virtualAccounts: VirtualAccountsService

    /// Bank accounts management service
    public let bankAccounts: BankAccountsService

    /// Custodial wallets management service
    public let custodialWallets: CustodialWalletsService

    /// The customer's open request for information
    public let rfi: CustomerRfiService

    init(apiClient: APIClient, instanceId: String, customerId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.customerId = customerId
        self.blockchainWallets = BlockchainWalletsService(apiClient: apiClient, instanceId: instanceId, customerId: customerId)
        self.virtualAccounts = VirtualAccountsService(apiClient: apiClient, instanceId: instanceId, customerId: customerId)
        self.bankAccounts = BankAccountsService(apiClient: apiClient, instanceId: instanceId, customerId: customerId)
        self.custodialWallets = CustodialWalletsService(apiClient: apiClient, instanceId: instanceId, customerId: customerId)
        self.rfi = CustomerRfiService(apiClient: apiClient, instanceId: instanceId, customerId: customerId)
    }

    /// Retrieves the customer.
    public func get(options: RequestOptions? = nil) async throws -> APIResponse<Customer> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)",
            method: .get,
            options: options
        )
    }

    /// Updates the customer.
    public func update(data: UpdateCustomerInput, options: RequestOptions? = nil) async throws -> APIResponse<UpdateCustomerResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)",
            method: .put,
            body: data,
            options: options
        )
    }

    /// Deletes the customer.
    public func delete(options: RequestOptions? = nil) async throws -> APIResponse<DeleteCustomerResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)",
            method: .delete,
            options: options
        )
    }

    /// Retrieves the customer's payin and payout limits (amounts in cents).
    public func getLimits(options: RequestOptions? = nil) async throws -> APIResponse<CustomerLimitsResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/limits/customers/\(customerId)",
            method: .get,
            options: options
        )
    }

    /// Requests higher limits for the customer (amounts in cents).
    public func requestLimitIncrease(data: RequestLimitIncreaseInput, options: RequestOptions? = nil) async throws -> APIResponse<RequestLimitIncreaseResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)/limit-increase",
            method: .post,
            body: data,
            options: options
        )
    }

    /// Lists the customer's limit increase requests.
    public func listLimitIncreases(options: RequestOptions? = nil) async throws -> APIResponse<[LimitIncreaseRequest]> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/customers/\(customerId)/limit-increase",
            method: .get,
            options: options
        )
    }
}

