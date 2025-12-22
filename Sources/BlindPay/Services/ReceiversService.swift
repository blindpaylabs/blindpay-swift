//
//  ReceiversService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Service for managing receiver resources
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
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
    
    init(apiClient: APIClient, instanceId: String, receiverId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.receiverId = receiverId
        self.blockchainWallets = BlockchainWalletsService(apiClient: apiClient, instanceId: instanceId, receiverId: receiverId)
        self.virtualAccounts = VirtualAccountsService(apiClient: apiClient, instanceId: instanceId, receiverId: receiverId)
        self.bankAccounts = BankAccountsService(apiClient: apiClient, instanceId: instanceId, receiverId: receiverId)
    }
}

