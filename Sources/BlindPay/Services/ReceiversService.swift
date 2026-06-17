//
//  ReceiversService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Service for managing receiver resources
///
/// - Note: Deprecated since 2.10.0. Use `CustomersService` via
///   `blindPay.customers(customerId:)` instead. See
///   https://www.blindpay.com/changelog/2026-06-04-customers-rename
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@available(*, deprecated, message: "The receivers resource is deprecated and will be removed in v3.0.0; use CustomersService via blindPay.customers(customerId:) instead. See https://www.blindpay.com/changelog/2026-06-04-customers-rename")
public final class ReceiversService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    private let receiverId: String

    /// Blockchain wallets management service
    public let blockchainWallets: BlockchainWalletsService

    /// Virtual accounts management service
    public let virtualAccounts: VirtualAccountsService

    /// Bank accounts management service
    public let bankAccounts: BankAccountsService

    /// Custodial wallets management service
    public let custodialWallets: CustodialWalletsService

    init(apiClient: APIClient, instanceId: String, receiverId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.receiverId = receiverId
        self.blockchainWallets = BlockchainWalletsService(apiClient: apiClient, instanceId: instanceId, customerId: receiverId)
        self.virtualAccounts = VirtualAccountsService(apiClient: apiClient, instanceId: instanceId, customerId: receiverId)
        self.bankAccounts = BankAccountsService(apiClient: apiClient, instanceId: instanceId, customerId: receiverId)
        self.custodialWallets = CustodialWalletsService(apiClient: apiClient, instanceId: instanceId, customerId: receiverId)
    }
}

