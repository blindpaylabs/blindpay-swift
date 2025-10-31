//
//  APIClient.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

/// API client for making network requests
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
internal final class APIClient: Sendable {
    private let apiKey: String
    private let instanceId: String
    private let configuration: Configuration
    private let session: URLSession
    
    init(apiKey: String, instanceId: String, configuration: Configuration) {
        self.apiKey = apiKey
        self.instanceId = instanceId
        self.configuration = configuration
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "X-API-Key": apiKey,
            "X-Instance-Id": instanceId
        ]
        
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: (any Codable)? = nil
    ) async throws -> APIResponse<T> {
        guard let url = URL(string: "\(configuration.baseURL)\(endpoint)") else {
            throw BlindPayError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BlindPayError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        
        if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
            return try decoder.decode(APIResponse<T>.self, from: data)
        } else {
            if let errorResponse = try? decoder.decode(APIResponse<EmptyResponse>.self, from: data) {
                return APIResponse<T>(data: nil, error: errorResponse.error)
            } else {
                throw BlindPayError.httpError(statusCode: httpResponse.statusCode)
            }
        }
    }
}

/// HTTP methods
internal enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// Empty codable type for error-only responses
private struct EmptyResponse: Codable, Sendable {}

