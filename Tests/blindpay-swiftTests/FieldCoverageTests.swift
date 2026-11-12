//
//  FieldCoverageTests.swift
//  blindpay-swift
//
//  Fields modelled in 5.1.0 from the unmodeled.json ledger: request fields
//  encode under their wire keys, and response fields decode from the shared
//  fixtures' `full` variant.
//

import Foundation
import Testing
@testable import BlindPay

private func keys<T: Encodable>(_ value: T) throws -> [String: Any] {
    try JSONSerialization.jsonObject(with: JSONEncoder().encode(value)) as? [String: Any] ?? [:]
}

private func decodeFull<T: Decodable>(_ type: T.Type, _ operation: String) throws -> T {
    try JSONDecoder().decode(T.self, from: Fixtures.response(operation, variant: "full"))
}

struct FieldCoverageTests {
    @Test func customerInputsSendAdditionalInfoAndGeolocation() throws {
        let info = [AdditionalInfoItem(label: .einLetter, value: "https://example.com/ein.pdf")]
        let create = try keys(CreateCustomerInput(
            country: .us, email: "a@example.com", kycType: .standard, type: .individual,
            additionalInfo: info, latitude: 37.7749, longitude: -122.4194
        ))
        let items = try #require(create["additional_info"] as? [[String: Any]])
        #expect(items.first?["label"] as? String == "EIN_LETTER")
        #expect(items.first?["value"] as? String == "https://example.com/ein.pdf")
        #expect(create["latitude"] as? Double == 37.7749)
        #expect(create["longitude"] as? Double == -122.4194)

        let update = try keys(UpdateCustomerInput(country: .us, email: "a@example.com", additionalInfo: info, latitude: 1, longitude: 2))
        #expect(update["additional_info"] != nil && update["latitude"] != nil && update["longitude"] != nil)
    }

    @Test func bankAccountInputSendsIfscAndForceCpfCnpj() throws {
        let body = try keys(CreateBankAccountInput(
            name: "n", type: .internationalSwift,
            forceCpfCnpj: true, swiftIfscBranchCode: "BARB0AHIMCI"
        ))
        #expect(body["swift_ifsc_branch_code"] as? String == "BARB0AHIMCI")
        #expect(body["force_cpf_cnpj"] as? Bool == true)
        #expect(body["status"] == nil)
    }

    @Test func instanceUpdateSendsComplianceEmailSettings() throws {
        let body = try keys(UpdateInstanceInput(name: "n", complianceEmails: ["compliance@example.com"], customerRfiEmailsEnabled: false))
        #expect(body["compliance_emails"] as? [String] == ["compliance@example.com"])
        #expect(body["customer_rfi_emails_enabled"] as? Bool == false)
    }

    @Test func limitIncreaseCarriesTheApprovedAmounts() throws {
        let items = try decodeFull([LimitIncreaseRequest].self, "GET /v1/instances/{instance_id}/customers/{customer_id}/limit-increase")
        let item = try #require(items.first)
        #expect(item.approvedDaily == 140000)
        #expect(item.approvedMonthly != nil && item.approvedPerTransaction != nil)
    }

    @Test func payinCarriesFeesPayerRulesAndRailInstructions() throws {
        let payin = try decodeFull(Payin.self, "GET /v1/instances/{instance_id}/payins/{id}")
        #expect(payin.partnerFee == 25000)
        #expect(payin.transactionFeeAmount == 100)
        #expect(payin.payerRules?.pixAllowedTaxIds?.isEmpty == false)
        // The spec gives manual_concluded_at no type, so the fixture holds {}.
        #expect(payin.manualConcludedAt != nil)
        let tracking = try #require(payin.trackingTransaction)
        #expect(tracking.pseInstruction?.paymentLink != nil)
        #expect(tracking.tedInstruction?.bankCode != nil)
        #expect(tracking.transfersInstruction?.account != nil)
    }

    @Test func payoutCarriesFeesAndDocumentTracking() throws {
        let payout = try decodeFull(Payout.self, "GET /v1/instances/{instance_id}/payouts/{id}")
        #expect(payout.partnerFee == -25000)
        #expect(payout.trackingDocuments?.step != nil)
        #expect(payout.senderLegalName != nil)
        #expect(payout.trackingPayment?.providerUetr != nil)
    }

    @Test func bankAccountCarriesStatusAndIfsc() throws {
        let account = try decodeFull(BankAccount.self, "GET /v1/instances/{instance_id}/customers/{customer_id}/bank-accounts/{id}")
        #expect(account.status != nil)
        #expect(account.swiftIfscBranchCode != nil)
        #expect(account.recipientRelationship != nil)
    }

    @Test func newEnumConstantsHaveTheirWireValues() {
        #expect(Currency.eur.rawValue == "EUR")
        #expect(EstimatedTimeOfArrival.fiveToThirtyMin.rawValue == "5_30_min")
        #expect(PaymentType.sepa.rawValue == "sepa")
        #expect(TrackingStep.pendingReview.rawValue == "pending_review")
        #expect(SupportingDocumentType.individualPayStub.rawValue == "individual_pay_stub")
        #expect(BankDetailConditionOperator.notIn.rawValue == "notIn")
    }
}
