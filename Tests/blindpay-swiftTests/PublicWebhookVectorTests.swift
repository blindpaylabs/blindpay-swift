//
//  PublicWebhookVectorTests.swift
//  blindpay-swift
//
//  The 14 shared Svix vectors through the PUBLIC API only: this file imports
//  BlindPay without @testable, so it compiles only against what a package
//  consumer can call. Each vector is checked at its own `now`.
//

import BlindPay
import Foundation
import Testing

private struct PublicVector: Decodable, Sendable, CustomStringConvertible {
    let name: String
    let secret: String
    let headers: [String: String]
    let payload: String
    let now: Double
    let expect: String
    let event: String?

    var description: String { name }
}

private struct PublicVectorFile: Decodable {
    let tolerance_seconds: Double
    let vectors: [PublicVector]
}

private let publicVectors: PublicVectorFile = {
    let url = Bundle.module.url(forResource: "Vectors/webhook-vectors", withExtension: "json")
        ?? Bundle.module.url(forResource: "webhook-vectors", withExtension: "json", subdirectory: "Vectors")!
    return try! JSONDecoder().decode(PublicVectorFile.self, from: Data(contentsOf: url))
}()

struct PublicWebhookVectorTests {
    @Test func allFourteenVectorsAreCovered() {
        #expect(publicVectors.vectors.count == 14)
        #expect(publicVectors.tolerance_seconds == Webhooks.defaultTolerance)
    }

    @Test(arguments: publicVectors.vectors)
    fileprivate func verifyAtTheVectorsClock(_ vector: PublicVector) {
        let now = Date(timeIntervalSince1970: vector.now)
        let valid = vector.expect == "valid"
        #expect(Webhooks.verify(payload: Data(vector.payload.utf8), headers: vector.headers, secret: vector.secret, now: now) == valid)
        #expect(Webhooks.verify(payload: vector.payload, headers: vector.headers, secret: vector.secret, now: now) == valid)
    }

    @Test(arguments: publicVectors.vectors)
    fileprivate func constructEventAtTheVectorsClock(_ vector: PublicVector) throws {
        let now = Date(timeIntervalSince1970: vector.now)
        do {
            let event = try Webhooks.constructEvent(payload: vector.payload, headers: vector.headers, secret: vector.secret, now: now)
            #expect(vector.expect == "valid", "\(vector.name) verified but should not")
            if let name = vector.event { #expect(event.type.rawValue == name) }
        } catch BlindPayError.webhookVerificationFailed {
            #expect(vector.expect == "invalid", "\(vector.name) failed verification")
        } catch BlindPayError.decodingError {
            // The vector bodies are minimal signature inputs, not spec-complete
            // payloads: a verified known event may still fail typed decoding.
            #expect(vector.expect == "valid", "\(vector.name) decoded past a bad signature")
        }
    }

    @Test func aFractionalClockIsTruncatedToWholeSeconds() throws {
        let vector = try #require(publicVectors.vectors.first { $0.name == "invalid_timestamp_too_new_301s" })
        // 301 s ahead fails; at now + 1.9 s the gap is 299.1 s, truncated to 300 s: inside the tolerance.
        let shifted = Date(timeIntervalSince1970: vector.now + 1.9)
        #expect(!Webhooks.verify(payload: vector.payload, headers: vector.headers, secret: vector.secret, now: Date(timeIntervalSince1970: vector.now)))
        #expect(Webhooks.verify(payload: vector.payload, headers: vector.headers, secret: vector.secret, now: shifted))
    }
}
