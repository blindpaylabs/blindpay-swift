//
//  ManagedWalletPayout (example E2)
//
//  Fund a BlindPay-managed wallet with a payin, then pay a bank account from
//  it. The payout names the wallet with `walletId` (exactly one of `walletId`
//  or `senderWalletAddress`; the wallet must be on the quote's network).
//
//  Runs against a development instance (USDB on base_sepolia; payins
//  complete in about 30 seconds) with an approved customer and bank account:
//
//    BLINDPAY_API_KEY=... BLINDPAY_INSTANCE_ID=in_... BLINDPAY_CUSTOMER_ID=cu_... \
//    BLINDPAY_BANK_ACCOUNT_ID=ba_... swift run ManagedWalletPayout
//
//  On a development instance a quote `requestAmount` of 66600 ends the payout
//  as failed and 77700 as refunded.
//

import BlindPay
import Foundation

let environment = ProcessInfo.processInfo.environment
guard let apiKey = environment["BLINDPAY_API_KEY"],
      let instanceId = environment["BLINDPAY_INSTANCE_ID"],
      let customerId = environment["BLINDPAY_CUSTOMER_ID"],
      let bankAccountId = environment["BLINDPAY_BANK_ACCOUNT_ID"] else {
    print("Set BLINDPAY_API_KEY, BLINDPAY_INSTANCE_ID, BLINDPAY_CUSTOMER_ID and BLINDPAY_BANK_ACCOUNT_ID.")
    exit(64)
}

let blindpay = BlindPay(apiKey: apiKey, instanceId: instanceId)
let network = Network.baseSepolia
let token = StablecoinToken.usdb

/// Unwraps a response or explains the API error, branching on its code.
func require<T>(_ response: APIResponse<T>, _ step: String) throws -> T {
    if let error = response.error {
        switch error.errorCode {
        case .quotesExpired?:
            print("\(step): the quote expired; request a new one")
        case .transfersSwapAmountBelowMinimum?, .payoutsAmountBelowMinimum?:
            print("\(step): raise the amount")
        default:
            print("\(step) failed: \(error.code ?? error.message) (\(error.retryClass.rawValue))")
        }
        throw error
    }
    guard let data = response.data else { throw BlindPayError.invalidResponse }
    return data
}

/// Polls until `status` is final. Development instances are rate limited,
/// so poll slowly; in production prefer the `payin.complete` and
/// `payout.complete` webhooks (see the WebhookReceiver example).
func waitFor(_ what: String, status: () async throws -> String) async throws -> String {
    for _ in 0..<30 {
        let current = try await status()
        if ["completed", "failed", "refunded"].contains(current) { return current }
        print("\(what): \(current)")
        try await Task.sleep(nanoseconds: 5_000_000_000)
    }
    return "timed out"
}

// 1. A managed wallet for the customer.
let customer = blindpay.customers(customerId: customerId)
let wallet = try require(
    try await customer.custodialWallets.create(data: CreateCustodialWalletInput(name: "Payout float", network: network)),
    "create wallet")
print("wallet \(wallet.id)")

// 2. Fund it: a PIX payin quote that delivers USDB into the wallet, then the payin.
let payinQuote = try require(
    try await blindpay.instances.payins.quotes.create(data: CreatePayinQuoteInput(
        walletId: wallet.id, currencyType: .sender, requestAmount: 50_000, paymentMethod: .pix, token: token)),
    "payin quote")
let payin = try require(
    try await blindpay.instances.payins.createEvm(data: CreatePayinInput(payinQuoteId: payinQuote.id)),
    "payin")
let payinStatus = try await waitFor("payin \(payin.id)") {
    try require(try await blindpay.instances.payins.get(payinId: payin.id), "get payin").status.rawValue
}
guard payinStatus == "completed" else { print("payin ended \(payinStatus)"); exit(1) }

// 3. Quote the bank payout in integer cents, then execute it from the managed wallet.
let quote = try require(
    try await blindpay.instances.quotes.create(data: CreateQuoteInput(
        bankAccountId: bankAccountId, currencyType: .sender, network: network,
        requestAmount: try Amount.cents(fromMajorUnits: 100), token: token)),
    "quote")
let payout = try require(
    try await blindpay.instances.payouts.createEvm(data: CreatePayoutEvmInput(quoteId: quote.id, walletId: wallet.id)),
    "payout")
let payoutStatus = try await waitFor("payout \(payout.id)") {
    try require(try await blindpay.instances.payouts.get(payoutId: payout.id), "get payout").status.rawValue
}
print("payout \(payout.id) ended \(payoutStatus)")
