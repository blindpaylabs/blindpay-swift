//
//  TransferQuotesService.swift
//  blindpay-swift
//

import Foundation

/// Quotes for stablecoin transfers. Instance-scoped.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class TransferQuotesService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String

    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }

    /// Creates a transfer quote. Pass its id to ``TransfersService/create(data:options:)``.
    public func create(data: CreateTransferQuoteInput, options: RequestOptions? = nil) async throws -> APIResponse<CreateTransferQuoteResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/transfer-quotes",
            method: .post,
            body: data,
            options: options
        )
    }
}
