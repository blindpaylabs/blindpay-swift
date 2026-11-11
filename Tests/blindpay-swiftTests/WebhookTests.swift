//
//  WebhookTests.swift
//  blindpay-swift
//
//  The 14 shared Svix vectors (plan C6, D20) and typed decoding of every
//  webhook fixture.
//

import Foundation
import Testing
@testable import BlindPay

private struct Vector: Decodable, Sendable, CustomStringConvertible {
    let name: String
    let secret: String
    let headers: [String: String]
    let payload: String
    let now: Double
    let expect: String
    let event: String?

    var description: String { name }
}

private struct VectorFile: Decodable {
    let toleranceSeconds: Double
    let vectors: [Vector]

    enum CodingKeys: String, CodingKey {
        case toleranceSeconds = "tolerance_seconds"
        case vectors
    }
}

private let vectorFile: VectorFile = {
    let url = Bundle.module.url(forResource: "Vectors/webhook-vectors", withExtension: "json")
        ?? Bundle.module.url(forResource: "webhook-vectors", withExtension: "json", subdirectory: "Vectors")!
    return try! JSONDecoder().decode(VectorFile.self, from: Data(contentsOf: url))
}()

struct WebhookVectorTests {
    @Test func thereAreFourteenVectors() {
        #expect(vectorFile.vectors.count == 14)
    }

    @Test(arguments: vectorFile.vectors)
    fileprivate func verify(_ vector: Vector) {
        let result = Webhooks.verify(payload: Data(vector.payload.utf8), headers: vector.headers, secret: vector.secret,
                                     tolerance: vectorFile.toleranceSeconds, now: Date(timeIntervalSince1970: vector.now))
        #expect(result == (vector.expect == "valid"), "\(vector.name)")
    }

    @Test(arguments: vectorFile.vectors)
    fileprivate func constructEvent(_ vector: Vector) throws {
        let now = Date(timeIntervalSince1970: vector.now)
        if vector.expect == "valid" {
            // The vector bodies are minimal signature inputs, not spec-complete
            // payloads, so a known event may fail to decode; it must never
            // fail verification.
            do {
                let event = try Webhooks.constructEvent(payload: Data(vector.payload.utf8), headers: vector.headers, secret: vector.secret,
                                                        tolerance: vectorFile.toleranceSeconds, now: now)
                #expect(event.type.rawValue == vector.event)
            } catch BlindPayError.decodingError {
                #expect(WebhookEventType(rawValue: vector.event ?? "") != "zz.future_event")
            }
        } else {
            #expect(throws: BlindPayError.self) {
                try Webhooks.constructEvent(payload: Data(vector.payload.utf8), headers: vector.headers, secret: vector.secret,
                                            tolerance: vectorFile.toleranceSeconds, now: now)
            }
        }
    }

    @Test func headersAreCaseInsensitiveAndWebhookAliasesWork() throws {
        let vector = try #require(vectorFile.vectors.first { $0.name == "valid" })
        let now = Date(timeIntervalSince1970: vector.now)
        let upper = Dictionary(uniqueKeysWithValues: vector.headers.map { ($0.key.uppercased(), $0.value) })
        let aliases = Dictionary(uniqueKeysWithValues: vector.headers.map { ($0.key.replacingOccurrences(of: "svix-", with: "webhook-"), $0.value) })
        #expect(Webhooks.verify(payload: Data(vector.payload.utf8), headers: upper, secret: vector.secret, tolerance: 300, now: now))
        #expect(Webhooks.verify(payload: Data(vector.payload.utf8), headers: aliases, secret: vector.secret, tolerance: 300, now: now))
    }

    @Test func aSecretWithoutThePrefixAndABadSecretAreHandled() throws {
        let vector = try #require(vectorFile.vectors.first { $0.name == "valid" })
        let now = Date(timeIntervalSince1970: vector.now)
        let bare = String(vector.secret.dropFirst("whsec_".count))
        #expect(Webhooks.verify(payload: Data(vector.payload.utf8), headers: vector.headers, secret: bare, tolerance: 300, now: now))
        #expect(!Webhooks.verify(payload: Data(vector.payload.utf8), headers: vector.headers, secret: "whsec_!!not base64!!", tolerance: 300, now: now))
        #expect(!Webhooks.verify(payload: Data(vector.payload.utf8), headers: vector.headers, secret: "", tolerance: 300, now: now))
    }

    @Test func thePublicStringOverloadUsesTheSystemClock() throws {
        let vector = try #require(vectorFile.vectors.first { $0.name == "valid" })
        // The vector's timestamp is in the past, so with the real clock it's expired.
        #expect(!Webhooks.verify(payload: vector.payload, headers: vector.headers, secret: vector.secret))
        #expect(throws: BlindPayError.self) {
            try Webhooks.constructEvent(payload: vector.payload, headers: vector.headers, secret: vector.secret)
        }
    }
}

struct WebhookEventDecodingTests {
    private static var webhookFiles: [String] {
        let index = try! Fixtures.json(at: Fixtures.root.appendingPathComponent("index.json"))
        return (index["webhooks"] as! [String: String]).keys.filter { !$0.hasPrefix("_") }.sorted()
    }

    @Test(arguments: webhookFiles)
    func everyVariantDecodesToItsTypedCase(event: String) throws {
        let file = try Fixtures.json(at: Fixtures.root.appendingPathComponent("webhooks/\(event).json"))
        let variants = try #require(file["variants"] as? [String: Any])
        #expect(variants.count >= 5)
        for (variant, body) in variants.sorted(by: { $0.key < $1.key }) {
            let data = try JSONSerialization.data(withJSONObject: body)
            do {
                let decoded = try WebhookEvent.decode(from: data)
                #expect(decoded.type.rawValue == event, "\(event) [\(variant)]")
                if case .unknown = decoded { Issue.record("\(event) [\(variant)] fell back to .unknown") }
            } catch {
                Issue.record("\(event) [\(variant)] failed to decode: \(error)")
            }
        }
    }

    @Test func anUnknownEventKeepsItsRawJSON() throws {
        let file = try Fixtures.json(at: Fixtures.root.appendingPathComponent("webhooks/_unknown_event.json"))
        let body = try #require((file["variants"] as? [String: Any])?["full"])
        let data = try JSONSerialization.data(withJSONObject: body)
        guard case .unknown(let type, let payload) = try WebhookEvent.decode(from: data) else {
            Issue.record("expected .unknown"); return
        }
        #expect(type.rawValue == "zz.future_event")
        #expect(payload == data)
    }
}
