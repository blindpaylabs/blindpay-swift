<h1>BlindPay Swift SDK <img src="https://github.com/user-attachments/assets/c42b121d-adf1-467c-88ce-6f5be1efa93c" align="right" width="102"/></h1>

[![chat on Discord](https://img.shields.io/discord/856971667393609759.svg?logo=discord)](https://discord.gg/x7ap6Gkbe9)
[![twitter](https://img.shields.io/twitter/follow/blindpaylabs?style=social)](https://twitter.com/intent/follow?screen_name=blindpaylabs)
[![Version](https://img.shields.io/github/v/release/blindpaylabs/blindpay-swift?include_prereleases)](https://github.com/blindpaylabs/blindpay-swift/releases)

The official Swift SDK for [BlindPay](https://blindpay.com), the stablecoin API for global payments.

Upgrading from 4.x? Read [UPGRADING.md](UPGRADING.md).

## Installation

Swift Package Manager, Swift 6.0 or newer, iOS 15 / macOS 12 / tvOS 15 / watchOS 8, and Linux:

```swift
dependencies: [
    .package(url: "https://github.com/blindpaylabs/blindpay-swift.git", from: "5.0.0")
]
```

In Xcode: File → Add Packages… and enter `https://github.com/blindpaylabs/blindpay-swift.git`.

## Quick start

Get your API key and instance id from the dashboard (`https://app.blindpay.com/instances/<instance_id>/api-keys`).

```swift
import BlindPay

let blindpay = BlindPay(apiKey: "your-api-key", instanceId: "in_000000000000")

let response = try await blindpay.available.getRails()
if let error = response.error {
    print("API error \(error.status) \(error.code ?? ""): \(error.message)")
} else {
    print(response.data ?? [])
}

// Or throw the API error instead of checking it:
let rails = try await blindpay.available.getRails().get()
```

Operations live on services that mirror the API:

```
blindpay.available                      rails, bank details, SWIFT codes, NAICS codes
blindpay.upload                         create (multipart), analyze, presign
blindpay.instances                      get, update, members, fees, Solana/Stellar helpers
  .customers                            list, listAutoPaging, create
  .payouts / .payins / .payins.quotes   quotes, payouts, payins, tracking
  .quotes / .transferQuotes / .transfers
  .payables / .partnerFees / .webhookEndpoints / .termsOfService
  .onboarding / .rfi
blindpay.customers(customerId:)         get, update, delete, limits, limit increases
  .rfi / .bankAccounts(.offrampWallets) / .blockchainWallets / .virtualAccounts / .custodialWallets
```

Every instance-level operation also has a flat method on `BlindPay` (`blindpay.createQuote(data:)`, `blindpay.listPayouts(params:)`, …) that delegates to its service.

A `BlindPay` client is immutable and safe to share across tasks; create one and reuse it.

## Configuration

```swift
let blindpay = BlindPay(
    apiKey: "your-api-key",
    instanceId: "in_000000000000",
    configuration: Configuration(
        baseURL: "https://api.blindpay.com", // default; a custom URL receives your API key
        timeout: 60,                           // seconds per attempt (connect + headers + body)
        maxRetries: 2,                         // 0 disables retries and automatic idempotency keys
        transport: URLSessionTransport()       // inject your own HTTPTransport for tests or proxies
    )
)
```

Every method takes a trailing `options: RequestOptions?` for one call:

```swift
let options = RequestOptions(idempotencyKey: "payout-order-42", timeout: 30, headers: ["X-Trace": "abc"])
_ = try await blindpay.instances.payouts.createEvm(data: input, options: options)
```

`Authorization`, `User-Agent` and `Idempotency-Key` can't be set through `headers`. The SDK sends `User-Agent: blindpay-swift/<version>` (`BlindPaySDK.version`).

## Errors

- **API errors** (any non-2xx) are returned in `response.error` as an `APIError`, or thrown by `response.get()`. It carries `status`, `code` (stable, e.g. `PAYOUTS_INSUFFICIENT_BALANCE`), `message`, `description`, `errors` (empty when absent), `traceId`, `requestId` (the `X-Request-Id` header), `idempotencyKey`, `retryable` and the response `headers`. Non-JSON error bodies (a proxy's HTML 502) still produce an `APIError` with the status.
- **Client errors** are thrown as `BlindPayError`: `.networkError` (no response; carries the idempotency key), `.timeout`, `.invalidRequest` (rejected before sending, e.g. an empty idempotency key), `.decodingError`, `.encodingError`, `.webhookVerificationFailed`.
- A successful response with no body (204) has `data == nil` and no error.

Branch on `errorCode`, a typed `ErrorCode` (an open enum generated from the API's error table, so a code this SDK version doesn't know still compares by its raw string). `retryClass` says how to react (`.retryable`, `.terminal`, `.actionable`, or `.unknown` when there is no code), and `errorCode?.info` gives the documented status. Some errors carry no `code` (idempotency conflicts, non-JSON bodies), so keep `message` as the fallback:

```swift
let response = try await blindpay.instances.transferQuotes.create(data: quoteInput)
if let error = response.error {
    switch error.errorCode {
    case .transfersSwapAmountBelowMinimum?:
        // Swaps between different tokens need at least 100 USDC.
        print("Raise the amount: \(error.description ?? error.message)")
    case .quotesExpired?:
        print("Request a new quote")
    default:
        if error.retryClass == .actionable { print("Fix the request: \(error.description ?? error.message)") }
    }
}
```

`retryClass` is advisory: the client's own retries follow `retryable` (see below).

Errors never contain your API key, the request body or the request's query string, and `dump(blindpay)` shows the key as `<redacted>`.

## Idempotency and retries

Mutations (POST/PUT/PATCH/DELETE) accept an `Idempotency-Key`. Pass your own with `RequestOptions(idempotencyKey:)` (1–255 characters, no surrounding whitespace). When you don't and retries are on, the SDK generates a UUID key before the first attempt, so a retried request can't run twice. File uploads never carry a key (the API ignores it for multipart).

The SDK retries, with exponential backoff and jitter (`Retry-After` is honoured up to 60 s):

- **GET**: no response, a timeout, and HTTP 408, 429, 500, 502, 503, 504.
- **Mutations**: only when it's provably safe: no response at all, HTTP 429, or `409 idempotency_key_in_flight`.

**Mutations are never retried automatically on a 5xx**, because the API releases the idempotency key on a 5xx and a resend would run the request again. You get an `APIError` with `retryable == true` and the `idempotencyKey`. If a create or a payout returns a 5xx, look the resource up first (by quote, external id or a list filter), then resend with the same `idempotencyKey` from the error.

Task cancellation stops in-flight attempts and backoff sleeps.

Indicative FX quote endpoints are rate limited per instance; a limited call returns 429 `AUTH_RATE_LIMITED` with a `Retry-After` header, which the SDK honours when it retries.

## Amounts

All amount inputs are **integer cents** (`1999` is 19.99): quote, payin quote, transfer quote and FX `requestAmount`, limits, payable line items. Partner percentage fees are basis points (`100` = 1%); flat fees are cents. Wallet balances are whole tokens (decimal). Convert a major-unit value without float truncation:

```swift
let cents = try Amount.cents(fromMajorUnits: 19.99) // 1999
```

Some inputs take exactly one of two fields; the API answers 400 otherwise:

- `CreateQuoteInput`: `bankAccountId` (bank payout) or `payableId` (pay a payable).
- Payout inputs: `senderWalletAddress` or `walletId` (a managed wallet).

Swaps between different tokens (a transfer quote whose sender and customer tokens differ) need at least 100 USDC, measured on the USDC side; below that the API answers 400 `TRANSFERS_SWAP_AMOUNT_BELOW_MINIMUM` (see [Errors](#errors)).

## Limit increases

`customers(customerId:).listLimitIncreases()` and the `limitIncrease.new` / `limitIncrease.update` webhooks return `LimitIncreaseRequest`. When compliance rejects a request, or approves lower limits than requested, `reviewReason` says why and what to send to get the full amount; the granted limits are in `approvedPerTransaction`, `approvedDaily` and `approvedMonthly` (cents).

## Pagination

List calls return a `ListResult<T>` with `data` and an optional `pagination` (`hasMore`, `nextPage`, `prevPage`). Without `limit` or a cursor the API returns **every** row in one response (`pagination == nil`), so page large lists:

```swift
let page = try await blindpay.instances.payouts.list(params: ListPayoutsInput(limit: 100, status: .completed)).get()
print(page?.data.count ?? 0, page?.pagination?.hasMore ?? false)

// Or let the SDK follow the cursor; pages of 100 are fetched as you iterate.
for try await payout in blindpay.instances.payouts.listAutoPaging(params: ListPayoutsInput(status: .completed)) {
    print(payout.id)
}
```

Auto-pagers exist for payouts, payins, customers, transfers, payables and managed-wallet deposits (`custodialWallets.getDepositsAutoPaging(id:)`). They only go forward, so `endingBefore` is rejected. Every list input takes all the filters the API supports and never sends unset values.

## Enums

Every enum is open: a value the API adds later (a network, token, status or webhook event) decodes instead of failing the whole response. Known values read like enum cases; a `switch` needs a `default`:

```swift
switch payout.status {
case .completed: print("done")
case .failed: print("failed")
default: print("other status: \(payout.status.rawValue)")
}
```

## Webhooks

Verify the **raw** request body, exactly as received. Re-encoding parsed JSON changes the bytes and fails verification. Verification needs no client:

```swift
// Vapor:  let body = Data(buffer: req.body.data!)
// Any framework: the raw bytes and the request headers.
do {
    let event = try Webhooks.constructEvent(payload: body, headers: headers, secret: webhookSecret)
    switch event {
    case .payoutComplete(let payout), .payoutUpdate(let payout):
        // A failed payout can arrive on either event: branch on the status.
        if payout.status == .failed { /* handle the failure */ }
    case .payinComplete(let payin):
        print(payin.id)
    case .unknown(let type, let raw):
        print("unhandled event \(type), \(raw.count) bytes")
    default:
        break
    }
} catch {
    // BlindPayError.webhookVerificationFailed: answer 400
}
```

- `Webhooks.verify(payload:headers:secret:tolerance:)` returns a `Bool` and never throws. The default tolerance is 300 seconds.
- Deduplicate deliveries on the `svix-id` header.
- Never log your `whsec_` secret. Get it with `instances.webhookEndpoints.getSecret(id:)`.

## Uploads

```swift
let pdf = try Data(contentsOf: URL(fileURLWithPath: "passport.pdf"))
let upload = try await blindpay.upload.create(
    data: UploadInput(file: pdf, fileName: "passport.pdf", contentType: "application/pdf", bucket: .onboarding)
).get()

// Rate how likely compliance is to accept a document before submitting it.
let rating = try await blindpay.upload.analyze(
    data: UploadAnalyzeInput(file: pdf, fileName: "passport.pdf", contentType: "application/pdf", type: .passport,
                             metadata: ["full_name": "Jane Doe"])
).get()

// A temporary signed URL for an uploaded file.
let signed = try await blindpay.upload.presign(fileUrl: upload!.fileUrl).get()
```

Uploads are `multipart/form-data`, are never retried, and require a finished onboarding.

## Testing against a development instance

- Payout amounts `66600` end as failed and `77700` as refunded.
- Development payins complete after about 30 seconds.
- Quotes expire after 5 minutes (OTC payin quotes after 10 seconds; SEPA quotes may expire earlier).
- Development instances are rate limited per instance on every route (429 `AUTH_RATE_LIMITED` with `Retry-After`, which the SDK honours).
- The `getTrack` methods call public tracking endpoints meant for BlindPay's web and iOS apps; server-side calls get 401 in production. Use `get` instead.

## Documentation

- [BlindPay API documentation](https://blindpay.com/docs/introduction)
- [API reference](https://api.blindpay.com/reference)

Maintainers: the release process is in [RELEASING.md](RELEASING.md).

## Support

- Issues: [GitHub Issues](https://github.com/blindpaylabs/blindpay-swift/issues)

## License

This project is licensed under the MIT License; see [LICENSE](LICENSE).
