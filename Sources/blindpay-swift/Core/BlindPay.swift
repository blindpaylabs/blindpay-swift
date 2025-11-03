//
//  BlindPay.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// Main BlindPay client
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class BlindPay: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    /// Available payment rails service
    public let available: AvailableService
    
    /// Instance management service
    public let instances: InstancesService
    
    /// Initialize the BlindPay client
    /// - Parameters:
    ///   - apiKey: Your BlindPay API key
    ///   - instanceId: Your BlindPay instance ID
    ///   - configuration: Optional configuration for custom base URL and other settings
    public init(apiKey: String, instanceId: String, configuration: Configuration = .default) {
        self.instanceId = instanceId
        self.apiClient = APIClient(apiKey: apiKey, instanceId: instanceId, configuration: configuration)
        self.available = AvailableService(apiClient: apiClient)
        self.instances = InstancesService(apiClient: apiClient, instanceId: instanceId)
    }
}

