//
//  FixtureDecodingTests.swift
//  blindpay-swift
//
//  Decode-safety tests against the shared spec-shaped fixtures. Every
//  response type touched by a fix must decode the `full`, `required_only` and
//  `nullables_null` variants: a non-optional SDK field that is absent in
//  `required_only` or `null` in `nullables_null` is a bug.
//

import Foundation
import Testing
@testable import BlindPay

/// The list envelope the API returns when a cursor or limit is sent (D3).
private struct ListEnvelope<Item: Decodable>: Decodable {
    let data: [Item]
}

/// Decodes one fixture variant straight into the model. Lists decode both the
/// `.b0` envelope and the `.b1` bare array into `[Item]`.
private func decodeVariant<Item: Decodable>(_ type: Item.Type, operation: String, variant: String, isList: Bool) throws {
    let data = try Fixtures.response(operation, variant: variant)
    let decoder = JSONDecoder()
    if !isList {
        _ = try decoder.decode(Item.self, from: data)
    } else if variant.hasSuffix(".b0") {
        _ = try decoder.decode(ListEnvelope<Item>.self, from: data)
    } else {
        _ = try decoder.decode([Item].self, from: data)
    }
}

/// Runs every decode-safety variant of `operation` and reports each failing
/// variant with the decoder's own error (which names the failing field).
private func expectDecodes<Item: Decodable>(_ type: Item.Type, _ operation: String, isList: Bool = false) throws {
    let variants = try Fixtures.variantNames(operation)
    #expect(!variants.isEmpty, "no decode-safety variants found for \(operation)")
    for variant in variants {
        do {
            try decodeVariant(type, operation: operation, variant: variant, isList: isList)
        } catch {
            Issue.record("\(operation) [\(variant)] failed to decode as \(Item.self): \(error)")
        }
    }
}

struct FixtureDecodingTests {
    // MARK: Payin quotes

    @Test func createPayinQuoteResponse() throws {
        try expectDecodes(CreatePayinQuoteResponse.self, "POST /v1/instances/{instance_id}/payin-quotes")
    }

    // MARK: Upload

    @Test func uploadResponse() throws {
        try expectDecodes(UploadResponse.self, "POST /v1/upload")
    }

    // MARK: Available

    @Test func naicsCodes() throws {
        try expectDecodes(NaicsCode.self, "GET /v1/available/naics", isList: true)
    }

    // MARK: Payins (PayinTrackingPayment.reviewContexts)

    @Test func payin() throws {
        try expectDecodes(Payin.self, "GET /v1/instances/{instance_id}/payins/{id}")
    }

    @Test func payinTrack() throws {
        try expectDecodes(Payin.self, "GET /v1/e/payins/{id}")
    }

    @Test func payinList() throws {
        try expectDecodes(Payin.self, "GET /v1/instances/{instance_id}/payins", isList: true)
    }

    @Test func payinReviewContextsAcceptsNestedJSON() throws {
        // review_contexts is a free-form object per risk source; real values are
        // nested objects, which the old [String: String] type rejected.
        let json = """
        {"step":"pending_review","review_contexts":{"seon_review":{"score":87.5,"rules":["r1","r2"],"blocked":false},"new_instance":null}}
        """
        let decoded = try JSONDecoder().decode(PayinTrackingPayment.self, from: Data(json.utf8))
        let again = try JSONDecoder().decode(PayinTrackingPayment.self, from: Data(json.utf8))
        let seon = try #require(decoded.reviewContexts?["seon_review"]?.value as? [String: Any])
        #expect(seon["score"] as? Double == 87.5)
        #expect(seon["rules"] as? [String] == ["r1", "r2"])
        #expect(decoded == again)

        let roundTrip = try JSONDecoder().decode(PayinTrackingPayment.self, from: JSONEncoder().encode(decoded))
        #expect(roundTrip == decoded)
    }
}
