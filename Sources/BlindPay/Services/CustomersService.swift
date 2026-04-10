//
//  CustomersService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Service for managing receiver resources
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

    init(apiClient: APIClient, instanceId: String, customerId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.customerId = customerId
        self.blockchainWallets = BlockchainWalletsService(apiClient: apiClient, instanceId: instanceId, customerId: customerId)
        self.virtualAccounts = VirtualAccountsService(apiClient: apiClient, instanceId: instanceId, customerId: customerId)
        self.bankAccounts = BankAccountsService(apiClient: apiClient, instanceId: instanceId, customerId: customerId)
        self.custodialWallets = CustodialWalletsService(apiClient: apiClient, instanceId: instanceId, customerId: customerId)
    }
}

