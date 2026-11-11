//
//  OpCoverageTests.swift
//  blindpay-swift
//
//  Every operation of the SDK surface (Fixtures/index.json, 94 ops) is called
//  through its SDK method against the mock, once per fixture variant: the
//  request must hit the operation's method and path, and every variant
//  (full, required_only, nullables_null, unknown_enum, decimals; lists in
//  both shapes) must decode.
//

import Foundation
import Testing
@testable import BlindPay

private typealias Call = @Sendable (BlindPay) async throws -> Void

private let I = "/v1/instances/{instance_id}"
private let C = "/v1/instances/{instance_id}/customers/{customer_id}"
private let cu = "cu_000000000000"
private let file = Data("%PDF-1.4".utf8)

/// One call per operation, keyed exactly as in Fixtures/index.json.
private let calls: [String: Call] = [
    // Available
    "GET /v1/available/bank-details": { _ = try await $0.available.getBankDetails(rail: "pix").get() },
    "GET /v1/available/naics": { _ = try await $0.available.getNaicsCodes().get() },
    "GET /v1/available/rails": { _ = try await $0.available.getRails().get() },
    "GET /v1/available/swift/{swift}": { _ = try await $0.available.getSwiftCode(swift: "BOFAUS3N").get() },
    // Bank accounts
    "POST \(C)/bank-accounts": { _ = try await $0.customers(customerId: cu).bankAccounts.create(data: CreateBankAccountInput(name: "n", type: .pix)).get() },
    "GET \(C)/bank-accounts": { _ = try await $0.customers(customerId: cu).bankAccounts.list().get() },
    "POST \(C)/bank-accounts/plaid": { _ = try await $0.customers(customerId: cu).bankAccounts.createPlaidLink().get() },
    "GET \(C)/bank-accounts/{id}": { _ = try await $0.customers(customerId: cu).bankAccounts.get(id: "ba_1").get() },
    "DELETE \(C)/bank-accounts/{id}": { _ = try await $0.customers(customerId: cu).bankAccounts.delete(id: "ba_1").get() },
    // Blockchain wallets
    "POST \(C)/blockchain-wallets": { _ = try await $0.customers(customerId: cu).blockchainWallets.create(data: CreateBlockchainWalletInput(name: "w", network: .base)).get() },
    "GET \(C)/blockchain-wallets": { _ = try await $0.customers(customerId: cu).blockchainWallets.list().get() },
    "GET \(C)/blockchain-wallets/sign-message": { _ = try await $0.customers(customerId: cu).blockchainWallets.getSignMessage().get() },
    "GET \(C)/blockchain-wallets/{id}": { _ = try await $0.customers(customerId: cu).blockchainWallets.get(id: "bw_1").get() },
    "DELETE \(C)/blockchain-wallets/{id}": { _ = try await $0.customers(customerId: cu).blockchainWallets.delete(id: "bw_1").get() },
    "PATCH \(C)/blockchain-wallets/{id}": { _ = try await $0.customers(customerId: cu).blockchainWallets.setSelfCustody(id: "bw_1", isSelfCustody: true).get() },
    // Customers
    "POST \(I)/customers": { _ = try await $0.instances.customers.create(data: CreateCustomerInput(country: .us, email: "a@example.com", kycType: .standard, type: .individual)).get() },
    "GET \(I)/customers": { _ = try await $0.instances.customers.list().get() },
    "POST \(C)/limit-increase": { _ = try await $0.customers(customerId: cu).requestLimitIncrease(data: RequestLimitIncreaseInput(perTransaction: 100, daily: nil, monthly: nil)).get() },
    "GET \(C)/limit-increase": { _ = try await $0.customers(customerId: cu).listLimitIncreases().get() },
    "GET \(C)/rfi": { _ = try await $0.customers(customerId: cu).rfi.get().get() },
    "POST \(C)/rfi": { _ = try await $0.customers(customerId: cu).rfi.submit(response: ["occupation": "Engineer"]).get() },
    "GET \(I)/customers/{id}": { _ = try await $0.customers(customerId: cu).get().get() },
    "PUT \(I)/customers/{id}": { _ = try await $0.customers(customerId: cu).update(data: UpdateCustomerInput(country: .us, email: "a@example.com")).get() },
    "DELETE \(I)/customers/{id}": { _ = try await $0.customers(customerId: cu).delete().get() },
    "GET \(I)/limits/customers/{id}": { _ = try await $0.customers(customerId: cu).getLimits().get() },
    "GET \(I)/billing/fees": { _ = try await $0.instances.getFees().get() },
    // Instances
    "GET /v1/instances/{id}": { _ = try await $0.instances.get().get() },
    "PUT /v1/instances/{id}": { _ = try await $0.instances.update(data: UpdateInstanceInput(name: "n")).get() },
    "DELETE /v1/instances/{id}": { _ = try await $0.instances.delete().get() },
    "GET /v1/instances/{id}/members": { _ = try await $0.instances.getMembers().get() },
    "DELETE /v1/instances/{id}/members/{user_id}": { _ = try await $0.instances.deleteMember(memberId: "us_1").get() },
    "PUT /v1/instances/{id}/members/{user_id}": { _ = try await $0.instances.updateMemberRole(memberId: "us_1", role: .admin).get() },
    "POST /v1/instances/{id}/ownership": { _ = try await $0.instances.migrateOwnership(data: MigrateInstanceOwnershipInput(userId: "us_1")).get() },
    "GET \(I)/onboarding/business_details": { _ = try await $0.instances.onboarding.getBusinessDetails().get() },
    "GET \(I)/onboarding/business_profile": { _ = try await $0.instances.onboarding.getBusinessProfile().get() },
    "GET \(I)/onboarding/ownership_documents": { _ = try await $0.instances.onboarding.getOwnershipDocuments().get() },
    "GET \(I)/rfi": { _ = try await $0.instances.rfi.get().get() },
    "POST \(I)/rfi": { _ = try await $0.instances.rfi.submit(response: ["proof": ["https://example.com/a.pdf"]]).get() },
    // Offramp wallets
    "POST \(C)/bank-accounts/{bank_account_id}/offramp-wallets": { _ = try await $0.customers(customerId: cu).bankAccounts.offrampWallets.create(bankAccountId: "ba_1", data: CreateOfframpWalletInput(network: .base)).get() },
    "GET \(C)/bank-accounts/{bank_account_id}/offramp-wallets": { _ = try await $0.customers(customerId: cu).bankAccounts.offrampWallets.list(bankAccountId: "ba_1").get() },
    "GET \(C)/bank-accounts/{bank_account_id}/offramp-wallets/{id}": { _ = try await $0.customers(customerId: cu).bankAccounts.offrampWallets.get(bankAccountId: "ba_1", walletId: "ow_1").get() },
    "PUT \(C)/bank-accounts/{bank_account_id}/offramp-wallets/{id}": { _ = try await $0.customers(customerId: cu).bankAccounts.offrampWallets.update(bankAccountId: "ba_1", walletId: "ow_1", data: UpdateOfframpWalletInput(partnerFee: .clear)).get() },
    // Partner fees
    "POST \(I)/partner-fees": { _ = try await $0.instances.partnerFees.create(data: CreatePartnerFeeInput(name: "f", payinFlatFee: 0, payinPercentageFee: 0, payoutFlatFee: 0, payoutPercentageFee: 0)).get() },
    "GET \(I)/partner-fees": { _ = try await $0.instances.partnerFees.list().get() },
    "GET \(I)/partner-fees/{id}": { _ = try await $0.instances.partnerFees.get(id: "pf_1").get() },
    "DELETE \(I)/partner-fees/{id}": { _ = try await $0.instances.partnerFees.delete(id: "pf_1").get() },
    // Payables
    "POST \(I)/payables": { _ = try await $0.instances.payables.create(data: CreatePayableInput(customerId: cu, currency: .brl)).get() },
    "GET \(I)/payables": { _ = try await $0.instances.payables.list().get() },
    "GET \(I)/payables/{id}": { _ = try await $0.instances.payables.get(id: "pb_1").get() },
    "DELETE \(I)/payables/{id}": { _ = try await $0.instances.payables.delete(id: "pb_1").get() },
    // Payin quotes and payins
    "POST \(I)/payin-quotes": { _ = try await $0.instances.payins.quotes.create(data: CreatePayinQuoteInput(currencyType: .sender, requestAmount: 1000, paymentMethod: .pix, token: .usdc)).get() },
    "POST \(I)/payin-quotes/fx": { _ = try await $0.instances.payins.quotes.getFxRate(data: GetFxRateInput(currencyType: .sender, from: .brl, to: .usdc, requestAmount: 1000)).get() },
    "GET /v1/e/payins/{id}": { _ = try await $0.instances.payins.getTrack(payinId: "pi_1").get() },
    "GET \(I)/payins": { _ = try await $0.instances.payins.list().get() },
    "POST \(I)/payins/evm": { _ = try await $0.instances.payins.createEvm(data: CreatePayinInput(payinQuoteId: "pq_1")).get() },
    "GET \(I)/payins/{id}": { _ = try await $0.instances.payins.get(payinId: "pi_1").get() },
    // Payouts and quotes
    "GET /v1/e/payouts/{id}": { _ = try await $0.instances.payouts.getTrack(payoutId: "pa_1").get() },
    "GET \(I)/payouts": { _ = try await $0.instances.payouts.list().get() },
    "POST \(I)/payouts/evm": { _ = try await $0.instances.payouts.createEvm(data: CreatePayoutEvmInput(quoteId: "qu_1", walletId: "bw_1")).get() },
    "POST \(I)/payouts/solana": { _ = try await $0.instances.payouts.createSolana(data: CreatePayoutSolanaInput(quoteId: "qu_1", senderWalletAddress: "addr")).get() },
    "POST \(I)/payouts/stellar": { _ = try await $0.instances.payouts.createStellar(data: CreatePayoutStellarInput(quoteId: "qu_1", senderWalletAddress: "addr")).get() },
    "POST \(I)/payouts/stellar/authorize": { _ = try await $0.instances.payouts.authorizeStellar(data: AuthorizeStellarInput(quoteId: "qu_1", senderWalletAddress: "addr")).get() },
    "GET \(I)/payouts/{id}": { _ = try await $0.instances.payouts.get(payoutId: "pa_1").get() },
    "POST \(I)/payouts/{id}/documents": { _ = try await $0.instances.payouts.submitDocuments(payoutId: "pa_1", data: SubmitPayoutDocumentsInput(transactionDocumentType: .invoice, transactionDocumentId: "1", transactionDocumentFile: "https://example.com/a.pdf")).get() },
    "POST \(I)/quotes": { _ = try await $0.instances.quotes.create(data: CreateQuoteInput(bankAccountId: "ba_1", currencyType: .sender, network: .base, requestAmount: 1000, token: .usdc)).get() },
    "POST \(I)/quotes/fx": { _ = try await $0.instances.quotes.getFxRate(data: GetFxRateInput(currencyType: .sender, from: .usdc, to: .brl, requestAmount: 1000)).get() },
    // Solana / Stellar helpers
    "POST \(I)/mint-usdb-solana": { _ = try await $0.instances.mintUsdbSolana(data: MintUsdbSolanaInput(address: "addr", amount: "1")).get() },
    "POST \(I)/prepare-delegate-solana": { _ = try await $0.instances.prepareDelegateSolana(data: PrepareDelegateSolanaInput(ownerAddress: "addr")).get() },
    "POST \(I)/create-asset-trustline": { _ = try await $0.instances.createAssetTrustline(data: CreateAssetTrustlineInput(address: "addr")).get() },
    "POST \(I)/mint-usdb-stellar": { _ = try await $0.instances.mintUsdbStellar(data: MintUsdbStellarInput(address: "addr", amount: "1")).get() },
    // Terms of service
    "POST /v1/e/instances/{instance_id}/tos": { _ = try await $0.instances.termsOfService.initiate(data: InitiateTosInput(idempotencyKey: "tos-1")).get() },
    // Transfers
    "POST \(I)/transfer-quotes": { _ = try await $0.instances.transferQuotes.create(data: CreateTransferQuoteInput(walletId: "bw_1", senderToken: .usdc, customerWalletAddress: "0x1", customerToken: .usdc, customerNetwork: .base, requestAmount: 1000, amountReference: "sender")).get() },
    "GET /v1/e/transfers/{id}": { _ = try await $0.instances.transfers.getTrack(transferId: "tr_1").get() },
    "GET \(I)/transfers": { _ = try await $0.instances.transfers.list().get() },
    "POST \(I)/transfers": { _ = try await $0.instances.transfers.create(data: CreateTransferInput(transferQuoteId: "tq_1")).get() },
    "GET \(I)/transfers/{id}": { _ = try await $0.instances.transfers.get(transferId: "tr_1").get() },
    // Uploads
    "POST /v1/presign": { _ = try await $0.upload.presign(fileUrl: "https://example.com/a.pdf").get() },
    "POST /v1/upload": { _ = try await $0.upload.create(data: UploadInput(file: file, fileName: "a.pdf", bucket: .documents)).get() },
    "POST /v1/upload/analyze": { _ = try await $0.upload.analyze(data: UploadAnalyzeInput(file: file, fileName: "a.pdf", type: .passport)).get() },
    // Virtual accounts
    "POST \(C)/virtual-accounts": { _ = try await $0.customers(customerId: cu).virtualAccounts.create(data: CreateVirtualAccountInput(bankingPartner: .jpmorgan, token: .usdc, blockchainWalletId: "bw_1")).get() },
    "GET \(C)/virtual-accounts": { _ = try await $0.customers(customerId: cu).virtualAccounts.list().get() },
    "GET \(C)/virtual-accounts/{id}": { _ = try await $0.customers(customerId: cu).virtualAccounts.get(id: "va_1").get() },
    "PUT \(C)/virtual-accounts/{id}": { _ = try await $0.customers(customerId: cu).virtualAccounts.update(id: "va_1", data: UpdateVirtualAccountInput(blockchainWalletId: "bw_1", token: .usdc)).get() },
    // Managed wallets
    "POST \(C)/wallets": { _ = try await $0.customers(customerId: cu).custodialWallets.create(data: CreateCustodialWalletInput(name: "w", network: .base)).get() },
    "GET \(C)/wallets": { _ = try await $0.customers(customerId: cu).custodialWallets.list().get() },
    "GET \(C)/wallets/{id}": { _ = try await $0.customers(customerId: cu).custodialWallets.get(id: "bw_1").get() },
    "DELETE \(C)/wallets/{id}": { _ = try await $0.customers(customerId: cu).custodialWallets.delete(id: "bw_1").get() },
    "GET \(C)/wallets/{id}/balance": { _ = try await $0.customers(customerId: cu).custodialWallets.getBalance(id: "bw_1").get() },
    "GET \(C)/wallets/{id}/deposits": { _ = try await $0.customers(customerId: cu).custodialWallets.getDeposits(id: "bw_1").get() },
    // Webhook endpoints
    "POST \(I)/webhook-endpoints": { _ = try await $0.instances.webhookEndpoints.create(data: CreateWebhookEndpointInput(url: "https://example.com/hook", events: [.payoutComplete])).get() },
    "GET \(I)/webhook-endpoints": { _ = try await $0.instances.webhookEndpoints.list().get() },
    "GET \(I)/webhook-endpoints/portal-access": { _ = try await $0.instances.webhookEndpoints.getPortalAccessUrl().get() },
    "DELETE \(I)/webhook-endpoints/{id}": { _ = try await $0.instances.webhookEndpoints.delete(id: "we_1").get() },
    "GET \(I)/webhook-endpoints/{id}/secret": { _ = try await $0.instances.webhookEndpoints.getSecret(id: "we_1").get() },
]

private var operations: [String] {
    let index = try! Fixtures.json(at: Fixtures.root.appendingPathComponent("index.json"))
    return (index["operations"] as! [String: String]).keys.sorted()
}

/// Whether `path` (as sent) matches the spec template, `{x}` being one segment.
private func matches(_ path: String, template: String) -> Bool {
    let sent = path.split(separator: "/", omittingEmptySubsequences: false)
    let expected = template.split(separator: "/", omittingEmptySubsequences: false)
    guard sent.count == expected.count else { return false }
    return zip(sent, expected).allSatisfy { segment, pattern in
        (pattern.hasPrefix("{") && pattern.hasSuffix("}") && !segment.isEmpty) || segment == pattern
    }
}

struct OpCoverageTests {
    @Test func everySurfaceOperationHasACall() {
        let ops = operations
        #expect(ops.count == 94)
        #expect(Set(calls.keys) == Set(ops), "missing: \(Set(ops).subtracting(calls.keys).sorted()), extra: \(Set(calls.keys).subtracting(ops).sorted())")
    }

    @Test(arguments: operations)
    func callsTheOperationAndDecodesEveryVariant(operation: String) async throws {
        let call = try #require(calls[operation])
        let parts = operation.split(separator: " ", maxSplits: 1).map(String.init)
        let variants = try Fixtures.variantNames(operation)
        #expect(!variants.isEmpty)
        for variant in variants {
            let server = MockServer(respondWith: .json(try Fixtures.response(operation, variant: variant)))
            do {
                try await call(server.client)
            } catch {
                Issue.record("\(operation) [\(variant)]: \(error)")
            }
            let request = try #require(server.requests.first)
            #expect(request.method == parts[0], "\(operation)")
            #expect(matches(request.rawPath, template: parts[1]), "\(operation): sent \(request.rawPath)")
        }
    }
}
