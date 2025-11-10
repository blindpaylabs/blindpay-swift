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
    private let receiverId: String
    
    /// Offramp wallets management service
    public let offrampWallets: OfframpWalletsService
    
    init(apiClient: APIClient, instanceId: String, receiverId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.receiverId = receiverId
        self.offrampWallets = OfframpWalletsService(apiClient: apiClient, instanceId: instanceId)
    }
    
    /// Lists all bank accounts for the receiver
    ///
    /// This method fetches a list of all bank accounts associated with the receiver.
    ///
    /// - Returns: An `APIResponse` containing an array of `BankAccount` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").bankAccounts.list()
    /// if let bankAccounts = response.data {
    ///     for bankAccount in bankAccounts {
    ///         print("\(bankAccount.name) - \(bankAccount.type.rawValue)")
    ///         if let accountNumber = bankAccount.accountNumber {
    ///             print("Account: \(accountNumber)")
    ///         }
    ///     }
    /// }
    /// ```
    public func list() async throws -> APIResponse<BankAccountsResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/bank-accounts",
            method: .get
        )
    }
    
    /// Creates a new bank account
    ///
    /// This method creates a new bank account for the receiver with the specified configuration.
    ///
    /// - Parameter data: The input data containing bank account configuration
    /// - Returns: An `APIResponse` containing the created bank account details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateBankAccountInput(
    ///     name: "My Bank Account",
    ///     type: .wire,
    ///     accountClass: .individual,
    ///     accountNumber: "1001001234",
    ///     accountType: .checking,
    ///     routingNumber: "012345678",
    ///     beneficiaryName: "John Doe",
    ///     addressLine1: "123 Main St",
    ///     city: "New York",
    ///     stateProvinceRegion: "NY",
    ///     country: .us,
    ///     postalCode: "10001"
    /// )
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").bankAccounts.create(data: input)
    /// if let bankAccount = response.data {
    ///     print("Created bank account: \(bankAccount.id)")
    ///     print("Type: \(bankAccount.type.rawValue)")
    /// }
    /// ```
    public func create(data: CreateBankAccountInput) async throws -> APIResponse<CreateBankAccountResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/bank-accounts",
            method: .post,
            body: data
        )
    }
    
    /// Retrieves a specific bank account by ID
    ///
    /// This method fetches the details of a specific bank account.
    ///
    /// - Parameter id: The unique identifier of the bank account
    /// - Returns: An `APIResponse` containing the `BankAccount` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").bankAccounts.get(id: "ba_123")
    /// if let bankAccount = response.data {
    ///     print("Bank account name: \(bankAccount.name)")
    ///     print("Type: \(bankAccount.type.rawValue)")
    ///     if let accountNumber = bankAccount.accountNumber {
    ///         print("Account number: \(accountNumber)")
    ///     }
    /// }
    /// ```
    public func get(id: String) async throws -> APIResponse<BankAccountResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/bank-accounts/\(id)",
            method: .get
        )
    }
    
    /// Deletes a bank account
    ///
    /// This method permanently deletes a bank account. This action cannot be undone.
    ///
    /// - Parameter id: The unique identifier of the bank account to delete
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.receivers(receiverId: "re_123").bankAccounts.delete(id: "ba_123")
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Bank account deleted successfully")
    /// }
    /// ```
    public func delete(id: String) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/bank-accounts/\(id)",
            method: .delete
        )
    }
}

