//
//  AmountTests.swift
//  blindpay-swift
//
//  Amount inputs are integer cents. Amount.cents(fromMajorUnits:) converts
//  a major-unit value without truncating: 19.99 is 1999, not 1998.
//

import Foundation
import Testing
@testable import BlindPay

struct AmountTests {
    @Test(arguments: [
        (19.99, 1999),
        (0.29, 29),
        (1.005, 101),
        (10.0, 1000),
        (0.1 + 0.2, 30),
        (5.0, 500),
        (1234.56, 123456),
        (-19.99, -1999),
        (0.0, 0),
        // Values whose description uses exponent notation ("5e-05", "1e+16").
        (0.00005, 0),
        (0.005, 1),
        (1e16, 1_000_000_000_000_000_000),
        (1.5e3, 150_000),
    ])
    func convertsMajorUnitsToRoundedCents(dollars: Double, cents: Int) throws {
        #expect(try Amount.cents(fromMajorUnits: dollars) == cents)
    }

    @Test func rejectsNonFiniteAmountsInsteadOfTrapping() {
        #expect(throws: EncodingError.self) { try Amount.cents(fromMajorUnits: .nan) }
        #expect(throws: EncodingError.self) { try Amount.cents(fromMajorUnits: .infinity) }
        #expect(throws: EncodingError.self) { try Amount.cents(fromMajorUnits: 1e300) }
    }

    @Test func createQuoteSendsIntegerCentsAndOnlyTheSpecFields() async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response("POST /v1/instances/{instance_id}/quotes", variant: "full")))
        let input = CreateQuoteInput(
            bankAccountId: "ba_000000000000",
            currencyType: .sender,
            network: .base,
            requestAmount: try Amount.cents(fromMajorUnits: 19.99),
            token: .usdc
        )
        _ = try await server.client.instances.quotes.create(data: input)

        let request = try #require(server.requests.first)
        #expect(request.method == "POST")
        #expect(request.path == "/v1/instances/in_000000000000/quotes")
        let body = try request.jsonBody()
        #expect(body["request_amount"] as? Int == 1999)
        #expect(Set(body.keys) == ["bank_account_id", "currency_type", "network", "request_amount", "token"])
    }

    @Test func aPayableQuoteSendsOnlyThePayable() throws {
        let input = CreateQuoteInput(payableId: "pb_000000000000", network: .base, token: .usdc)
        let body = try JSONSerialization.jsonObject(with: JSONEncoder().encode(input)) as? [String: Any]
        #expect(body?["payable_id"] as? String == "pb_000000000000")
        #expect(body?["bank_account_id"] == nil)
        #expect(body?["request_amount"] == nil)
    }

    @Test func fxRateInputSendsCents() throws {
        let input = GetFxRateInput(currencyType: .sender, from: .usdc, to: .brl, requestAmount: 1999)
        let body = try JSONSerialization.jsonObject(with: JSONEncoder().encode(input)) as? [String: Any]
        #expect(body?["request_amount"] as? Int == 1999)
    }
}
