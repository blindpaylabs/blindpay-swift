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

/// The list envelope the API returns when a cursor or limit is sent.
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

    @Test func swiftCode() throws {
        try expectDecodes(SwiftCodeResponse.self, "GET /v1/available/swift/{swift}", isList: true)
    }

    // MARK: Payouts

    @Test func payout() throws {
        try expectDecodes(Payout.self, "GET /v1/instances/{instance_id}/payouts/{id}")
    }

    @Test func payoutTrack() throws {
        try expectDecodes(Payout.self, "GET /v1/e/payouts/{id}")
    }

    @Test func payoutList() throws {
        try expectDecodes(Payout.self, "GET /v1/instances/{instance_id}/payouts", isList: true)
    }

    // MARK: Virtual accounts

    @Test func virtualAccount() throws {
        try expectDecodes(VirtualAccount.self, "GET /v1/instances/{instance_id}/customers/{customer_id}/virtual-accounts/{id}")
    }

    @Test func virtualAccountList() throws {
        try expectDecodes(VirtualAccount.self, "GET /v1/instances/{instance_id}/customers/{customer_id}/virtual-accounts", isList: true)
    }

    @Test func createVirtualAccountResponse() throws {
        try expectDecodes(CreateVirtualAccountResponse.self, "POST /v1/instances/{instance_id}/customers/{customer_id}/virtual-accounts")
    }

    @Test func updateVirtualAccountResponse() throws {
        try expectDecodes(UpdateVirtualAccountResponse.self, "PUT /v1/instances/{instance_id}/customers/{customer_id}/virtual-accounts/{id}")
    }

    // MARK: Partner fees

    @Test func partnerFee() throws {
        try expectDecodes(PartnerFee.self, "GET /v1/instances/{instance_id}/partner-fees/{id}")
    }

    @Test func partnerFeeList() throws {
        try expectDecodes(PartnerFee.self, "GET /v1/instances/{instance_id}/partner-fees", isList: true)
    }

    @Test func createPartnerFeeResponse() throws {
        try expectDecodes(CreatePartnerFeeResponse.self, "POST /v1/instances/{instance_id}/partner-fees")
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

    @Test func createPayinResponse() throws {
        try expectDecodes(CreatePayinResponse.self, "POST /v1/instances/{instance_id}/payins/evm")
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

/// `review_reason` (round-2 spec drift) decodes on the limit-increase GET and
/// on both `limitIncrease.*` webhooks, and is `nil` when absent or null.
struct ReviewReasonDecodingTests {
    private static let listOperation = "GET /v1/instances/{instance_id}/customers/{customer_id}/limit-increase"

    private func listItems(_ variant: String) throws -> [LimitIncreaseRequest] {
        try JSONDecoder().decode([LimitIncreaseRequest].self, from: Fixtures.response(Self.listOperation, variant: variant))
    }

    private func webhook(_ event: String, _ variant: String) throws -> LimitIncreaseRequest {
        let file = try Fixtures.json(at: Fixtures.root.appendingPathComponent("webhooks/\(event).json"))
        let body = try #require((file["variants"] as? [String: Any])?[variant])
        switch try WebhookEvent.decode(from: JSONSerialization.data(withJSONObject: body)) {
        case .limitIncreaseNew(let request), .limitIncreaseUpdate(let request): return request
        default: throw Fixtures.Missing(description: "\(event) [\(variant)] did not decode to a limit-increase case")
        }
    }

    @Test func theGetCarriesReviewReason() throws {
        let full = try listItems("full")
        #expect(!full.isEmpty)
        for item in full {
            #expect(item.reviewReason?.isEmpty == false)
        }
        for item in try listItems("nullables_null") + listItems("required_only") {
            #expect(item.reviewReason == nil)
        }
    }

    @Test(arguments: ["limitIncrease.new", "limitIncrease.update"])
    func theWebhooksCarryReviewReason(event: String) throws {
        #expect(try webhook(event, "full").reviewReason?.isEmpty == false)
        #expect(try webhook(event, "nullables_null").reviewReason == nil)
        #expect(try webhook(event, "required_only").reviewReason == nil)
    }
}
