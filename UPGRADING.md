# Upgrading from 4.x to 5.0

5.0 brings the SDK to the full public API (94 operations), adds idempotency, retries, timeouts, typed errors, pagination, webhook verification and forward-compatible enums, and fixes calls that always failed in 4.x. This guide lists every change that can break your build or your behaviour, with a before/after for each.

## Toolchain

The package now declares `swift-tools-version: 6.0` and builds in Swift 6 language mode. You need Xcode 16 / Swift 6.0 or newer. Platform minimums are unchanged (iOS 15, macOS 12, tvOS 15, watchOS 8), and Linux is supported.

```swift
.package(url: "https://github.com/blindpaylabs/blindpay-swift.git", from: "5.0.0")
```

## Behaviour changes without a compile error

- **Timeouts:** each attempt now times out after 60 seconds in total (configurable). 4.x used URLSession's idle timeout.
- **Retries:** failed requests are retried up to 2 times by default. GETs retry on no response, timeouts and 408/429/5xx. Mutations retry only on no response, 429 and `409 idempotency_key_in_flight`, never on a 5xx. Set `Configuration(maxRetries: 0)` to turn retries off.
- **Idempotency keys:** with retries on, every JSON mutation carries an auto-generated `Idempotency-Key` unless you pass one in `RequestOptions`.
- **User-Agent:** now `blindpay-swift/<SDK version>`; 4.x sent the host app's version.
- **Pagination:** list calls without `limit` or a cursor return every row; 4.x silently dropped the pagination metadata when a page came back.

## Enums are open structs

Every enum is now a struct conforming to `OpenEnum`, so an unknown value from the API decodes instead of failing the whole response.

```swift
// 4.x
switch payout.status {
case .processing: ...
case .completed: ...
case .failed: ...
case .refunded: ...
case .onHold: ...
}
let network = Network(rawValue: "base")!   // failable

// 5.0
switch payout.status {
case .completed: ...
case .failed: ...
default: ...                                // required
}
let network = Network(rawValue: "base")    // not failable; or `let network: Network = "base"`
```

`BusinessIndustry` is removed: NAICS codes are plain strings (`businessIndustry: "541511"`). `BankingPartner.ssb` is removed (the API no longer returns it).

## Amounts are integer cents

4.x took dollars as `Double` on some inputs and sent the transfer quote amount unconverted. Every amount input is now integer cents.

```swift
// 4.x
CreateQuoteInput(bankAccountId: "ba_1", currencyType: .sender, requestAmount: 19.99, transactionDocumentType: .invoice)

// 5.0
CreateQuoteInput(bankAccountId: "ba_1", currencyType: .sender, network: .base,
                 requestAmount: 1999, token: .usdc)
// or: requestAmount: try Amount.cents(fromMajorUnits: 19.99)
```

The same applies to `GetFxRateInput.requestAmount`, `CreatePayinQuoteInput.requestAmount` and `CreateTransferQuoteInput.requestAmount`.

## Request inputs that match the API

| Type | 4.x | 5.0 |
|---|---|---|
| `CreateQuoteInput` | `bankAccountId` and `transactionDocumentType` required; `network`/`token` optional | exactly one of `bankAccountId` or `payableId`; `network` and `token` required; `currencyType`/`requestAmount` optional; `transactionDocument*` removed (the API never accepted them) |
| `CreatePayoutEvmInput`, `CreatePayoutStellarInput`, `CreatePayoutSolanaInput`, `AuthorizeStellarInput` | `senderWalletAddress` required | exactly one of `senderWalletAddress` or the new `walletId` |
| `RequestLimitIncreaseInput` | `supportingDocumentType`/`File` required | the three limits are `Int?` (sent as `null` when nil); documents optional; new `supportingDocuments` |
| `PrepareDelegateSolanaInput` | `init(amount:ownerAddress:tokenAddress:)` | `init(ownerAddress:amount:tokenAddress:quoteId:)` |
| `CreatePartnerFeeInput` | `evmWalletAddress` required, `stellarWalletAddress` optional | both removed (not API fields); `PartnerFee` and `CreatePartnerFeeResponse` lose them too |
| `CreateCustomerInput`, `UpdateCustomerInput` | `isFbo` | removed (the API ignores it) |
| `CreatePayinQuoteInput` | `customerId`, `network`, `description` | removed; matches `CreatePayinQuoteIn` |
| `UploadInput` | JSON `{bucket, file}` | `UploadInput(file: Data, fileName:, contentType:, bucket:)`, sent as multipart |
| `List*Input` | `limit: String?`, `offset: String?` | `limit: Int?`, every API filter, `offset` deprecated (the API ignores it) |

```swift
// 4.x
CreatePayoutEvmInput(quoteId: "qu_1", senderWalletAddress: "0xabc")
CreatePartnerFeeInput(evmWalletAddress: "0xabc", name: "fee", payinFlatFee: 0, payinPercentageFee: 0,
                      payoutFlatFee: 0, payoutPercentageFee: 0)
RequestLimitIncreaseInput(perTransaction: 500000, daily: 1000000, monthly: 5000000,
                          supportingDocumentType: .individualBankStatement, supportingDocumentFile: url)
PrepareDelegateSolanaInput(amount: "10", ownerAddress: owner, tokenAddress: mint)
CreateCustomerInput(country: .us, email: email, kycType: .standard, type: .individual, isFbo: false)

// 5.0
CreatePayoutEvmInput(quoteId: "qu_1", senderWalletAddress: "0xabc")   // or walletId: "bw_1"
CreatePartnerFeeInput(name: "fee", payinFlatFee: 0, payinPercentageFee: 0, payoutFlatFee: 0, payoutPercentageFee: 0)
RequestLimitIncreaseInput(perTransaction: 500000, daily: 1000000, monthly: nil,
                          supportingDocuments: [LimitIncreaseSupportingDocument(type: .individualBankStatement, file: url)])
PrepareDelegateSolanaInput(ownerAddress: owner, amount: "10", tokenAddress: mint)
CreateCustomerInput(country: .us, email: email, kycType: .standard, type: .individual)
```

## Responses

- `CreatePayinQuoteResponse` is its own type matching the API (4.x decoded it as `PayinQuote` and always failed).
- `UploadResponse.url` is now `fileUrl`. `NaicsCode` is `{label, value}`.
- Fields the API can omit or return as null are optional: e.g. `Payout.name`/`type`, `VirtualAccount.us`, `SwiftCodeResponse.address`/`postcode`, the customer limit amounts.
- `FraudWarning.score`, `OnboardingOwner.ownershipPercentage` are `Double`.
- `CustodialWalletBalanceResponse` gains `eurc`/`eurb`.
- Cent amounts on quote and transfer responses are `Int`: `CreateQuoteResponse.senderAmount`/`receiverAmount`/`partnerFeeAmount`/`customerLocalAmount`, and `senderAmount`/`receiverAmount`/`partnerFeeAmount` on `CreateTransferQuoteResponse` and `Transfer`.

```swift
// 4.x
let upload = try await blindPay.createUpload(data: UploadInput(bucket: .onboarding, file: base64)).data?.url
let naics = try await blindPay.getNaicsCodes().data?.first?.code
let fee: Double? = quote.senderAmount                        // 1010.0
let name: String = payout.name

// 5.0
let upload = try await blindPay.createUpload(data: UploadInput(file: pdf, fileName: "a.pdf", bucket: .onboarding)).data?.fileUrl
let naics = try await blindPay.getNaicsCodes().data?.first?.value
let fee: Int? = quote.senderAmount                           // 1010 (cents)
let name: String? = payout.name
```

## Lists return `ListResult`

```swift
// 4.x
let payouts: [Payout] = try await blindPay.listPayouts(params: ListPayoutsInput(limit: "50")).data ?? []

// 5.0
let page = try await blindPay.listPayouts(params: ListPayoutsInput(limit: 50)).get()
let payouts = page?.data ?? []
let more = page?.pagination?.hasMore ?? false

for try await payout in blindPay.listPayoutsAutoPaging() { ... }
```

`ListPayoutsResponse`, `ListPayinsResponse`, `ListCustomersResponse` and `ListTransfersResponse` are now `ListResult<T>`. `PaginationParams` and `Pagination` are removed (use `PaginationMetadata`). `listCustomers` takes a `ListCustomersInput` instead of ten loose parameters.

## Errors

```swift
// 4.x
if let error = response.error { print(error.message) }       // message only
catch BlindPayError.httpError(let statusCode) { ... }

// 5.0
if let error = response.error {
    print(error.status, error.code ?? "", error.message, error.requestId ?? "", error.retryable)
}
let data = try response.get()   // throws the APIError
```

- `APIError` gains `status`, `code`, `description`, `errors`, `traceId`, `requestId`, `idempotencyKey`, `retryable`, `headers`. `APIResponse` is no longer `Codable`.
- `BlindPayError.httpError` is removed: every non-2xx is an `APIError`, including non-JSON bodies.
- `APIError.retryable` means a resend can be safe: a mutation is retryable only if it carried an idempotency key (resend with that key), and a mutation 408 never is.
- `networkError` and `decodingError` carry more: patterns need the extra bindings.
- New cases: `timeout`, `invalidRequest`, `incompleteResponse` (the status arrived but the body didn't), `cancelled(lastError:)` (cancelled while waiting to retry after an API error), `webhookVerificationFailed`.

```swift
// 4.x
catch BlindPayError.networkError(let error) { ... }
catch BlindPayError.decodingError(let error) { ... }

// 5.0
catch BlindPayError.networkError(let error, let idempotencyKey) { ... }        // no response received
catch BlindPayError.decodingError(let error, let status, let idempotencyKey) { ... }
catch BlindPayError.incompleteResponse(let status, let error, let idempotencyKey) { ... }
// or, for any of them:
catch let error as BlindPayError { resendLater(key: error.idempotencyKey) }
```

## Removed methods

- `getPayinQuote(id:)`, `listPayinQuotes(params:)`, `payins.quotes.get(id:)` and `payins.quotes.list(params:)`: the API has no such routes, so they always failed. `PayinQuote`, `PayinQuoteResponse`, `PayinQuotesResponse` and `ListPayinQuotesInput` are removed with them.
- The `GetRails` executable is no longer a package product (run it with `swift run GetRails` from a checkout).

```swift
// 4.x
let quote = try await blindPay.getPayinQuote(id: "pq_1")       // always failed: the route doesn't exist
let quotes = try await blindPay.listPayinQuotes()

// 5.0: keep the CreatePayinQuoteResponse returned by createPayinQuote(data:);
// the payin it funds is readable with getPayin(payinId:) / listPayins(params:).
let quote = try await blindPay.createPayinQuote(data: input).get()
```

## Renamed or moved

| 4.x | 5.0 |
|---|---|
| `WebhookEvent` (event names for endpoints) | `WebhookEventType`; `WebhookEvent` is now the typed, verified webhook (`Webhooks.constructEvent`) |
| `URLSessionTransport(session:)` | `URLSessionTransport(configuration:)` (only in 5.0 pre-releases) |
| `customers(customerId: "A").virtualAccounts.list(customerId: "B")` (the parameter overrode the scoped customer) | `customers(customerId: "A").virtualAccounts.list()`; same for `get`, `create`, `update` |
| `bankAccounts.offrampWallets.list(customerId:bankAccountId:)` (and `create`, `get`) | `bankAccounts.offrampWallets.list(bankAccountId:)`; the customer comes from `customers(customerId:)` |
| `getBankDetails(rail: String)` | `getBankDetails(rail: Rail)`, e.g. `.pix` (the `String` form still compiles, deprecated) |
| `getCustomer(id:)`, `updateCustomer(id:data:)`, `deleteCustomer(id:)`, `getCustomerLimits(id:)` | the same methods with `customerId:` (the `id:` forms still compile, deprecated) |
| `BlindPayError.decodingError(_)` | `BlindPayError.decodingError(_, status:, idempotencyKey:)` |
| facade-only customer, transfer, fee and payout-document methods | still on the facade, now delegating to `instances.customers`, `customers(customerId:)`, `instances.transfers`, `instances.transferQuotes`, `instances.getFees()`, `instances.payouts.submitDocuments(...)` |

```swift
// 4.x
let event: WebhookEvent = .payoutComplete
CreateWebhookEndpointInput(url: url, events: [.payoutComplete])
blindPay.customers(customerId: "cu_1").virtualAccounts.list(customerId: "cu_1")
blindPay.customers(customerId: "cu_1").bankAccounts.offrampWallets.get(customerId: "cu_1", bankAccountId: "ba_1", walletId: "ow_1")

// 5.0
let event: WebhookEventType = .payoutComplete
CreateWebhookEndpointInput(url: url, events: [.payoutComplete])  // unchanged call site
blindPay.customers(customerId: "cu_1").virtualAccounts.list()
blindPay.customers(customerId: "cu_1").bankAccounts.offrampWallets.get(bankAccountId: "ba_1", walletId: "ow_1")
```

## New

Payables, instance and customer RFI, instance onboarding, `instances.get()`, Plaid links, `setSelfCustody`, offramp wallet updates, wallet deposits, `upload.presign`/`analyze`, `RequestOptions` on every method, auto-pagers, the webhook verifier and typed events, and `Configuration(timeout:maxRetries:transport:)`. See the [README](README.md).

## Within 5.x

Minor releases add API without breaking your build. Behaviour notes:

### 5.2.0

- **Auto-pagination:** if the server answers `hasMore` with the same cursor it was just sent, `listAutoPaging` / `getDepositsAutoPaging` yield that page and then throw `BlindPayError.invalidResponse`. Before, the loop requested the same page forever. The API always advances the cursor, so only a misbehaving server or proxy triggers it.
- **Webhooks:** `Webhooks.verify` and `Webhooks.constructEvent` gain `now:` overloads (a fixed `Date` instead of the clock). The timestamp check now compares whole seconds, which matters only within one second of the tolerance boundary.
- **README webhook handler:** a correctly signed delivery that fails to decode (`BlindPayError.decodingError`) should be answered with 2xx and logged, not 400; see the README.

