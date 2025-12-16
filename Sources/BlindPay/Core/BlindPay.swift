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
    
    /// Available service for querying payment rails and bank details
    public let available: AvailableService
    
    /// Instances service for managing instance members and settings
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
    
    // MARK: - Available Service Methods
    
    /// Retrieves all available payment rails
    ///
    /// This method fetches a list of all payment rails that are available for use,
    /// including their display names, identifiers, and supported countries.
    ///
    /// - Returns: An `APIResponse` containing an array of `RailResponse` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getRails()
    /// if let rails = response.data {
    ///     for rail in rails {
    ///         print("\(rail.label) (\(rail.value)) - \(rail.country)")
    ///     }
    /// }
    /// ```
    public func getRails() async throws -> APIResponse<[RailResponse]> {
        return try await apiClient.request(
            endpoint: "/v1/available/rails",
            method: .get
        )
    }

    /// Retrieves bank detail fields required for a specific payment rail
    ///
    /// This method fetches the configuration and requirements for bank detail fields
    /// needed to process payments using the specified rail. Each field includes
    /// validation rules, display labels, and optional predefined values.
    ///
    /// - Parameter rail: The payment rail identifier (e.g., "wire", "ach", "pix")
    /// - Returns: An `APIResponse` containing an array of `BankDetailField` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getBankDetails(rail: "wire")
    /// if let fields = response.data {
    ///     for field in fields {
    ///         print("\(field.label): required=\(field.required), key=\(field.key)")
    ///         if let items = field.items {
    ///             print("  Options: \(items.map { $0.label }.joined(separator: ", "))")
    ///         }
    ///     }
    /// }
    /// ```
    public func getBankDetails(rail: String) async throws -> APIResponse<BankDetailResponse> {
        return try await apiClient.request(
            endpoint: "/v1/available/bank-details",
            method: .get,
            queryParameters: ["rail": rail]
        )
    }

    /// Retrieves bank information for a specific SWIFT code
    ///
    /// This method fetches bank details associated with the given SWIFT/BIC code,
    /// including bank name, address, city, branch, and other relevant information.
    ///
    /// - Parameter swift: The SWIFT/BIC code to look up (e.g., "CHASUS33")
    ///   Must be exactly 8 characters, containing only uppercase letters and numbers.
    /// - Returns: An `APIResponse` containing an array of `SwiftCodeResponse` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getSwiftCode(swift: "CHASUS33")
    /// if let swiftCodes = response.data {
    ///     for swiftCode in swiftCodes {
    ///         print("\(swiftCode.bank) - \(swiftCode.city), \(swiftCode.country)")
    ///     }
    /// }
    /// ```
    public func getSwiftCode(swift: String) async throws -> APIResponse<[SwiftCodeResponse]> {
        return try await apiClient.request(
            endpoint: "/v1/available/swift/\(swift)",
            method: .get
        )
    }
    
    // MARK: - Instance Service Methods
    
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
    /// let response = try await blindPay.getMembers()
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
    /// let response = try await blindPay.updateInstance(data: updateData)
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Instance updated successfully")
    /// }
    /// ```
    public func updateInstance(data: UpdateInstanceInput) async throws -> APIResponse<VoidResponse> {
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
    /// let response = try await blindPay.deleteInstance()
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Instance deleted successfully")
    /// }
    /// ```
    public func deleteInstance() async throws -> APIResponse<VoidResponse> {
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
    /// let response = try await blindPay.deleteMember(memberId: "member_123")
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
    /// let response = try await blindPay.updateMemberRole(
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
    /// let response = try await blindPay.createAssetTrustline(data: input)
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
    /// let response = try await blindPay.mintUsdbStellar(data: input)
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
    /// let response = try await blindPay.mintUsdbSolana(data: input)
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
    /// let response = try await blindPay.prepareDelegateSolana(data: input)
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
    
    /// Creates a new receiver
    ///
    /// This method creates a new receiver with the specified information. Receivers can be individuals or businesses,
    /// and require various KYC information depending on the KYC type selected.
    ///
    /// - Parameter data: The input data containing receiver information, KYC details, and optional documents
    /// - Returns: An `APIResponse` containing the created receiver ID
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateReceiverInput(
    ///     country: .us,
    ///     email: "email@example.com",
    ///     kycType: .standard,
    ///     type: .individual,
    ///     firstName: "John",
    ///     lastName: "Doe",
    ///     taxId: "536804398"
    /// )
    /// let response = try await blindPay.createReceiver(data: input)
    /// if let receiver = response.data {
    ///     print("Created receiver: \(receiver.id)")
    /// }
    /// ```
    public func createReceiver(data: CreateReceiverInput) async throws -> APIResponse<CreateReceiverResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers",
            method: .post,
            body: data
        )
    }
    
    /// Lists all receivers for the instance
    ///
    /// This method retrieves a paginated list of receivers with optional filtering and pagination parameters.
    ///
    /// - Parameters:
    ///   - limit: Number of items to return (optional, enum: 10, 50, 100, 200, 500, 1000)
    ///   - offset: Number of items to skip (optional, enum: 0, 10, 50, 100, 200, 500, 1000)
    ///   - startingAfter: A cursor for pagination - object ID that defines your place in the list (optional)
    ///   - endingBefore: A cursor for pagination - object ID that defines your place in the list (optional)
    ///   - fullName: Filter by full name (optional)
    /// - Returns: An `APIResponse` containing a list of receivers with pagination information
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.listReceivers(limit: 50, offset: 0)
    /// if let result = response.data {
    ///     print("Found \(result.data.count) receivers")
    ///     print("Has more: \(result.pagination.hasMore)")
    /// }
    /// ```
    public func listReceivers(
        limit: String? = nil,
        offset: String? = nil,
        startingAfter: String? = nil,
        endingBefore: String? = nil,
        fullName: String? = nil
    ) async throws -> APIResponse<ListReceiversResponse> {
        var queryParameters: [String: String] = [:]
        if let limit = limit {
            queryParameters["limit"] = limit
        }
        if let offset = offset {
            queryParameters["offset"] = offset
        }
        if let startingAfter = startingAfter {
            queryParameters["starting_after"] = startingAfter
        }
        if let endingBefore = endingBefore {
            queryParameters["ending_before"] = endingBefore
        }
        if let fullName = fullName {
            queryParameters["full_name"] = fullName
        }
        
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers",
            method: .get,
            queryParameters: queryParameters.isEmpty ? nil : queryParameters
        )
    }
    
    /// Retrieves a specific receiver by ID
    ///
    /// This method fetches detailed information about a receiver, including KYC status, warnings, and limits.
    ///
    /// - Parameter id: The unique identifier of the receiver
    /// - Returns: An `APIResponse` containing the receiver details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getReceiver(id: "re_123456789012345")
    /// if let receiver = response.data {
    ///     print("Receiver: \(receiver.email)")
    ///     print("KYC Status: \(receiver.kycStatus?.rawValue ?? "unknown")")
    /// }
    /// ```
    public func getReceiver(id: String) async throws -> APIResponse<Receiver> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(id)",
            method: .get
        )
    }
    
    /// Updates an existing receiver
    ///
    /// This method updates receiver information. Only provided fields will be updated.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the receiver to update
    ///   - data: The update data containing the fields to update
    /// - Returns: An `APIResponse` containing the update success status
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = UpdateReceiverInput(
    ///     country: .us,
    ///     email: "updated@example.com",
    ///     firstName: "Jane",
    ///     lastName: "Smith"
    /// )
    /// let response = try await blindPay.updateReceiver(id: "re_123", data: input)
    /// if let result = response.data {
    ///     print("Update successful: \(result.success)")
    /// }
    /// ```
    public func updateReceiver(id: String, data: UpdateReceiverInput) async throws -> APIResponse<UpdateReceiverResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(id)",
            method: .put,
            body: data
        )
    }
    
    /// Deletes a receiver
    ///
    /// This method permanently deletes a receiver. This action cannot be undone.
    ///
    /// - Parameter id: The unique identifier of the receiver to delete
    /// - Returns: An `APIResponse` containing the deletion success status
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.deleteReceiver(id: "re_123456789012345")
    /// if let result = response.data {
    ///     print("Deletion successful: \(result.success)")
    /// }
    /// ```
    public func deleteReceiver(id: String) async throws -> APIResponse<DeleteReceiverResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(id)",
            method: .delete
        )
    }
    
    /// Gets receiver limits
    ///
    /// This method retrieves the current payin and payout limits for a receiver.
    ///
    /// - Parameter id: The unique identifier of the receiver
    /// - Returns: An `APIResponse` containing the receiver limits
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getReceiverLimits(id: "re_123456789012345")
    /// if let limits = response.data {
    ///     print("Payin daily: \(limits.limits.payin.daily)")
    ///     print("Payout monthly: \(limits.limits.payout.monthly)")
    /// }
    /// ```
    public func getReceiverLimits(id: String) async throws -> APIResponse<ReceiverLimitsResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/limits/receivers/\(id)",
            method: .get
        )
    }
    
    /// Requests a limit increase for a receiver
    ///
    /// This method submits a request to increase the transaction limits for a receiver.
    /// A supporting document is required.
    ///
    /// - Parameters:
    ///   - receiverId: The unique identifier of the receiver
    ///   - data: The input data containing the requested limits and supporting document
    /// - Returns: An `APIResponse` containing the limit increase request ID
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = RequestLimitIncreaseInput(
    ///     perTransaction: 100000,
    ///     daily: 200000,
    ///     monthly: 1000000,
    ///     supportingDocumentType: .individualBankStatement,
    ///     supportingDocumentFile: "https://example.com/document.pdf"
    /// )
    /// let response = try await blindPay.requestLimitIncrease(receiverId: "re_123", data: input)
    /// if let result = response.data {
    ///     print("Request ID: \(result.id)")
    /// }
    /// ```
    public func requestLimitIncrease(receiverId: String, data: RequestLimitIncreaseInput) async throws -> APIResponse<RequestLimitIncreaseResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/limit-increase",
            method: .post,
            body: data
        )
    }
    
    /// Lists limit increase requests for a receiver
    ///
    /// This method retrieves all limit increase requests for a specific receiver.
    ///
    /// - Parameter receiverId: The unique identifier of the receiver
    /// - Returns: An `APIResponse` containing an array of limit increase requests
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.listLimitIncreaseRequests(receiverId: "re_123456789012345")
    /// if let requests = response.data {
    ///     for request in requests {
    ///         print("Request \(request.id): \(request.status.rawValue)")
    ///     }
    /// }
    /// ```
    public func listLimitIncreaseRequests(receiverId: String) async throws -> APIResponse<[LimitIncreaseRequest]> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/limit-increase",
            method: .get
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
    /// let receiversService = blindPay.receivers(receiverId: "re_123")
    /// let wallets = try await receiversService.blockchainWallets.list()
    /// ```
    public func receivers(receiverId: String) -> ReceiversService {
        return ReceiversService(apiClient: apiClient, instanceId: instanceId, receiverId: receiverId)
    }
    
    // MARK: - API Keys Service Methods
    
    /// Lists all API keys for the instance
    ///
    /// This method fetches a list of all API keys associated with the instance.
    /// Note that the token is only returned when creating or getting a single key.
    ///
    /// - Returns: An `APIResponse` containing an array of `ApiKey` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.listApiKeys()
    /// if let keys = response.data {
    ///     for key in keys {
    ///         print("\(key.name) - Last used: \(key.lastUsedAt ?? "Never")")
    ///     }
    /// }
    /// ```
    public func listApiKeys() async throws -> APIResponse<ApiKeysResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/api-keys",
            method: .get
        )
    }
    
    /// Creates a new API key for the instance
    ///
    /// This method creates a new API key with the specified name and permissions.
    /// The token is only returned once when the key is created.
    ///
    /// - Parameter data: The input data containing the key name, permission, and optional IP whitelist
    /// - Returns: An `APIResponse` containing the created API key with its token
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateApiKeyInput(
    ///     name: "My API Key",
    ///     permission: .fullAccess,
    ///     ipWhitelist: ["192.168.1.1"]
    /// )
    /// let response = try await blindPay.createApiKey(data: input)
    /// if let created = response.data {
    ///     print("Created key: \(created.id)")
    ///     print("Token: \(created.token)") // Save this token securely!
    /// }
    /// ```
    public func createApiKey(data: CreateApiKeyInput) async throws -> APIResponse<CreateApiKeyResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/api-keys",
            method: .post,
            body: data
        )
    }
    
    /// Retrieves a specific API key by ID
    ///
    /// This method fetches the details of a specific API key, including its token.
    ///
    /// - Parameter id: The unique identifier of the API key
    /// - Returns: An `APIResponse` containing the `ApiKey` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getApiKey(id: "key_123")
    /// if let key = response.data {
    ///     print("Key name: \(key.name)")
    ///     print("Token: \(key.token)")
    /// }
    /// ```
    public func getApiKey(id: String) async throws -> APIResponse<ApiKey> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/api-keys/\(id)",
            method: .get
        )
    }
    
    /// Deletes an API key
    ///
    /// This method permanently deletes an API key. This action cannot be undone.
    ///
    /// - Parameter id: The unique identifier of the API key to delete
    /// - Returns: An `APIResponse` with a void response indicating success
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.deleteApiKey(id: "key_123")
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("API key deleted successfully")
    /// }
    /// ```
    public func deleteApiKey(id: String) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/api-keys/\(id)",
            method: .delete
        )
    }
    
    // MARK: - Partner Fees Service Methods
    
    /// Lists all partner fees for the instance
    ///
    /// This method fetches a list of all partner fees associated with the instance.
    ///
    /// - Returns: An `APIResponse` containing an array of `PartnerFee` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.listPartnerFees()
    /// if let fees = response.data {
    ///     for fee in fees {
    ///         print("\(fee.name): \(fee.payoutPercentageFee)% + \(fee.payoutFlatFee) flat")
    ///     }
    /// }
    /// ```
    public func listPartnerFees() async throws -> APIResponse<PartnerFeesResponse> {
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
    /// let response = try await blindPay.createPartnerFee(data: input)
    /// if let created = response.data {
    ///     print("Created fee: \(created.id)")
    /// }
    /// ```
    public func createPartnerFee(data: CreatePartnerFeeInput) async throws -> APIResponse<CreatePartnerFeeResponse> {
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
    /// let response = try await blindPay.getPartnerFee(id: "pf_123")
    /// if let fee = response.data {
    ///     print("Fee: \(fee.name)")
    /// }
    /// ```
    public func getPartnerFee(id: String) async throws -> APIResponse<PartnerFee> {
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
    /// let response = try await blindPay.deletePartnerFee(id: "pf_123")
    /// if let error = response.error {
    ///     print("Error: \(error.message)")
    /// } else {
    ///     print("Partner fee deleted successfully")
    /// }
    /// ```
    public func deletePartnerFee(id: String) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/partner-fees/\(id)",
            method: .delete
        )
    }
    
    // MARK: - Quotes Service Methods
    
    /// Creates a new quote
    ///
    /// This method creates a new quote for a transaction based on the provided parameters.
    ///
    /// - Parameter data: The input data containing quote configuration
    /// - Returns: An `APIResponse` containing the created quote details including contract information
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateQuoteInput(
    ///     bankAccountId: "ba_123",
    ///     currencyType: .sender,
    ///     network: .base,
    ///     requestAmount: 1000.0,
    ///     token: .usdc,
    ///     coverFees: true,
    ///     description: "Payment for services",
    ///     partnerFeeId: "pf_123",
    ///     transactionDocumentFile: nil,
    ///     transactionDocumentId: nil,
    ///     transactionDocumentType: .invoice
    /// )
    /// let response = try await blindPay.createQuote(data: input)
    /// if let quote = response.data {
    ///     print("Quote ID: \(quote.id)")
    ///     print("Expires at: \(quote.expiresAt)")
    ///     print("Sender amount: \(quote.senderAmount)")
    ///     print("Receiver amount: \(quote.receiverAmount)")
    /// }
    /// ```
    public func createQuote(data: CreateQuoteInput) async throws -> APIResponse<CreateQuoteResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/quotes",
            method: .post,
            body: data
        )
    }
    
    /// Gets the foreign exchange rate between two currencies
    ///
    /// This method retrieves the current FX rate for converting between two currencies,
    /// including BlindPay quotation and fees.
    ///
    /// - Parameter data: The input data containing currency information and request amount
    /// - Returns: An `APIResponse` containing FX rate details including quotations and fees
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = GetFxRateInput(
    ///     currencyType: .sender,
    ///     from: .usdc,
    ///     to: .brl,
    ///     requestAmount: 1000.0
    /// )
    /// let response = try await blindPay.getFxRate(data: input)
    /// if let fxRate = response.data {
    ///     print("Commercial quotation: \(fxRate.commercialQuotation)")
    ///     print("BlindPay quotation: \(fxRate.blindpayQuotation)")
    ///     print("Result amount: \(fxRate.resultAmount)")
    /// }
    /// ```
    public func getFxRate(data: GetFxRateInput) async throws -> APIResponse<GetFxRateResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/quotes/fx",
            method: .post,
            body: data
        )
    }
    
    // MARK: - Webhook Endpoints Service Methods
    
    /// Lists all webhook endpoints for the instance
    ///
    /// This method fetches a list of all webhook endpoints associated with the instance.
    ///
    /// - Returns: An `APIResponse` containing an array of `WebhookEndpoint` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.listWebhookEndpoints()
    /// if let endpoints = response.data {
    ///     for endpoint in endpoints {
    ///         print("\(endpoint.url) - Events: \(endpoint.events)")
    ///     }
    /// }
    /// ```
    public func listWebhookEndpoints() async throws -> APIResponse<WebhookEndpointsResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/webhook-endpoints",
            method: .get
        )
    }
    
    /// Creates a new webhook endpoint for the instance
    ///
    /// This method creates a new webhook endpoint with the specified URL and events.
    ///
    /// - Parameter data: The input data containing the URL and events to subscribe to
    /// - Returns: An `APIResponse` containing the created webhook endpoint ID
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreateWebhookEndpointInput(
    ///     url: "https://example.com/webhook",
    ///     events: [.receiverNew, .payoutNew]
    /// )
    /// let response = try await blindPay.createWebhookEndpoint(data: input)
    /// if let created = response.data {
    ///     print("Created endpoint: \(created.id)")
    /// }
    /// ```
    public func createWebhookEndpoint(data: CreateWebhookEndpointInput) async throws -> APIResponse<CreateWebhookEndpointResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/webhook-endpoints",
            method: .post,
            body: data
        )
    }
    
    /// Deletes a webhook endpoint
    ///
    /// This method permanently deletes a webhook endpoint. This action cannot be undone.
    ///
    /// - Parameter id: The unique identifier of the webhook endpoint to delete
    /// - Returns: An `APIResponse` with a success response indicating deletion
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.deleteWebhookEndpoint(id: "we_123")
    /// if let result = response.data {
    ///     print("Deleted: \(result.success)")
    /// }
    /// ```
    public func deleteWebhookEndpoint(id: String) async throws -> APIResponse<DeleteWebhookEndpointResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/webhook-endpoints/\(id)",
            method: .delete
        )
    }
    
    /// Retrieves the secret key for a webhook endpoint
    ///
    /// This method fetches the secret key used to verify webhook signatures.
    ///
    /// - Parameter id: The unique identifier of the webhook endpoint
    /// - Returns: An `APIResponse` containing the webhook secret key
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getWebhookEndpointSecret(id: "we_123")
    /// if let secret = response.data {
    ///     print("Secret key: \(secret.key)")
    /// }
    /// ```
    public func getWebhookEndpointSecret(id: String) async throws -> APIResponse<WebhookEndpointSecret> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/webhook-endpoints/\(id)/secret",
            method: .get
        )
    }
    
    /// Retrieves the portal access URL for webhook endpoints
    ///
    /// This method fetches a URL that provides access to the webhook portal
    /// for managing webhook endpoints.
    ///
    /// - Returns: An `APIResponse` containing the portal access URL
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getWebhookPortalAccessUrl()
    /// if let portal = response.data {
    ///     print("Portal URL: \(portal.url)")
    /// }
    /// ```
    public func getWebhookPortalAccessUrl() async throws -> APIResponse<WebhookPortalAccess> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/webhook-endpoints/portal-access",
            method: .get
        )
    }
    
    // MARK: - Payins Service Methods
    
    /// Lists all payins for the instance
    ///
    /// This method fetches a list of all payins associated with the instance,
    /// with optional filtering and pagination support.
    ///
    /// - Parameter params: Optional parameters for filtering and pagination
    /// - Returns: An `APIResponse` containing a `ListPayinsResponse` with payins and pagination metadata
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let params = ListPayinsInput(
    ///     limit: "50",
    ///     status: .processing,
    ///     receiverId: "re_123"
    /// )
    /// let response = try await blindPay.listPayins(params: params)
    /// if let result = response.data {
    ///     print("Found \(result.data.count) payins")
    ///     print("Has more: \(result.pagination.hasMore)")
    /// }
    /// ```
    public func listPayins(params: ListPayinsInput? = nil) async throws -> APIResponse<ListPayinsResponse> {
        let queryParams = params?.toQueryParameters() ?? [:]
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payins",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams
        )
    }
    
    /// Retrieves a specific payin by ID
    ///
    /// This method fetches the details of a specific payin.
    ///
    /// - Parameter payinId: The unique identifier of the payin
    /// - Returns: An `APIResponse` containing the `Payin` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getPayin(payinId: "pi_123")
    /// if let payin = response.data {
    ///     print("Payin status: \(payin.status.rawValue)")
    ///     print("Receiver amount: \(payin.receiverAmount ?? 0)")
    /// }
    /// ```
    public func getPayin(payinId: String) async throws -> APIResponse<PayinResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payins/\(payinId)",
            method: .get
        )
    }
    
    /// Retrieves payin tracking information
    ///
    /// This method fetches tracking information for a payin using the public endpoint.
    ///
    /// - Parameter payinId: The unique identifier of the payin
    /// - Returns: An `APIResponse` containing the `Payin` object with tracking information
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getPayinTrack(payinId: "pi_123")
    /// if let payin = response.data {
    ///     print("Tracking transaction step: \(payin.trackingTransaction?.step ?? "N/A")")
    ///     print("Tracking payment step: \(payin.trackingPayment?.step ?? "N/A")")
    /// }
    /// ```
    public func getPayinTrack(payinId: String) async throws -> APIResponse<PayinResponse> {
        return try await apiClient.request(
            endpoint: "/v1/e/payins/\(payinId)",
            method: .get
        )
    }
    
    /// Creates a new payin on EVM chains
    ///
    /// This method creates a new payin transaction on EVM-compatible blockchains
    /// using a previously created payin quote.
    ///
    /// - Parameter data: The input data containing the payin quote ID
    /// - Returns: An `APIResponse` containing the created payin details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreatePayinInput(payinQuoteId: "pq_123")
    /// let response = try await blindPay.createPayinEvm(data: input)
    /// if let payin = response.data {
    ///     print("Created payin: \(payin.id)")
    ///     print("Status: \(payin.status.rawValue)")
    ///     if let pixCode = payin.pixCode {
    ///         print("PIX code: \(pixCode)")
    ///     }
    /// }
    /// ```
    public func createPayinEvm(data: CreatePayinInput) async throws -> APIResponse<CreatePayinResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payins/evm",
            method: .post,
            body: data
        )
    }
    
    // MARK: - Payin Quotes Service Methods
    
    /// Creates a new payin quote
    ///
    /// This method creates a new payin quote for a transaction based on the provided parameters.
    ///
    /// - Parameter data: The input data containing payin quote configuration
    /// - Returns: An `APIResponse` containing the created payin quote details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreatePayinQuoteInput(
    ///     receiverId: "re_123",
    ///     blockchainWalletId: "bw_123",
    ///     paymentMethod: .pix,
    ///     currencyType: .sender,
    ///     network: .base,
    ///     requestAmount: 1000.0,
    ///     token: .usdc,
    ///     coverFees: true,
    ///     description: "Payment for services",
    ///     partnerFeeId: "pf_123"
    /// )
    /// let response = try await blindPay.createPayinQuote(data: input)
    /// if let quote = response.data {
    ///     print("Quote ID: \(quote.id)")
    ///     print("Expires at: \(quote.expiresAt)")
    ///     print("Sender amount: \(quote.senderAmount)")
    ///     print("Receiver amount: \(quote.receiverAmount)")
    /// }
    /// ```
    public func createPayinQuote(data: CreatePayinQuoteInput) async throws -> APIResponse<CreatePayinQuoteResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payin-quotes",
            method: .post,
            body: data
        )
    }
    
    /// Retrieves a specific payin quote by ID
    ///
    /// This method fetches the details of a specific payin quote.
    ///
    /// - Parameter id: The unique identifier of the payin quote
    /// - Returns: An `APIResponse` containing the `PayinQuote` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getPayinQuote(id: "pq_123")
    /// if let quote = response.data {
    ///     print("Quote ID: \(quote.id)")
    ///     print("Expires at: \(quote.expiresAt)")
    ///     print("Sender amount: \(quote.senderAmount)")
    ///     print("Receiver amount: \(quote.receiverAmount)")
    /// }
    /// ```
    public func getPayinQuote(id: String) async throws -> APIResponse<PayinQuoteResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payin-quotes/\(id)",
            method: .get
        )
    }
    
    /// Lists all payin quotes for the instance
    ///
    /// This method fetches a list of all payin quotes associated with the instance,
    /// with optional filtering and pagination support.
    ///
    /// - Parameter params: Optional parameters for filtering and pagination
    /// - Returns: An `APIResponse` containing an array of `PayinQuote` objects
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let params = ListPayinQuotesInput(
    ///     limit: "50",
    ///     receiverId: "re_123"
    /// )
    /// let response = try await blindPay.listPayinQuotes(params: params)
    /// if let quotes = response.data {
    ///     print("Found \(quotes.count) payin quotes")
    ///     for quote in quotes {
    ///         print("Quote ID: \(quote.id)")
    ///     }
    /// }
    /// ```
    public func listPayinQuotes(params: ListPayinQuotesInput? = nil) async throws -> APIResponse<PayinQuotesResponse> {
        let queryParams = params?.toQueryParameters() ?? [:]
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payin-quotes",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams
        )
    }
    
    /// Gets the foreign exchange rate between two currencies for payin quotes
    ///
    /// This method retrieves the current FX rate for converting between two currencies,
    /// including BlindPay quotation and fees for payin quotes.
    ///
    /// - Parameter data: The input data containing currency information and request amount
    /// - Returns: An `APIResponse` containing FX rate details including quotations and fees
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = GetFxRateInput(
    ///     currencyType: .sender,
    ///     from: .usdc,
    ///     to: .brl,
    ///     requestAmount: 1000.0
    /// )
    /// let response = try await blindPay.getPayinQuoteFxRate(data: input)
    /// if let fxRate = response.data {
    ///     print("Commercial quotation: \(fxRate.commercialQuotation)")
    ///     print("BlindPay quotation: \(fxRate.blindpayQuotation)")
    ///     print("Result amount: \(fxRate.resultAmount)")
    /// }
    /// ```
    public func getPayinQuoteFxRate(data: GetFxRateInput) async throws -> APIResponse<GetFxRateResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payin-quotes/fx",
            method: .post,
            body: data
        )
    }
    
    // MARK: - Payouts Service Methods
    
    /// Lists all payouts for the instance
    ///
    /// This method fetches a list of all payouts associated with the instance,
    /// with optional filtering and pagination support.
    ///
    /// - Parameter params: Optional parameters for filtering and pagination
    /// - Returns: An `APIResponse` containing a `ListPayoutsResponse` with payouts and pagination metadata
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let params = ListPayoutsInput(
    ///     limit: "50",
    ///     status: .processing,
    ///     receiverId: "re_123"
    /// )
    /// let response = try await blindPay.listPayouts(params: params)
    /// if let result = response.data {
    ///     print("Found \(result.data.count) payouts")
    ///     print("Has more: \(result.pagination.hasMore)")
    /// }
    /// ```
    public func listPayouts(params: ListPayoutsInput? = nil) async throws -> APIResponse<ListPayoutsResponse> {
        let queryParams = params?.toQueryParameters() ?? [:]
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts",
            method: .get,
            queryParameters: queryParams.isEmpty ? nil : queryParams
        )
    }
    
    /// Retrieves a specific payout by ID
    ///
    /// This method fetches the details of a specific payout.
    ///
    /// - Parameter payoutId: The unique identifier of the payout
    /// - Returns: An `APIResponse` containing the `Payout` object
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getPayout(payoutId: "pa_123")
    /// if let payout = response.data {
    ///     print("Payout status: \(payout.status.rawValue)")
    ///     print("Receiver amount: \(payout.receiverAmount)")
    /// }
    /// ```
    public func getPayout(payoutId: String) async throws -> APIResponse<PayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/\(payoutId)",
            method: .get
        )
    }
    
    /// Retrieves payout tracking information
    ///
    /// This method fetches tracking information for a payout using the public endpoint.
    ///
    /// - Parameter payoutId: The unique identifier of the payout
    /// - Returns: An `APIResponse` containing the `Payout` object with tracking information
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let response = try await blindPay.getPayoutTrack(payoutId: "pa_123")
    /// if let payout = response.data {
    ///     print("Tracking transaction step: \(payout.trackingTransaction?.step.rawValue ?? "N/A")")
    ///     print("Tracking payment step: \(payout.trackingPayment?.step.rawValue ?? "N/A")")
    /// }
    /// ```
    public func getPayoutTrack(payoutId: String) async throws -> APIResponse<PayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/e/payouts/\(payoutId)",
            method: .get
        )
    }
    
    /// Creates a new payout on EVM chains
    ///
    /// This method creates a new payout transaction on EVM-compatible blockchains
    /// using a previously created quote.
    ///
    /// - Parameter data: The input data containing the quote ID and sender wallet address
    /// - Returns: An `APIResponse` containing the created payout details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreatePayoutEvmInput(
    ///     quoteId: "qu_123",
    ///     senderWalletAddress: "0x123...890"
    /// )
    /// let response = try await blindPay.createPayoutEvm(data: input)
    /// if let payout = response.data {
    ///     print("Created payout: \(payout.id)")
    ///     print("Status: \(payout.status.rawValue)")
    /// }
    /// ```
    public func createPayoutEvm(data: CreatePayoutEvmInput) async throws -> APIResponse<CreatePayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/evm",
            method: .post,
            body: data
        )
    }
    
    /// Creates a new payout on Stellar
    ///
    /// This method creates a new payout transaction on the Stellar blockchain
    /// using a previously created quote.
    ///
    /// - Parameter data: The input data containing the quote ID, sender wallet address, and optional signed transaction
    /// - Returns: An `APIResponse` containing the created payout details
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = CreatePayoutStellarInput(
    ///     quoteId: "qu_123",
    ///     senderWalletAddress: "GABC...XYZ",
    ///     signedTransaction: "AAA...Zey8y0A"
    /// )
    /// let response = try await blindPay.createPayoutStellar(data: input)
    /// if let payout = response.data {
    ///     print("Created payout: \(payout.id)")
    ///     print("Status: \(payout.status.rawValue)")
    /// }
    /// ```
    public func createPayoutStellar(data: CreatePayoutStellarInput) async throws -> APIResponse<CreatePayoutResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/stellar",
            method: .post,
            body: data
        )
    }
    
    /// Authorizes a token on Stellar wallet
    ///
    /// This method authorizes a token on a Stellar wallet before creating a payout.
    ///
    /// - Parameter data: The input data containing the quote ID and sender wallet address
    /// - Returns: An `APIResponse` containing the transaction hash
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = AuthorizeStellarInput(
    ///     quoteId: "qu_123",
    ///     senderWalletAddress: "GABC...XYZ"
    /// )
    /// let response = try await blindPay.authorizeStellar(data: input)
    /// if let result = response.data {
    ///     print("Transaction hash: \(result.transactionHash)")
    /// }
    /// ```
    public func authorizeStellar(data: AuthorizeStellarInput) async throws -> APIResponse<AuthorizeStellarResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/payouts/stellar/authorize",
            method: .post,
            body: data
        )
    }
    
    // MARK: - Terms of Service Service Methods
    
    /// Initiates a new terms of service session
    ///
    /// This method creates a new terms of service session and returns a URL
    /// where the user can review and accept the terms.
    ///
    /// - Important: The TOS acceptance must happen in a browser. After initiating the session,
    ///   open the returned URL in a browser and accept the terms. The TOS ID must be extracted
    ///   manually from the browser's network requests.
    ///
    ///   **To get the TOS ID after accepting in browser:**
    ///   1. Use `initiateTermsOfService()` to get a TOS acceptance URL
    ///   2. Open the URL in a browser and accept the terms
    ///   3. Open Browser Developer Tools (F12 or right-click → Inspect)
    ///   4. Go to the **Network** tab
    ///   5. Find the **PUT** request to `/v1/e/tos` (it will appear after you click accept)
    ///   6. Click on the request to view details
    ///   7. Go to the **Preview** or **Response** tab
    ///   8. Look for the `tos_id` field in the JSON response (format: `to_...`)
    ///   9. Use this TOS ID when creating receivers or other operations that require it
    ///
    /// - Parameter data: The input data containing idempotency key, optional receiver ID, and optional redirect URL
    /// - Returns: An `APIResponse` containing the terms of service URL
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = InitiateTosInput(
    ///     idempotencyKey: "123e4567-e89b-12d3-a456-426614174000",
    ///     receiverId: "re_000000000000",
    ///     redirectUrl: "https://example.com/redirect"
    /// )
    /// let response = try await blindPay.initiateTermsOfService(data: input)
    /// if let result = response.data {
    ///     print("TOS URL: \(result.url)")
    ///     // Open result.url in a browser to accept the terms
    /// }
    /// ```
    public func initiateTermsOfService(data: InitiateTosInput) async throws -> APIResponse<InitiateTosResponse> {
        return try await apiClient.request(
            endpoint: "/v1/e/instances/\(instanceId)/tos",
            method: .post,
            body: data
        )
    }
}

