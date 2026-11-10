//
//  MockHarnessTests.swift
//  blindpay-swift
//

import Foundation
import Testing
@testable import BlindPay

struct MockHarnessTests {
    @Test func routesRequestsThroughTheMockAndRecordsThem() async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response("GET /v1/available/rails", variant: "full")))
        let response = try await server.client.available.getRails()

        #expect(response.data?.isEmpty == false)
        let request = try #require(server.requests.first)
        #expect(server.requests.count == 1)
        #expect(request.method == "GET")
        #expect(request.path == "/v1/available/rails")
    }
}
