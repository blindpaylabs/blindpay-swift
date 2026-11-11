//
//  InputEncodingTests.swift
//  blindpay-swift
//
//  Inputs send only the keys that are set (absent, not null), using the
//  synthesized Codable conformance.
//

import Foundation
import Testing
@testable import BlindPay

private func keys<T: Encodable>(_ value: T) throws -> [String: Any] {
    try JSONSerialization.jsonObject(with: JSONEncoder().encode(value)) as? [String: Any] ?? [:]
}

struct InputEncodingTests {
    @Test func bankAccountInputSendsOnlyTheSetKeys() throws {
        let body = try keys(CreateBankAccountInput(name: "n", type: .pix, pixKey: "k"))
        #expect(Set(body.keys) == ["name", "type", "pix_key"])
        #expect(body["pix_key"] as? String == "k")
    }

    @Test func fxAndPayinQuoteInputsSendCentsAndOnlyTheSetKeys() throws {
        let fx = try keys(GetFxRateInput(currencyType: .sender, from: .usdc, to: .brl, requestAmount: 1999))
        #expect(Set(fx.keys) == ["currency_type", "from", "to", "request_amount"])
        #expect(fx["request_amount"] as? Int == 1999)
        let quote = try keys(CreatePayinQuoteInput(currencyType: .sender, requestAmount: 1000, paymentMethod: .pix, token: .usdc))
        #expect(Set(quote.keys) == ["currency_type", "request_amount", "payment_method", "token"])
    }
}
