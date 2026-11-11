//
//  OpenEnumTests.swift
//  blindpay-swift
//
//  Every SDK enum accepts values it doesn't know.
//

import Foundation
import Testing
@testable import BlindPay

struct OpenEnumTests {
    @Test func unknownValuesDecodeAndRoundTrip() throws {
        let decoded = try JSONDecoder().decode([Network].self, from: Data(#"["base","zz_future_chain"]"#.utf8))
        #expect(decoded == [.base, Network(rawValue: "zz_future_chain")])
        #expect(String(decoding: try JSONEncoder().encode(decoded), as: UTF8.self) == #"["base","zz_future_chain"]"#)
    }

    @Test func knownValuesMatchInASwitch() {
        func label(_ status: PayoutStatus) -> String {
            switch status {
            case .completed: return "done"
            case .failed: return "failed"
            default: return "other:\(status)"
            }
        }
        #expect(label(.completed) == "done")
        #expect(label("zz_new") == "other:zz_new")
    }

    @Test func aResponseWithAnUnknownEnumStillDecodes() throws {
        let data = try Fixtures.response("GET /v1/instances/{instance_id}/payouts/{id}", variant: "unknown_enum")
        let payout = try JSONDecoder().decode(Payout.self, from: data)
        #expect(payout.status.rawValue == "zz_unknown_value_from_future_api")
    }
}
