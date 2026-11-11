//
//  RequestOptionsGuardTests.swift
//  blindpay-swift
//
//  Every public API method must accept `options: RequestOptions?` and forward
//  it, so idempotency keys, timeouts and headers reach the wire (plan C2;
//  mirrors blindpay-node's request-options.test.ts). Scans the sources.
//

import Foundation
import Testing

struct RequestOptionsGuardTests {
    private static var sourcesRoot: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()  // blindpay-swiftTests
            .deletingLastPathComponent()  // Tests
            .deletingLastPathComponent()  // package root
            .appendingPathComponent("Sources/BlindPay")
    }

    private struct Method {
        let file: String
        let name: String
        let parameters: String
        let body: String
    }

    private static func apiMethods() throws -> [Method] {
        let files = try FileManager.default.contentsOfDirectory(atPath: sourcesRoot.appendingPathComponent("Services").path)
            .filter { $0.hasSuffix(".swift") }
            .map { "Services/\($0)" } + ["Core/BlindPay.swift"]
        let signature = try NSRegularExpression(pattern: #"public func (\w+)\(([^()]*(?:\(\)[^()]*)*)\)\s*(?:async throws -> APIResponse<|-> AsyncThrowingStream<)"#)
        var methods: [Method] = []
        for file in files {
            let text = try String(contentsOf: sourcesRoot.appendingPathComponent(file), encoding: .utf8)
            let ns = text as NSString
            for match in signature.matches(in: text, range: NSRange(location: 0, length: ns.length)) {
                let name = ns.substring(with: match.range(at: 1))
                let parameters = ns.substring(with: match.range(at: 2))
                // Body: from the next "{" to its matching "}".
                let afterSignature = match.range.location + match.range.length
                let open = ns.range(of: "{", options: [], range: NSRange(location: afterSignature, length: ns.length - afterSignature)).location
                var depth = 0
                var end = open
                for index in open..<ns.length {
                    let char = ns.character(at: index)
                    if char == 123 { depth += 1 }          // {
                    if char == 125 { depth -= 1; if depth == 0 { end = index; break } } // }
                }
                methods.append(Method(file: file, name: name, parameters: parameters,
                                      body: ns.substring(with: NSRange(location: open, length: end - open + 1))))
            }
        }
        return methods
    }

    @Test func everyAPIMethodAcceptsAndForwardsRequestOptions() throws {
        let methods = try Self.apiMethods()
        #expect(methods.count > 100, "scanner found only \(methods.count) methods; is the pattern stale?")
        for method in methods {
            #expect(method.parameters.contains("options: RequestOptions? = nil"),
                    "\(method.file) \(method.name) has no `options: RequestOptions? = nil` parameter")
            #expect(method.body.contains("options: options"),
                    "\(method.file) \(method.name) does not forward its options")
        }
    }
}
