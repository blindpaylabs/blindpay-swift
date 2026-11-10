//
//  MultipartFormData.swift
//  blindpay-swift
//

import Foundation

/// Builds a `multipart/form-data` request body (RFC 7578).
struct MultipartFormData: Sendable {
    let boundary: String
    private var body = Data()

    init(boundary: String = "blindpay-\(UUID().uuidString.lowercased())") {
        self.boundary = boundary
    }

    /// The `Content-Type` header value, including the boundary.
    var contentType: String { "multipart/form-data; boundary=\(boundary)" }

    /// Adds a plain text field.
    mutating func addField(name: String, value: String) {
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"\(Self.escapedForQuotedParameter(name))\"\r\n\r\n")
        append(value)
        append("\r\n")
    }

    /// Adds a file part.
    mutating func addFile(name: String, fileName: String, contentType: String, data: Data) {
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"\(Self.escapedForQuotedParameter(name))\"; filename=\"\(Self.escapedForQuotedParameter(fileName))\"\r\n")
        append("Content-Type: \(Self.headerSafe(contentType))\r\n\r\n")
        body.append(data)
        append("\r\n")
    }

    /// The complete body, closed with the final boundary.
    func encoded() -> Data {
        var data = body
        data.append(Data("--\(boundary)--\r\n".utf8))
        return data
    }

    private mutating func append(_ string: String) {
        body.append(Data(string.utf8))
    }

    /// Escapes a value for a quoted Content-Disposition parameter: `"` is
    /// percent-encoded, as browsers do (RFC 7578 §4.2).
    private static func escapedForQuotedParameter(_ value: String) -> String {
        headerSafe(value).replacingOccurrences(of: "\"", with: "%22")
    }

    /// Drops CR/LF so a value cannot inject extra header lines.
    private static func headerSafe(_ value: String) -> String {
        value.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n", with: "")
    }
}
