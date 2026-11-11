//
//  UploadService.swift
//  blindpay-swift
//

import Foundation

/// Service for uploading files
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class UploadService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String

    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }

    /// Uploads a file to the specified bucket
    ///
    /// Sends the file as `multipart/form-data` (parts `file` and `bucket`) to
    /// `POST /v1/upload?instance_id=<your instance>`. The API key is checked
    /// against that instance, and the instance must have finished onboarding.
    ///
    /// - Parameter data: The file bytes, file name, content type and bucket
    /// - Returns: An `APIResponse` containing the uploaded file's URL
    /// - Throws: `BlindPayError` if the request fails
    ///
    /// Example:
    /// ```swift
    /// let pdf = try Data(contentsOf: URL(fileURLWithPath: "passport.pdf"))
    /// let input = UploadInput(file: pdf, fileName: "passport.pdf", contentType: "application/pdf", bucket: .onboarding)
    /// let response = try await blindPay.upload.create(data: input)
    /// if let result = response.data {
    ///     print("Uploaded file URL: \(result.fileUrl)")
    /// }
    /// ```
    public func create(data: UploadInput, options: RequestOptions? = nil) async throws -> APIResponse<UploadResponse> {
        var form = MultipartFormData()
        form.addFile(name: "file", fileName: data.fileName, contentType: data.contentType, data: data.file)
        form.addField(name: "bucket", value: data.bucket.rawValue)
        return try await apiClient.requestMultipart(
            endpoint: "/v1/upload",
            method: .post,
            form: form,
            queryParameters: ["instance_id": instanceId],
            options: options
        )
    }

    /// Checks a document before you submit it and rates how likely
    /// compliance is to approve it. Sent as `multipart/form-data` to
    /// `POST /v1/upload/analyze?instance_id=<your instance>`; never retried.
    public func analyze(data: UploadAnalyzeInput, options: RequestOptions? = nil) async throws -> APIResponse<UploadAnalyzeResponse> {
        var form = MultipartFormData()
        form.addFile(name: "file", fileName: data.fileName, contentType: data.contentType, data: data.file)
        form.addField(name: "type", value: data.type.rawValue)
        if let metadata = data.metadata {
            let json = try JSONSerialization.data(withJSONObject: metadata, options: [.sortedKeys])
            form.addField(name: "metadata", value: String(decoding: json, as: UTF8.self))
        }
        return try await apiClient.requestMultipart(
            endpoint: "/v1/upload/analyze",
            method: .post,
            form: form,
            queryParameters: ["instance_id": instanceId],
            options: options
        )
    }

    /// Returns a temporary signed URL for a file you uploaded (`fileUrl` from
    /// ``create(data:options:)``).
    public func presign(fileUrl: String, options: RequestOptions? = nil) async throws -> APIResponse<PresignResponse> {
        return try await apiClient.request(
            endpoint: "/v1/presign",
            method: .post,
            body: PresignInput(fileUrl: fileUrl),
            queryParameters: ["instance_id": instanceId],
            options: options
        )
    }
}
