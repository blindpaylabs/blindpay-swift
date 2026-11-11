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

struct NaicsRequestTests {
    @Test func getNaicsCodesDecodesLabelAndValue() async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response("GET /v1/available/naics", variant: "full")))
        let viaService = try await server.client.available.getNaicsCodes()
        let viaFacade = try await server.client.getNaicsCodes()

        let first = try #require(viaService.data?.first)
        #expect(first.value == "339910")
        #expect(first.label == "(339910) Jewelry and Silverware Manufacturing")
        #expect(viaFacade.data == viaService.data)
        #expect(server.requests.map(\.path) == ["/v1/available/naics", "/v1/available/naics"])
        #expect(server.requests.allSatisfy { $0.method == "GET" })
    }
}
