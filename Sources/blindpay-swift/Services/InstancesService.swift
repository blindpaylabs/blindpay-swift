//
//  InstancesService.swift
//  blindpay-swift
//
//  Created by Eric Viana on 31/10/25.
//

import Foundation

/// Service for managing instance members and settings
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class InstancesService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    
    /// API keys management service
    public let apiKeys: ApiKeysService
    
    /// Partner fees management service
    public let partnerFees: PartnerFeesService
    
    /// Quotes management service
    public let quotes: QuotesService
    
    /// Webhook endpoints management service
    public let webhookEndpoints: WebhookEndpointsService
    
    /// Payins management service
    public let payins: PayinsService
    
    /// Payouts management service
    public let payouts: PayoutsService
    
    /// Terms of service management service
    public let termsOfService: TermsOfServiceService
    
    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.apiKeys = ApiKeysService(apiClient: apiClient, instanceId: instanceId)
        self.partnerFees = PartnerFeesService(apiClient: apiClient, instanceId: instanceId)
        self.quotes = QuotesService(apiClient: apiClient, instanceId: instanceId)
        self.webhookEndpoints = WebhookEndpointsService(apiClient: apiClient, instanceId: instanceId)
        self.payins = PayinsService(apiClient: apiClient, instanceId: instanceId)
        self.payouts = PayoutsService(apiClient: apiClient, instanceId: instanceId)
        self.termsOfService = TermsOfServiceService(apiClient: apiClient, instanceId: instanceId)
    }
    
    /// Retrieves all members of the instance
    ///
    /// This method fetches a list of all members associated with the instance,
    /// including their roles, contact information, and membership details.
    ///
    /// - Returns: An `APIResponse` containing an array of `InstanceMember` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.getMembers()
    /// if let members = response.data {
    ///     for member in members {
    ///         print("\(member.firstName) \(member.lastName) - \(member.role.rawValue)")
    ///     }
    /// }
    /// ```
    public func getMembers() async throws -> APIResponse<InstanceMembersResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/members",
            method: .get
        )
    }
    
    /// Updates the instance with new data
    ///
    /// This method updates the instance's name and optionally sets a redirect URL
    /// for receiver invites.
    ///
    /// - Parameter data: The update data containing the instance name and optional redirect URL
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let updateData = UpdateInstanceInput(
    ///     name: "My Updated Instance",
    ///     receiverInviteRedirectUrl: "https://example.com/redirect"
    /// )
    /// let response = try await blindPay.instances.update(data: updateData)
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Instance updated successfully")
    /// }
    /// ```
    public func update(data: UpdateInstanceInput) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)",
            method: .put,
            body: data
        )
    }
    
    /// Deletes the instance
    ///
    /// This method permanently deletes the instance. This action cannot be undone.
    ///
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.delete()
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Instance deleted successfully")
    /// }
    /// ```
    public func delete() async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)",
            method: .delete
        )
    }
    
    /// Deletes a member from the instance
    ///
    /// This method permanently removes a member from the instance.
    ///
    /// - Parameter memberId: The unique identifier of the member to delete
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.deleteMember(memberId: "member_123")
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Member deleted successfully")
    /// }
    /// ```
    public func deleteMember(memberId: String) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/members/\(memberId)",
            method: .delete
        )
    }
    
    /// Updates a member's role in the instance
    ///
    /// This method changes the role assigned to a specific member.
    ///
    /// - Parameters:
    ///   - memberId: The unique identifier of the member
    ///   - role: The new role to assign to the member
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.instances.updateMemberRole(
    ///     memberId: "member_123",
    ///     role: .admin
    /// )
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Member role updated successfully")
    /// }
    /// ```
    public func updateMemberRole(memberId: String, role: InstanceMemberRole) async throws -> APIResponse<VoidResponse> {
        let updateInput = UpdateMemberRoleInput(role: role)
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/members/\(memberId)",
            method: .put,
            body: updateInput
        )
    }
    
    /// Creates an asset trustline for a Stellar wallet
    ///
    /// This method creates an asset trustline transaction that needs to be signed and submitted.
    ///
    /// - Parameter data: The input data containing the wallet address
    /// - Returns: An `APIResponse` containing the XDR transaction envelope
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateAssetTrustlineInput(address: "GABC...XYZ")
    /// let response = try await blindPay.instances.createAssetTrustline(data: input)
    /// if let result = response.data {
    ///     print("XDR: \(result.xdr)")
    /// }
    /// ```
    public func createAssetTrustline(data: CreateAssetTrustlineInput) async throws -> APIResponse<CreateAssetTrustlineResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/create-asset-trustline",
            method: .post,
            body: data
        )
    }
    
    /// Mints USDB on Stellar
    ///
    /// This method mints USDB tokens on the Stellar network for the specified address.
    ///
    /// - Parameter data: The input data containing the address, amount, and optional signed XDR
    /// - Returns: An `APIResponse` containing the success status
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = MintUsdbStellarInput(
    ///     address: "GABC...XYZ",
    ///     amount: "1000",
    ///     signedXdr: "AAA...Zey8y0A"
    /// )
    /// let response = try await blindPay.instances.mintUsdbStellar(data: input)
    /// if let result = response.data {
    ///     print("Success: \(result.success)")
    /// }
    /// ```
    public func mintUsdbStellar(data: MintUsdbStellarInput) async throws -> APIResponse<MintUsdbStellarResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/mint-usdb-stellar",
            method: .post,
            body: data
        )
    }
    
    /// Mints USDB on Solana Devnet
    ///
    /// This method mints USDB tokens on the Solana Devnet for the specified address.
    ///
    /// - Parameter data: The input data containing the address and amount
    /// - Returns: An `APIResponse` containing the success status, signature, and optional error
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = MintUsdbSolanaInput(
    ///     address: "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU",
    ///     amount: "1000"
    /// )
    /// let response = try await blindPay.instances.mintUsdbSolana(data: input)
    /// if let result = response.data {
    ///     print("Success: \(result.success)")
    ///     if let signature = result.signature {
    ///         print("Signature: \(signature)")
    ///     }
    /// }
    /// ```
    public func mintUsdbSolana(data: MintUsdbSolanaInput) async throws -> APIResponse<MintUsdbSolanaResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/mint-usdb-solana",
            method: .post,
            body: data
        )
    }
    
    /// Prepares a Solana delegate transaction
    ///
    /// This method prepares a transaction for delegating tokens on Solana.
    ///
    /// - Parameter data: The input data containing the amount, owner address, and token address
    /// - Returns: An `APIResponse` containing the success status and transaction string
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = PrepareDelegateSolanaInput(
    ///     amount: "1000",
    ///     ownerAddress: "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU",
    ///     tokenAddress: "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v"
    /// )
    /// let response = try await blindPay.instances.prepareDelegateSolana(data: input)
    /// if let result = response.data {
    ///     print("Success: \(result.success)")
    ///     if let transaction = result.transaction {
    ///         print("Transaction: \(transaction)")
    ///     }
    /// }
    /// ```
    public func prepareDelegateSolana(data: PrepareDelegateSolanaInput) async throws -> APIResponse<PrepareDelegateSolanaResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/prepare-delegate-solana",
            method: .post,
            body: data
        )
    }
    
    /// Gets a receiver service for a specific receiver ID
    ///
    /// This method returns a service instance for managing resources associated with a specific receiver,
    /// such as blockchain wallets.
    ///
    /// - Parameter receiverId: The unique identifier of the receiver
    /// - Returns: A `ReceiversService` instance for the specified receiver
    ///
    /// Example:
    /// ```swift
    /// let receiversService = blindPay.instances.receivers(receiverId: "re_123")
    /// let wallets = try await receiversService.blockchainWallets.list()
    /// ```
    public func receivers(receiverId: String) -> ReceiversService {
        return ReceiversService(apiClient: apiClient, instanceId: instanceId, receiverId: receiverId)
    }
}

