//
//  OnboardingService.swift
//  blindpay-swift
//

import Foundation

/// Read the instance's own onboarding answers. Instance-scoped.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class OnboardingService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String

    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }

    /// Retrieves the business details step.
    public func getBusinessDetails(options: RequestOptions? = nil) async throws -> APIResponse<BusinessDetails> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/onboarding/business_details",
            method: .get,
            options: options
        )
    }

    /// Retrieves the business profile step.
    public func getBusinessProfile(options: RequestOptions? = nil) async throws -> APIResponse<BusinessProfile> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/onboarding/business_profile",
            method: .get,
            options: options
        )
    }

    /// Retrieves the ownership documents step.
    public func getOwnershipDocuments(options: RequestOptions? = nil) async throws -> APIResponse<OwnershipDocuments> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/onboarding/ownership_documents",
            method: .get,
            options: options
        )
    }
}
