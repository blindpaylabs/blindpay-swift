//
//  ModelDecodingTests.swift
//  blindpay-swift
//

import Foundation
import Testing
@testable import BlindPay

struct ModelDecodingTests {
    @Test func paginationMetadataDecodesStringPageCursors() throws {
        let json = """
        {"has_more":true,"next_page":"pi_123","prev_page":null}
        """
        let metadata = try JSONDecoder().decode(PaginationMetadata.self, from: Data(json.utf8))
        #expect(metadata.hasMore == true)
        #expect(metadata.nextPage == "pi_123")
        #expect(metadata.prevPage == nil)
    }

    @Test func listTransfersResponseDecodesWithANextPageCursor() throws {
        // The one paginated wrapper in this SDK; this is the realistic shape
        // the API returns once a next page exists.
        let json = """
        {
            "data": [{"id": "tr_123", "status": "completed"}],
            "pagination": {"has_more": true, "next_page": "tr_456", "prev_page": null}
        }
        """
        let response = try JSONDecoder().decode(ListTransfersResponse.self, from: Data(json.utf8))
        #expect(response.data.count == 1)
        #expect(response.pagination.hasMore == true)
        #expect(response.pagination.nextPage == "tr_456")
        #expect(response.pagination.prevPage == nil)
    }

    @Test func payinDecodesNumericBillingFeeAmount() throws {
        let json = """
        {
            "id": "pi_123",
            "customer_id": "cu_123",
            "status": "completed",
            "instance_id": "in_123",
            "created_at": "2024-01-01T00:00:00Z",
            "updated_at": "2024-01-01T00:00:00Z",
            "billing_fee_amount": 50
        }
        """
        let payin = try JSONDecoder().decode(Payin.self, from: Data(json.utf8))
        #expect(payin.billingFeeAmount == 50)
    }

    @Test func bankAccountTypeSavingsEncodesAsSaving() throws {
        let data = try JSONEncoder().encode(BankAccountType.savings)
        let wire = String(data: data, encoding: .utf8)
        #expect(wire == "\"saving\"")

        // Round trip: the wire value the API actually accepts must decode
        // back to the same case.
        let decoded = try JSONDecoder().decode(BankAccountType.self, from: Data("\"saving\"".utf8))
        #expect(decoded == .savings)
    }
}
