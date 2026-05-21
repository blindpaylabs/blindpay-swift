//
//  RfiService.swift
//  blindpay-swift
//

import Foundation

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class RfiService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String
    private let receiverId: String

    init(apiClient: APIClient, instanceId: String, receiverId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
        self.receiverId = receiverId
    }

    /// Get open RFI for receiver
    ///
    /// Retrieves the current open Request for Information (RFI) for the specified receiver.
    ///
    /// - Returns: The open RFI if one exists
    /// - Throws: `BlindPayError` if the request fails
    public func get() async throws -> APIResponse<RfiResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/rfi",
            method: .get
        )
    }

    /// Submit RFI response
    ///
    /// Submits a response to an open Request for Information (RFI).
    ///
    /// - Parameter data: The RFI response data to submit
    /// - Returns: Confirmation of submission
    /// - Throws: `BlindPayError` if the request fails
    public func submit(data: SubmitRfiInput) async throws -> APIResponse<SubmitRfiResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/receivers/\(receiverId)/rfi",
            method: .post,
            body: data
        )
    }
}