//
//  DecodeSafetyClientTests.swift
//  blindpay-swift
//
//  The same decode-safety fixtures, through the real service methods, so the
//  client's response handling (envelope vs bare array) is covered too.
//

import Foundation
import Testing
@testable import BlindPay

struct DecodeSafetyClientTests {
    @Test(arguments: ["full", "required_only", "nullables_null"])
    func payoutGet(variant: String) async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response("GET /v1/instances/{instance_id}/payouts/{id}", variant: variant)))
        let response = try await server.client.instances.payouts.get(payoutId: "po_000000000000")
        #expect(response.data != nil)
        #expect(server.requests.first?.path == "/v1/instances/in_000000000000/payouts/po_000000000000")
    }

    @Test(arguments: ["required_only.b0", "nullables_null.b0", "required_only.b1", "nullables_null.b1"])
    func payoutList(variant: String) async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response("GET /v1/instances/{instance_id}/payouts", variant: variant)))
        let response = try await server.client.instances.payouts.list()
        #expect(response.data?.isEmpty == false)
    }

    @Test(arguments: ["full", "required_only", "nullables_null"])
    func virtualAccountGet(variant: String) async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response("GET /v1/instances/{instance_id}/customers/{customer_id}/virtual-accounts/{id}", variant: variant)))
        let customer = server.client.customers(customerId: "cu_000000000000")
        let response = try await customer.virtualAccounts.get(customerId: "cu_000000000000", id: "va_000000000000")
        #expect(response.data != nil)
    }

    @Test(arguments: ["full", "required_only", "nullables_null"])
    func partnerFeeList(variant: String) async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response("GET /v1/instances/{instance_id}/partner-fees", variant: variant)))
        let response = try await server.client.instances.partnerFees.list()
        #expect(response.data?.isEmpty == false)
    }

    @Test(arguments: ["full", "required_only", "nullables_null"])
    func swiftCode(variant: String) async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response("GET /v1/available/swift/{swift}", variant: variant)))
        let response = try await server.client.available.getSwiftCode(swift: "BOFAUS3N")
        #expect(response.data?.isEmpty == false)
    }
}
