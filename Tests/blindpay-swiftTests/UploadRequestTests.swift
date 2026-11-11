//
//  UploadRequestTests.swift
//  blindpay-swift
//
//  POST /v1/upload only accepts multipart/form-data (blindpay-v2
//  modules/uploads/endpoints/post.upload.ts reads c.req.valid('form')).
//

import Foundation
import Testing
@testable import BlindPay

struct UploadRequestTests {
    private let fileBytes = Data([0x25, 0x50, 0x44, 0x46, 0x2D, 0x00, 0xFF, 0x0D, 0x0A])

    private var input: UploadInput {
        UploadInput(file: fileBytes, fileName: "passport.pdf", contentType: "application/pdf", bucket: .documents)
    }

    @Test func uploadSendsMultipartWithInstanceIdAndDecodesFileUrl() async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response("POST /v1/upload", variant: "full")))
        let response = try await server.client.upload.create(data: input)

        #expect(response.data?.fileUrl.isEmpty == false)

        let request = try #require(server.requests.first)
        #expect(request.method == "POST")
        #expect(request.path == "/v1/upload")
        #expect(request.queryItems == [URLQueryItem(name: "instance_id", value: "in_000000000000")])

        let contentType = try #require(request.header("Content-Type"))
        #expect(contentType.hasPrefix("multipart/form-data; boundary="))
        let boundary = String(contentType.dropFirst("multipart/form-data; boundary=".count))

        let parts = try MultipartParts(body: request.body, boundary: boundary)
        #expect(parts.count == 2)
        let file = try #require(parts.part(named: "file"))
        #expect(file.headers["Content-Disposition"] == "form-data; name=\"file\"; filename=\"passport.pdf\"")
        #expect(file.headers["Content-Type"] == "application/pdf")
        #expect(file.body == fileBytes)
        let bucket = try #require(parts.part(named: "bucket"))
        #expect(String(decoding: bucket.body, as: UTF8.self) == "documents")
    }

    @Test func facadeDelegatesToTheUploadService() async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response("POST /v1/upload", variant: "required_only")))
        let response = try await server.client.createUpload(data: input)

        #expect(response.data?.fileUrl.isEmpty == false)
        #expect(server.requests.first?.path == "/v1/upload")
        #expect(server.requests.first?.header("Content-Type")?.hasPrefix("multipart/form-data") == true)
    }

    @Test func fileNameCannotBreakOutOfTheHeader() throws {
        var form = MultipartFormData(boundary: "b")
        form.addFile(name: "file", fileName: "a\"b\r\nX-Evil: 1.pdf", contentType: "text/plain", data: Data("x".utf8))
        let parts = try MultipartParts(body: form.encoded(), boundary: "b")
        let file = try #require(parts.part(named: "file"))
        #expect(file.headers["Content-Disposition"] == "form-data; name=\"file\"; filename=\"a%22bX-Evil: 1.pdf\"")
        #expect(file.headers["X-Evil"] == nil)
    }
}

/// Minimal multipart/form-data parser for assertions.
private struct MultipartParts {
    struct Part {
        let headers: [String: String]
        let body: Data

        var name: String? {
            guard let disposition = headers["Content-Disposition"],
                  let range = disposition.range(of: "name=\"") else { return nil }
            let rest = disposition[range.upperBound...]
            return rest.firstIndex(of: "\"").map { String(rest[..<$0]) }
        }
    }

    struct Malformed: Error {}

    let parts: [Part]
    var count: Int { parts.count }

    init(body: Data, boundary: String) throws {
        let delimiter = Data("--\(boundary)".utf8)
        let crlf = Data("\r\n".utf8)
        let headerEnd = Data("\r\n\r\n".utf8)
        var parts: [Part] = []
        var cursor = body.startIndex
        guard let first = body.range(of: delimiter, in: cursor..<body.endIndex) else { throw Malformed() }
        cursor = first.upperBound
        while true {
            // After a delimiter: "--" closes the body, CRLF starts a part.
            if body[cursor...].starts(with: Data("--".utf8)) { break }
            guard body[cursor...].starts(with: crlf) else { throw Malformed() }
            cursor += crlf.count
            guard let next = body.range(of: delimiter, in: cursor..<body.endIndex),
                  let split = body.range(of: headerEnd, in: cursor..<next.lowerBound) else { throw Malformed() }
            var headers: [String: String] = [:]
            for line in String(decoding: body[cursor..<split.lowerBound], as: UTF8.self).components(separatedBy: "\r\n") {
                guard let colon = line.firstIndex(of: ":") else { continue }
                headers[String(line[..<colon])] = line[line.index(after: colon)...].trimmingCharacters(in: .whitespaces)
            }
            // The part body ends with the CRLF that precedes the next delimiter.
            let partBody = body[split.upperBound..<(next.lowerBound - crlf.count)]
            parts.append(Part(headers: headers, body: Data(partBody)))
            cursor = next.upperBound
        }
        self.parts = parts
    }

    func part(named name: String) -> Part? {
        parts.first { $0.name == name }
    }
}
