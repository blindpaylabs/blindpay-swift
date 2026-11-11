//
//  PaginationTests.swift
//  blindpay-swift
//
//  ListResult decodes both list shapes and the auto-pagers follow
//  `next_page` while `has_more` (D4, C5).
//

import Foundation
import Testing
@testable import BlindPay

/// An envelope page whose items are the `full` fixture item of `operation`
/// with the given ids.
private func page(_ ids: [String], hasMore: Bool, next: String?, of operation: String) -> MockResponse {
    let body = (try? Fixtures.response(operation, variant: "full.b0")) ?? (try! Fixtures.response(operation, variant: "full"))
    let fixture = try! JSONSerialization.jsonObject(with: body) as! [String: Any]
    let template = (fixture["data"] as! [[String: Any]])[0]
    let items = ids.map { id -> [String: Any] in var item = template; item["id"] = id; return item }
    var pagination: [String: Any] = ["has_more": hasMore]
    pagination["next_page"] = next ?? NSNull()
    pagination["prev_page"] = NSNull()
    return .json(try! JSONSerialization.data(withJSONObject: ["data": items, "pagination": pagination]))
}

private let transfersOp = "GET /v1/instances/{instance_id}/transfers"
private let payoutsOp = "GET /v1/instances/{instance_id}/payouts"
private let customersOp = "GET /v1/instances/{instance_id}/customers"

struct ListResultTests {
    private struct Item: Codable, Sendable, Equatable { let id: String }

    @Test func decodesTheBareArray() throws {
        let result = try JSONDecoder().decode(ListResult<Item>.self, from: Data(#"[{"id":"a"},{"id":"b"}]"#.utf8))
        #expect(result.data.map(\.id) == ["a", "b"])
        #expect(result.pagination == nil)
    }

    @Test func decodesTheEnvelope() throws {
        let json = #"{"data":[{"id":"a"}],"pagination":{"has_more":true,"next_page":"a","prev_page":null}}"#
        let result = try JSONDecoder().decode(ListResult<Item>.self, from: Data(json.utf8))
        #expect(result.data.map(\.id) == ["a"])
        #expect(result.pagination == PaginationMetadata(hasMore: true, nextPage: "a"))
    }

    @Test func elementErrorsAreNotMaskedInEitherShape() {
        #expect(throws: DecodingError.self) { try JSONDecoder().decode(ListResult<Item>.self, from: Data(#"[{"nope":1}]"#.utf8)) }
        #expect(throws: DecodingError.self) { try JSONDecoder().decode(ListResult<Item>.self, from: Data(#"{"data":[{"nope":1}]}"#.utf8)) }
    }

    @Test(arguments: [
        "GET /v1/instances/{instance_id}/payouts",
        "GET /v1/instances/{instance_id}/payins",
        "GET /v1/instances/{instance_id}/transfers",
    ])
    func listFixturesDecodeInBothShapes(operation: String) throws {
        for variant in try Fixtures.variantNames(operation) {
            let data = try Fixtures.response(operation, variant: variant)
            switch operation {
            case let op where op.hasSuffix("/payouts"): _ = try JSONDecoder().decode(ListPayoutsResponse.self, from: data)
            case let op where op.hasSuffix("/payins"): _ = try JSONDecoder().decode(ListPayinsResponse.self, from: data)
            default: _ = try JSONDecoder().decode(ListTransfersResponse.self, from: data)
            }
        }
    }
}

struct ListRequestTests {
    @Test func payoutFiltersAreSentInOrderAndLimitIsAString() async throws {
        let server = MockServer(respondWith: .json(Data("[]".utf8)))
        let params = ListPayoutsInput(limit: 50, customerId: "cu_000000000000", status: .completed,
                                      customerName: "Ada", bankAccountId: "ba_000000000000", country: .br,
                                      paymentMethod: .pix, network: .base, token: .usdc)
        _ = try await server.client.instances.payouts.list(params: params)
        let request = try #require(server.requests.first)
        #expect(request.path == "/v1/instances/in_000000000000/payouts")
        #expect(request.queryItems == [
            URLQueryItem(name: "limit", value: "50"),
            URLQueryItem(name: "customer_id", value: "cu_000000000000"),
            URLQueryItem(name: "status", value: "completed"),
            URLQueryItem(name: "customer_name", value: "Ada"),
            URLQueryItem(name: "bank_account_id", value: "ba_000000000000"),
            URLQueryItem(name: "country", value: "BR"),
            URLQueryItem(name: "payment_method", value: "pix"),
            URLQueryItem(name: "network", value: "base"),
            URLQueryItem(name: "token", value: "USDC"),
        ])
    }

    @Test func emptyParamsSendNoQuery() async throws {
        let server = MockServer(respondWith: .json(Data("[]".utf8)))
        _ = try await server.client.instances.payins.list(params: ListPayinsInput())
        #expect(server.requests.first?.url.query == nil)
    }

    @Test func customerAndTransferAndBankAccountFilters() async throws {
        let server = MockServer(respondWith: .json(Data("[]".utf8)))
        _ = try await server.client.instances.customers.list(params: ListCustomersInput(fullName: "Ada L", status: .approved))
        _ = try await server.client.instances.transfers.list(params: ListTransfersInput(walletId: "bw_000000000000", token: .usdt))
        _ = try await server.client.customers(customerId: "cu_000000000000").bankAccounts.list(params: ListBankAccountsInput(status: .approved, type: .pix))
        let requests = server.requests
        #expect(requests[0].queryItems == [URLQueryItem(name: "full_name", value: "Ada L"), URLQueryItem(name: "status", value: "approved")])
        #expect(requests[1].queryItems == [URLQueryItem(name: "wallet_id", value: "bw_000000000000"), URLQueryItem(name: "token", value: "USDT")])
        #expect(requests[2].queryItems == [URLQueryItem(name: "status", value: "approved"), URLQueryItem(name: "type", value: "pix")])
    }

    @Test func payinTrackSendsTheCheckoutToken() async throws {
        let body = try Fixtures.response("GET /v1/e/payins/{id}", variant: "full")
        let server = MockServer(respondWith: .json(body))
        _ = try await server.client.instances.payins.getTrack(payinId: "pi_000000000000", checkoutToken: "ct_1")
        _ = try await server.client.instances.payins.getTrack(payinId: "pi_000000000000")
        #expect(server.requests[0].queryItems == [URLQueryItem(name: "checkout_token", value: "ct_1")])
        #expect(server.requests[1].url.query == nil)
    }
}

struct AutoPagingTests {
    @Test func followsNextPageWhileHasMoreAndDefaultsLimitTo100() async throws {
        let server = MockServer(sequence: [
            page(["tr_1", "tr_2"], hasMore: true, next: "tr_2", of: transfersOp),
            page(["tr_3"], hasMore: false, next: nil, of: transfersOp),
        ])
        var ids: [String] = []
        for try await transfer in server.client.instances.transfers.listAutoPaging(params: ListTransfersInput(status: .completed)) {
            ids.append(transfer.id)
        }
        #expect(ids == ["tr_1", "tr_2", "tr_3"])
        let requests = server.requests
        #expect(requests.count == 2)
        #expect(requests[0].queryItems == [URLQueryItem(name: "limit", value: "100"), URLQueryItem(name: "status", value: "completed")])
        #expect(requests[1].queryItems == [URLQueryItem(name: "limit", value: "100"), URLQueryItem(name: "starting_after", value: "tr_2"), URLQueryItem(name: "status", value: "completed")])
    }

    @Test func keepsTheCallersLimitAndStopsOnABareArray() async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response(payoutsOp, variant: "full.b1")))
        var count = 0
        for try await _ in server.client.listPayoutsAutoPaging(params: ListPayoutsInput(limit: 10)) { count += 1 }
        #expect(count == 1)
        #expect(server.requests.count == 1)
        #expect(server.requests[0].queryItems.first == URLQueryItem(name: "limit", value: "10"))
    }

    @Test func stopsFetchingWhenTheConsumerStops() async throws {
        let server = MockServer(respondWith: page(["cu_1", "cu_2"], hasMore: true, next: "cu_2", of: customersOp))
        for try await _ in server.client.instances.customers.listAutoPaging() { break }
        #expect(server.requests.count == 1)
    }

    @Test func rejectsEndingBeforeWithoutARequest() async throws {
        let server = MockServer(respondWith: .json(Data("[]".utf8)))
        await #expect(throws: BlindPayError.self) {
            for try await _ in server.client.instances.payins.listAutoPaging(params: ListPayinsInput(endingBefore: "pi_1")) {}
        }
        #expect(server.requests.isEmpty)
    }

    @Test func surfacesAnAPIErrorAndStops() async throws {
        let server = MockServer(sequence: [
            page(["pa_1"], hasMore: true, next: "pa_1", of: payoutsOp),
            MockResponse(status: 400, body: Data(#"{"success":false,"message":"bad","code":"X"}"#.utf8)),
        ])
        var seen: [String] = []
        await #expect(throws: APIError.self) {
            for try await payout in server.client.instances.payouts.listAutoPaging() { seen.append(payout.id) }
        }
        #expect(seen == ["pa_1"])
    }
}
