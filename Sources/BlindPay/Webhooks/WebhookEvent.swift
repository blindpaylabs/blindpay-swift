//
//  WebhookEvent.swift
//  blindpay-swift
//

import Foundation

/// A verified webhook, typed by its `webhook_event` name. Build one with
/// ``Webhooks/constructEvent(payload:headers:secret:tolerance:)``.
///
/// A failed payout arrives as `payout.update` or as `payout.complete`
/// depending on the path, so branch on the payload's `status`, not on the
/// event name. Events added to the API after this SDK version arrive as
/// ``unknown(type:payload:)`` with the raw JSON.
public enum WebhookEvent: Sendable, Equatable {
    /// `bankAccount.new`
    case bankAccountNew(BankAccount)
    /// `blockchainWallet.new`
    case blockchainWalletNew(BlockchainWallet)
    /// `blockchainWallet.update`
    case blockchainWalletUpdate(BlockchainWallet)
    /// `customer.new`
    case customerNew(Customer)
    /// `customer.update`
    case customerUpdate(Customer)
    /// `customer.delete`
    case customerDelete(CustomerDeleteWebhook)
    /// `limitIncrease.new`
    case limitIncreaseNew(LimitIncreaseRequest)
    /// `limitIncrease.update`
    case limitIncreaseUpdate(LimitIncreaseRequest)
    /// `payable.new`
    case payableNew(Payable)
    /// `payable.update`
    case payableUpdate(Payable)
    /// `payable.complete`
    case payableComplete(Payable)
    /// `payin.new`
    case payinNew(PayinWebhook)
    /// `payin.update`
    case payinUpdate(PayinWebhook)
    /// `payin.complete`
    case payinComplete(PayinWebhook)
    /// `payin.partnerFee`
    case payinPartnerFee(PayinWebhook)
    /// `payout.new`
    case payoutNew(PayoutWebhook)
    /// `payout.update`
    case payoutUpdate(PayoutWebhook)
    /// `payout.complete`
    case payoutComplete(PayoutWebhook)
    /// `payout.partnerFee`
    case payoutPartnerFee(PayoutWebhook)
    /// `tos.accept`
    case tosAccept(TosAcceptWebhook)
    /// `transfer.new`
    case transferNew(Transfer)
    /// `transfer.update`
    case transferUpdate(Transfer)
    /// `transfer.complete`
    case transferComplete(Transfer)
    /// `virtualAccount.new`
    case virtualAccountNew(VirtualAccount)
    /// `virtualAccount.complete`
    case virtualAccountComplete(VirtualAccount)
    /// `wallet.new`
    case walletNew(CustodialWallet)
    /// `wallet.update`
    case walletUpdate(CustodialWallet)
    /// `wallet.inbound`
    case walletInbound(WalletInboundWebhook)
    /// An event this SDK version doesn't model yet. `payload` is the raw JSON body.
    case unknown(type: WebhookEventType, payload: Data)

    /// The event name (`webhook_event`).
    public var type: WebhookEventType {
        switch self {
        case .bankAccountNew: return .bankAccountNew
        case .blockchainWalletNew: return .blockchainWalletNew
        case .blockchainWalletUpdate: return .blockchainWalletUpdate
        case .customerNew: return .customerNew
        case .customerUpdate: return .customerUpdate
        case .customerDelete: return .customerDelete
        case .limitIncreaseNew: return .limitIncreaseNew
        case .limitIncreaseUpdate: return .limitIncreaseUpdate
        case .payableNew: return .payableNew
        case .payableUpdate: return .payableUpdate
        case .payableComplete: return .payableComplete
        case .payinNew: return .payinNew
        case .payinUpdate: return .payinUpdate
        case .payinComplete: return .payinComplete
        case .payinPartnerFee: return .payinPartnerFee
        case .payoutNew: return .payoutNew
        case .payoutUpdate: return .payoutUpdate
        case .payoutComplete: return .payoutComplete
        case .payoutPartnerFee: return .payoutPartnerFee
        case .tosAccept: return .tosAccept
        case .transferNew: return .transferNew
        case .transferUpdate: return .transferUpdate
        case .transferComplete: return .transferComplete
        case .virtualAccountNew: return .virtualAccountNew
        case .virtualAccountComplete: return .virtualAccountComplete
        case .walletNew: return .walletNew
        case .walletUpdate: return .walletUpdate
        case .walletInbound: return .walletInbound
        case .unknown(let type, _): return type
        }
    }

    private struct Header: Decodable {
        let webhookEvent: String

        enum CodingKeys: String, CodingKey {
            case webhookEvent = "webhook_event"
        }
    }

    /// Decodes a webhook body without verifying it. Internal: callers go
    /// through ``Webhooks``, which verifies first.
    static func decode(from data: Data) throws -> WebhookEvent {
        let decoder = JSONDecoder()
        let name = try decoder.decode(Header.self, from: data).webhookEvent
        switch name {
        case WebhookEventType.bankAccountNew.rawValue: return .bankAccountNew(try decoder.decode(BankAccount.self, from: data))
        case WebhookEventType.blockchainWalletNew.rawValue: return .blockchainWalletNew(try decoder.decode(BlockchainWallet.self, from: data))
        case WebhookEventType.blockchainWalletUpdate.rawValue: return .blockchainWalletUpdate(try decoder.decode(BlockchainWallet.self, from: data))
        case WebhookEventType.customerNew.rawValue: return .customerNew(try decoder.decode(Customer.self, from: data))
        case WebhookEventType.customerUpdate.rawValue: return .customerUpdate(try decoder.decode(Customer.self, from: data))
        case WebhookEventType.customerDelete.rawValue: return .customerDelete(try decoder.decode(CustomerDeleteWebhook.self, from: data))
        case WebhookEventType.limitIncreaseNew.rawValue: return .limitIncreaseNew(try decoder.decode(LimitIncreaseRequest.self, from: data))
        case WebhookEventType.limitIncreaseUpdate.rawValue: return .limitIncreaseUpdate(try decoder.decode(LimitIncreaseRequest.self, from: data))
        case WebhookEventType.payableNew.rawValue: return .payableNew(try decoder.decode(Payable.self, from: data))
        case WebhookEventType.payableUpdate.rawValue: return .payableUpdate(try decoder.decode(Payable.self, from: data))
        case WebhookEventType.payableComplete.rawValue: return .payableComplete(try decoder.decode(Payable.self, from: data))
        case WebhookEventType.payinNew.rawValue: return .payinNew(try decoder.decode(PayinWebhook.self, from: data))
        case WebhookEventType.payinUpdate.rawValue: return .payinUpdate(try decoder.decode(PayinWebhook.self, from: data))
        case WebhookEventType.payinComplete.rawValue: return .payinComplete(try decoder.decode(PayinWebhook.self, from: data))
        case WebhookEventType.payinPartnerFee.rawValue: return .payinPartnerFee(try decoder.decode(PayinWebhook.self, from: data))
        case WebhookEventType.payoutNew.rawValue: return .payoutNew(try decoder.decode(PayoutWebhook.self, from: data))
        case WebhookEventType.payoutUpdate.rawValue: return .payoutUpdate(try decoder.decode(PayoutWebhook.self, from: data))
        case WebhookEventType.payoutComplete.rawValue: return .payoutComplete(try decoder.decode(PayoutWebhook.self, from: data))
        case WebhookEventType.payoutPartnerFee.rawValue: return .payoutPartnerFee(try decoder.decode(PayoutWebhook.self, from: data))
        case WebhookEventType.tosAccept.rawValue: return .tosAccept(try decoder.decode(TosAcceptWebhook.self, from: data))
        case WebhookEventType.transferNew.rawValue: return .transferNew(try decoder.decode(Transfer.self, from: data))
        case WebhookEventType.transferUpdate.rawValue: return .transferUpdate(try decoder.decode(Transfer.self, from: data))
        case WebhookEventType.transferComplete.rawValue: return .transferComplete(try decoder.decode(Transfer.self, from: data))
        case WebhookEventType.virtualAccountNew.rawValue: return .virtualAccountNew(try decoder.decode(VirtualAccount.self, from: data))
        case WebhookEventType.virtualAccountComplete.rawValue: return .virtualAccountComplete(try decoder.decode(VirtualAccount.self, from: data))
        case WebhookEventType.walletNew.rawValue: return .walletNew(try decoder.decode(CustodialWallet.self, from: data))
        case WebhookEventType.walletUpdate.rawValue: return .walletUpdate(try decoder.decode(CustodialWallet.self, from: data))
        case WebhookEventType.walletInbound.rawValue: return .walletInbound(try decoder.decode(WalletInboundWebhook.self, from: data))
        default: return .unknown(type: WebhookEventType(rawValue: name), payload: data)
        }
    }
}
