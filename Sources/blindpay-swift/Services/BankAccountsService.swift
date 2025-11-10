//
//  BankAccountsService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

/// Service for managing bank accounts
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class BankAccountsService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    /// Offramp wallets management service
    public let offrampWallets: OfframpWalletsService
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.offrampWallets = OfframpWalletsService(apiClient: apiClient, instanceId: instanceId)
    }
}

