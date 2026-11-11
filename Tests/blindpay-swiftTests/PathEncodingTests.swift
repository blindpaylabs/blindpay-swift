//
//  PathEncodingTests.swift
//  blindpay-swift
//
//  Interpolated path segments are percent-encoded (plan C9, A8 item 1).
//

import Foundation
import Testing
@testable import BlindPay

struct PathEncodingTests {
    @Test func interpolatedSegmentsAreEncodedAndLiteralsKept() {
        let id = "a/b?c#d e;f"
        let endpoint: Endpoint = "/v1/instances/in_1/payouts/\(id)"
        #expect(endpoint.path == "/v1/instances/in_1/payouts/a%2Fb%3Fc%23d%20e%3Bf")
        let plain: Endpoint = "/v1/available/rails"
        #expect(plain.path == "/v1/available/rails")
    }

    @Test func aSlashInAnIdStaysInsideItsSegmentOnTheWire() async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response("GET /v1/instances/{instance_id}/payouts/{id}", variant: "full")))
        _ = try await server.client.instances.payouts.get(payoutId: "a/b")
        #expect(server.requests.first?.rawPath == "/v1/instances/in_000000000000/payouts/a%2Fb")
    }
}
