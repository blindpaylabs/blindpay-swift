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

/// Serves every decode-safety variant of `operation` in turn and checks that
/// `call` returns data for each.
private func expectClientDecodes<T: Sendable>(
    _ operation: String,
    _ call: (BlindPay) async throws -> APIResponse<T>
) async throws {
    let variants = try Fixtures.variantNames(operation)
    #expect(!variants.isEmpty, "no decode-safety variants for \(operation)")
    for variant in variants {
        let server = MockServer(respondWith: .json(try Fixtures.response(operation, variant: variant)))
        do {
            let response = try await call(server.client)
            #expect(response.data != nil, "\(operation) [\(variant)] returned no data")
        } catch {
            Issue.record("\(operation) [\(variant)] failed: \(error)")
        }
    }
}

struct DecodeSafetyClientTests {
    @Test func payoutGet() async throws {
        try await expectClientDecodes("GET /v1/instances/{instance_id}/payouts/{id}") {
            try await $0.instances.payouts.get(payoutId: "po_000000000000")
        }
    }

    @Test func payoutList() async throws {
        try await expectClientDecodes("GET /v1/instances/{instance_id}/payouts") {
            try await $0.instances.payouts.list()
        }
    }

    @Test func virtualAccountGet() async throws {
        try await expectClientDecodes("GET /v1/instances/{instance_id}/customers/{customer_id}/virtual-accounts/{id}") {
            try await $0.customers(customerId: "cu_000000000000").virtualAccounts.get(id: "va_000000000000")
        }
    }

    @Test func partnerFeeList() async throws {
        try await expectClientDecodes("GET /v1/instances/{instance_id}/partner-fees") {
            try await $0.instances.partnerFees.list()
        }
    }

    @Test func swiftCode() async throws {
        try await expectClientDecodes("GET /v1/available/swift/{swift}") {
            try await $0.available.getSwiftCode(swift: "BOFAUS3N")
        }
    }

    @Test func createPayinQuote() async throws {
        let input = CreatePayinQuoteInput(currencyType: .sender, requestAmount: 10, paymentMethod: .pix, token: .usdc)
        try await expectClientDecodes("POST /v1/instances/{instance_id}/payin-quotes") {
            try await $0.instances.payins.quotes.create(data: input)
        }
    }

    @Test func upload() async throws {
        let input = UploadInput(file: Data("x".utf8), fileName: "a.txt", contentType: "text/plain", bucket: .documents)
        try await expectClientDecodes("POST /v1/upload") {
            try await $0.upload.create(data: input)
        }
    }

    @Test func naics() async throws {
        try await expectClientDecodes("GET /v1/available/naics") {
            try await $0.available.getNaicsCodes()
        }
    }
}
