//
//  UploadService.swift
//  blindpay-swift
//

import Foundation

/// Service for uploading files
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class UploadService: Sendable {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    /// Uploads a file to the specified bucket
    ///
    /// This method uploads a file and returns the URL of the uploaded file.
    ///
    /// - Parameter data: The input data containing the bucket and file
    /// - Returns: An `APIResponse` containing the upload URL
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let input = UploadInput(bucket: .onboarding, file: "base64encodedfile...")
    /// let response = try await blindPay.upload.create(data: input)
    /// if let result = response.data {
    ///     print("Uploaded file URL: \(result.url)")
    /// }
    /// ```
    public func create(data: UploadInput) async throws -> APIResponse<UploadResponse> {
        return try await apiClient.request(
            endpoint: "/v1/upload",
            method: .post,
            body: data
        )
    }
}
