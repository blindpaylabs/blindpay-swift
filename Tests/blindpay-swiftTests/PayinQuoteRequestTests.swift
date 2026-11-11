//
//  PayinQuoteRequestTests.swift
//  blindpay-swift
//

import Foundation
import Testing
@testable import BlindPay

struct PayinQuoteRequestTests {
    private let operation = "POST /v1/instances/{instance_id}/payin-quotes"

    private func input() -> CreatePayinQuoteInput {
        CreatePayinQuoteInput(
            blockchainWalletId: "bw_000000000000",
            currencyType: .sender,
            coverFees: true,
            requestAmount: 1999,
            paymentMethod: .pix,
            token: .usdc,
            payerRules: PayinQuotePayerRules(pixAllowedTaxIds: ["123.456.789-09"])
        )
    }

    @Test func createSendsTheSpecBodyAndDecodesTheResponse() async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response(operation, variant: "full")))
        let response = try await server.client.instances.payins.quotes.create(data: input())

        let quote = try #require(response.data)
        #expect(quote.id == "qu_000000000000")
        #expect(quote.expiresAt == 1712958191000)
        #expect(quote.senderAmount == 5240)
        #expect(quote.receiverAmount == 1010)
        #expect(quote.commercialQuotation == 495)
        #expect(quote.cardInstruction?.provider == "nmi")

        let request = try #require(server.requests.first)
        #expect(request.method == "POST")
        #expect(request.path == "/v1/instances/in_000000000000/payin-quotes")
        let body = try request.jsonBody()
        // Exactly the CreatePayinQuoteIn keys that were set; unset optionals are absent.
        #expect(Set(body.keys) == ["blockchain_wallet_id", "currency_type", "cover_fees", "request_amount", "payment_method", "token", "payer_rules"])
        #expect(body["request_amount"] as? Int == 1999)
        #expect(body["token"] as? String == "USDC")
        #expect(body["payment_method"] as? String == "pix")
        #expect((body["payer_rules"] as? [String: Any])?["pix_allowed_tax_ids"] as? [String] == ["123.456.789-09"])
    }

    @Test func createDecodesEveryDecodeSafetyVariant() async throws {
        for variant in try Fixtures.variantNames(operation) {
            let server = MockServer(respondWith: .json(try Fixtures.response(operation, variant: variant)))
            let response = try await server.client.instances.payins.quotes.create(data: input())
            #expect(response.data?.id == "qu_000000000000", "variant \(variant)")
        }
    }

    @Test func facadeDelegatesToTheService() async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response(operation, variant: "required_only")))
        let response = try await server.client.createPayinQuote(data: input())

        #expect(response.data?.id == "qu_000000000000")
        #expect(server.requests.first?.path == "/v1/instances/in_000000000000/payin-quotes")
    }

    @Test func achPullQuoteSendsTheFundingBankAccount() async throws {
        let server = MockServer(respondWith: .json(try Fixtures.response(operation, variant: "required_only")))
        let input = CreatePayinQuoteInput(
            walletId: "bl_000000000000",
            currencyType: .sender,
            requestAmount: 100,
            paymentMethod: .achPull,
            token: .usdc,
            fundingBankAccountId: "ba_000000000000"
        )
        _ = try await server.client.instances.payins.quotes.create(data: input)

        let body = try #require(server.requests.first).jsonBody()
        #expect(body["payment_method"] as? String == "ach_pull")
        #expect(body["funding_bank_account_id"] as? String == "ba_000000000000")
        #expect(body["wallet_id"] as? String == "bl_000000000000")
    }

    @Test func paymentMethodDecodesAchPullAndCard() throws {
        let decoded = try JSONDecoder().decode([PaymentMethod].self, from: Data(#"["ach_pull","card"]"#.utf8))
        #expect(decoded == [.achPull, .card])
    }
}
