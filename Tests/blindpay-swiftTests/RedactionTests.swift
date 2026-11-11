//
//  RedactionTests.swift
//  blindpay-swift
//
//  The API key never appears in dumps, mirrors, descriptions or errors.
//

import Foundation
import Testing
@testable import BlindPay

struct RedactionTests {
    private let key = "sk_live_should_never_leak"

    @Test func theClientNeverPrintsItsKey() {
        let client = BlindPay(apiKey: key, instanceId: "in_000000000000")
        var dumped = ""
        dump(client, to: &dumped)
        var dumpedService = ""
        dump(client.instances.payouts, to: &dumpedService)
        for text in [dumped, dumpedService, String(describing: client), String(reflecting: client), "\(Mirror(reflecting: client).children.map { "\($0)" })"] {
            #expect(!text.contains(key))
        }
        #expect(String(describing: client).contains("<redacted>"))
    }

    @Test func errorsDontCarryTheKeyOrTheBody() async throws {
        let server = MockServer(respondWith: .status(500))
        let response = try await server.client.instances.quotes.getFxRate(data: GetFxRateInput(currencyType: .sender, from: .usdc, to: .brl, requestAmount: 1000))
        let error = try #require(response.error)
        let text = "\(error) \(error.localizedDescription) \(String(reflecting: error))"
        #expect(!text.contains("test_key"))
        #expect(!text.contains("request_amount"))
    }
}
