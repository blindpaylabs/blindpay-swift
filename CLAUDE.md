# BlindPay Swift SDK -- Agent Reference

This document is optimized for an AI agent modifying this codebase. It describes the project structure, conventions, and step-by-step procedures for common changes.

## 1. Project Structure

```
blindpay-swift/
  Package.swift                         # swift-tools-version 6.0 (Swift 6 language mode). iOS 15+, macOS 12+, tvOS 15+, watchOS 8+, Linux. Only dependency: apple/swift-crypto, Linux only.
  Sources/BlindPay/
    Core/
      BlindPay.swift                    # Client + flat facade. Every facade method delegates to a service; never an endpoint literal here.
      Configuration.swift               # baseURL, timeout (60 s per attempt), maxRetries (2), transport; internal sleep/jitter test seams.
      RequestOptions.swift              # Per-call idempotencyKey, timeout, headers.
      OpenEnum.swift                    # Protocol every SDK enum conforms to (forward-compatible string enums).
      Amount.swift                      # Public Amount.cents(fromMajorUnits:): major units -> rounded integer cents.
      Version.swift                     # BlindPaySDK.version: single source of the release version and User-Agent.
    API/
      APIClient.swift                   # request()/requestMultipart(): serialise once, attempt loop, per-attempt timeout, idempotency keys, error mapping. Internal.
      HTTPTransport.swift               # Public HTTPTransport protocol, URLSessionTransport (delegate-based), HTTPTransportError.
      RetryPolicy.swift                 # The retry decision table shared by every BlindPay SDK.
      Endpoint.swift                    # Path type: interpolated values are percent-encoded path segments.
      QueryParameters.swift             # Ordered query items; nil/empty values are never sent.
      AutoPager.swift                   # CursorPaginatedInput + the AsyncThrowingStream behind listAutoPaging.
      MultipartFormData.swift           # multipart/form-data body builder (uploads).
      Errors.swift                      # BlindPayError.
    Models/                             # One file per resource: OpenEnum enums, response structs, inputs. Rfi, Payable, WebhookPayloads, ...
    Services/                           # One service per resource (see the hierarchy below).
    Webhooks/
      Webhooks.swift                    # Standalone Svix verifier: verify(...) -> Bool, constructEvent(...) -> WebhookEvent.
      WebhookEvent.swift                # Typed webhook union, one case per event, plus unknown(type:payload:).
  Examples/GetRails.swift               # Example target (`swift run GetRails`); not a product.
  Tests/blindpay-swiftTests/
    OpCoverageTests.swift               # All 94 operations: method + path, and every fixture variant decodes.
    ClientBehaviorTests.swift           # Headers, idempotency keys, one test per retry-table row, errors, incomplete responses.
    PaginationTests.swift, WebhookTests.swift, OpenEnumTests.swift, RedactionTests.swift, PathEncodingTests.swift, ...
    RequestOptionsGuardTests.swift      # Source scan: every public API method takes and forwards `options`.
    SyncScriptTests.swift               # Tests for .api-sync/sync.swift.
    Support/MockServer.swift            # URLProtocol mock: one host per MockServer; records requests and sleeps.
    Support/Fixtures.swift              # Loader for Fixtures/ by "METHOD /v1/path" and variant.
    Fixtures/                           # Verbatim copy of the shared spec fixtures. Don't hand-edit; re-copy.
    Vectors/webhook-vectors.json        # The 14 shared Svix vectors.
```

### Service hierarchy (access path from client)

```
BlindPay
  .available                         -> AvailableService (rails, bank details, swift, NAICS)
  .upload                            -> UploadService (create, analyze, presign)
  .instances                         -> InstancesService (get, update, delete, members, fees, Solana/Stellar helpers)
    .customers                         -> InstanceCustomersService (list, listAutoPaging, create)
    .partnerFees / .quotes / .webhookEndpoints / .termsOfService
    .payins (.quotes) / .payouts / .transfers / .transferQuotes / .payables
    .onboarding                        -> OnboardingService
    .rfi                               -> InstanceRfiService
  .customers(customerId:)            -> CustomersService (get, update, delete, getLimits, requestLimitIncrease, listLimitIncreases)
    .rfi                               -> CustomerRfiService
    .blockchainWallets / .virtualAccounts / .custodialWallets
    .bankAccounts                      -> BankAccountsService
      .offrampWallets                    -> OfframpWalletsService
```

IMPORTANT: every operation lives on a service. `BlindPay.swift` (the facade) has a flat method for every instance-level operation (and the customer get/update/delete/limits/RFI ones), and each facade method only delegates (`return try await instances.payables.get(id: id, options: options)`). Never put an endpoint literal in the facade. Customer-scoped sub-resources (bank accounts, wallets, virtual accounts) are reached through `customers(customerId:)` and have no flat methods.

---

## 2. Conventions

### Naming

- **Files**: PascalCase matching the primary type. Model files go in `Models/`, service files in `Services/`.
- **Service classes**: `{Resource}Service` (e.g., `PartnerFeesService`, `BlockchainWalletsService`). Plural nouns.
- **Model structs**: Match the API resource name. PascalCase. (e.g., `BlockchainWallet`, `PartnerFee`).
- **Input structs**: `Create{Resource}Input`, `Update{Resource}Input`, `List{Resource}Input`, `Delete{Resource}Input`.
- **Response types**: `Create{Resource}Response`, `{Resource}Response`. Lists: a paginated list (payouts, payins, customers, transfers, payables, wallet deposits) is `typealias List{Resource}sResponse = ListResult<{Resource}>`; a list the API always returns as a bare array (bank accounts, blockchain/managed/offramp wallets, virtual accounts, limit increases, partner fees, members, webhook endpoints, available/*) is `typealias {Resource}sResponse = [{Resource}]`.
- **Enums**: PascalCase type name, camelCase cases. Raw values are the snake_case API string values.
- **Properties**: camelCase in Swift. `CodingKeys` maps to snake_case API field names.
- **Service method names**: `list()`, `get(id:)`, `create(data:)`, `delete(id:)`, `update(id:data:)`. For non-CRUD methods, use descriptive verbs (e.g., `getSignMessage()`, `getFxRate(data:)`, `getTrack(payinId:)`).

### Swift Patterns

- All public types conform to `Codable` and `Sendable`. Exception: multipart inputs (`UploadInput`) are only `Sendable`, because they are never JSON-encoded.
- Response model structs also conform to `Equatable`.
- All service classes: `@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) public final class ... : Sendable`.
- Service classes hold `private let apiClient: APIClient` (and `instanceId`, `customerId`, etc. as needed).
- Initializers are `internal` on service classes, `public` on model structs.
- All API methods are `public func ... async throws -> APIResponse<T>` and take a trailing `options: RequestOptions? = nil` that they forward as `options: options`. RequestOptionsGuardTests fails otherwise.
- Endpoints are `Endpoint` string interpolations: interpolated values are percent-encoded as one path segment, so pass raw ids.
- Enums are `public struct X: OpenEnum` with `public static let` values (see "Adding an enum case"). Never add a closed `enum X: String` for API values: an unknown value would fail the whole response.
- Amount inputs are integer cents (`Int`). Don't take `Double` dollars; point callers at `Amount.cents(fromMajorUnits:)`.
- Request-side "exactly one of" pairs (quote `bankAccountId`/`payableId`, payout `senderWalletAddress`/`walletId`) are both optional; no client-side check.
- Lists return `ListResult<T>` (decodes both the bare array and `{data, pagination}`). Every op whose spec accepts `starting_after` gets a `listAutoPaging` returning `AsyncThrowingStream` via `AutoPager.stream`, and its input conforms to `CursorPaginatedInput`.
- Provider-named spec fields (`aiprise_*`, `checkbook_*`, `onemoney_*`, `circle_wallet_id`, ...) are not modelled; record them in `unmodeled.json`.
- Optional fields on model structs use `T?` and have default `nil` in init.
- Types that contain `AnyCodable` or similar non-Sendable values use `@unchecked Sendable` instead of plain `Sendable`.

### CodingKeys Pattern

When a struct has any property whose JSON key differs from the Swift name (snake_case to camelCase), add an explicit `enum CodingKeys: String, CodingKey` with ALL properties mapped. Use `= "snake_case_name"` only for keys that differ. Example:

```swift
enum CodingKeys: String, CodingKey {
    case id
    case firstName = "first_name"
    case lastName = "last_name"
    case createdAt = "created_at"
}
```

If ALL properties match their JSON keys exactly (no snake_case conversion needed), omit CodingKeys entirely and rely on synthesized conformance.

### Custom encode(to:) Pattern

Add a custom `encode(to:)` only when the wire shape differs from the synthesized one:
- a required key that accepts `null` (encode the optional with `encode`, not `encodeIfPresent`; see `RequestLimitIncreaseInput`);
- a tri-state field (unchanged / set / clear; see `UpdateOfframpWalletInput`).

Codable already skips nil optionals; don't add custom encoding just for that.

### Query Parameters Pattern

For `list()` methods with filters, define a `List{Resource}Input` with every filter the spec declares and a `toQueryParameters() -> QueryParameters` that assigns each one (`params["customer_id"] = customerId`; `limit.map(String.init)`; `status?.rawValue`). `QueryParameters` keeps insertion order and drops nil/empty values. `limit` is `Int?`; `offset` stays only as a deprecated property (the API ignores it).

---

## 3. How to Add a New Resource

Example: adding a resource called "Invoice" under instances.

### Step 1: Create the model file

Create `Sources/BlindPay/Models/Invoice.swift`:

```swift
//
//  Invoice.swift
//  blindpay-swift
//

import Foundation

// MARK: - Enums (if any)

public struct InvoiceStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let draft = InvoiceStatus(rawValue: "draft")
    public static let sent = InvoiceStatus(rawValue: "sent")
    public static let paid = InvoiceStatus(rawValue: "paid")
}

// MARK: - Invoice

public struct Invoice: Codable, Sendable, Equatable {
    public let id: String
    public let status: InvoiceStatus
    /// Amount in cents.
    public let amount: Int
    public let createdAt: String

    public init(id: String, status: InvoiceStatus, amount: Int, createdAt: String) {
        self.id = id
        self.status = status
        self.amount = amount
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case amount
        case createdAt = "created_at"
    }
}

// MARK: - Response Types

public typealias InvoicesResponse = [Invoice]
public typealias InvoiceResponse = Invoice

// MARK: - Input Types

public struct CreateInvoiceInput: Codable, Sendable {
    /// Amount in cents.
    public let amount: Int

    public init(amount: Int) {
        self.amount = amount
    }
}

public struct CreateInvoiceResponse: Codable, Sendable, Equatable {
    public let id: String

    public init(id: String) {
        self.id = id
    }
}
```

### Step 2: Create the service file

Create `Sources/BlindPay/Services/InvoicesService.swift`:

```swift
//
//  InvoicesService.swift
//  blindpay-swift
//

import Foundation

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class InvoicesService: Sendable {
    private let apiClient: APIClient
    private let instanceId: String

    init(apiClient: APIClient, instanceId: String) {
        self.apiClient = apiClient
        self.instanceId = instanceId
    }

    public func list(options: RequestOptions? = nil) async throws -> APIResponse<InvoicesResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/invoices",
            method: .get,
            options: options
        )
    }

    public func get(id: String, options: RequestOptions? = nil) async throws -> APIResponse<InvoiceResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/invoices/\(id)",
            method: .get,
            options: options
        )
    }

    public func create(data: CreateInvoiceInput, options: RequestOptions? = nil) async throws -> APIResponse<CreateInvoiceResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/invoices",
            method: .post,
            body: data,
            options: options
        )
    }

    public func delete(id: String, options: RequestOptions? = nil) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/invoices/\(id)",
            method: .delete,
            options: options
        )
    }
}
```

### Step 3: Wire the service into the parent

In `InstancesService.swift`:
1. Add a public property: `public let invoices: InvoicesService`
2. Initialize it in `init(...)`: `self.invoices = InvoicesService(apiClient: apiClient, instanceId: instanceId)`

### Step 4: Add convenience methods to BlindPay.swift

In `BlindPay.swift`, add flat convenience methods that delegate to the service. Each method has full doc comments with examples, matches the service method signature, and uses a descriptive verb name (e.g., `listInvoices`, `getInvoice`, `createInvoice`, `deleteInvoice`). Never repeat the endpoint literal in the facade:

```swift
public func createInvoice(data: CreateInvoiceInput, options: RequestOptions? = nil) async throws -> APIResponse<CreateInvoiceResponse> {
    return try await instances.invoices.create(data: data, options: options)
}
```

### Step 5: No Package.swift changes needed

All `.swift` files under `Sources/BlindPay/` are automatically included by SPM. No target configuration changes are needed.

---

## 4. How to Add a Method to an Existing Service

1. **Add Input/Response types** to the corresponding model file if they do not exist. Follow naming conventions.
2. **Add the method** to the service class file. Match the method signature pattern of existing methods.
3. **Add the convenience method** to `BlindPay.swift` with full doc comments. This is mandatory -- the facade must mirror every service method.

Example -- adding `update(id:data:)` to `PartnerFeesService`:

In `PartnerFee.swift`, add `UpdatePartnerFeeInput` and `UpdatePartnerFeeResponse`.

In `PartnerFeesService.swift`:
```swift
public func update(id: String, data: UpdatePartnerFeeInput, options: RequestOptions? = nil) async throws -> APIResponse<UpdatePartnerFeeResponse> {
    return try await apiClient.request(
        endpoint: "/v1/instances/\(instanceId)/partner-fees/\(id)",
        method: .put,
        body: data,
        options: options
    )
}
```

In `BlindPay.swift`, add a method that delegates to the service:
```swift
public func updatePartnerFee(id: String, data: UpdatePartnerFeeInput, options: RequestOptions? = nil) async throws -> APIResponse<UpdatePartnerFeeResponse> {
    return try await instances.partnerFees.update(id: id, data: data, options: options)
}
```

---

## 5. How to Modify Types (Codable Fields, CodingKeys)

### Adding a field

1. Add the property to the struct with the correct type. If it can be absent from JSON, make it optional (`T?`).
2. Add a default value in the `init` parameter list if optional: `newField: String? = nil`.
3. Add the mapping in `CodingKeys` if the JSON key is snake_case: `case newField = "new_field"`.
4. If the struct has a custom `encode(to:)`, add the new field there too (use `encodeIfPresent` for optionals).

### Removing a field

1. Remove the property, its init parameter, its CodingKeys case, and any custom encoding logic.
2. Search the codebase for references to the removed field and update all call sites.

### Renaming a field

1. Change the Swift property name.
2. Keep the CodingKeys raw value unchanged (it must match the API JSON key).
3. Update all call sites.

### Adding an enum case

Add a `public static let` to the `OpenEnum` struct. The raw value must match the API's string exactly. `sync.swift --apply` does this itself for mapped enums.

```swift
public struct InvoiceStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let draft = InvoiceStatus(rawValue: "draft")
    public static let paid = InvoiceStatus(rawValue: "paid")
    public static let cancelled = InvoiceStatus(rawValue: "cancelled")  // new value
}
```

Register a new enum in `.api-sync/spec-map.json` `enums[]` so sync keeps it in step with the spec.

### Changing a field type

Update the property type, the init parameter type, and any custom encoding/decoding logic. Verify all call sites compile.

---

## 6. How to Remove a Resource

1. **Delete the model file**: `Sources/BlindPay/Models/{Resource}.swift`.
2. **Delete the service file**: `Sources/BlindPay/Services/{Resource}Service.swift`.
3. **Remove the service property** from its parent service (e.g., remove `public let invoices: InvoicesService` and its initialization from `InstancesService`).
4. **Remove all convenience methods** from `BlindPay.swift` that reference the deleted types.
5. **Search the codebase** for any remaining references to the deleted types and remove them. Check `CustomersService.swift` and other service containers.
6. No `Package.swift` changes needed.

---

## 7. How to Add a Sub-Resource (Nested Service Pattern)

Sub-resources are services accessed through a parent service. Example: `BlockchainWalletsService` is a sub-resource of `CustomersService`.

### Pattern: Static sub-service (initialized in parent init)

Use when the sub-resource shares the same parent IDs for all operations.

In the parent service class:

```swift
public final class CustomersService: Sendable {
    // ...existing properties...

    public let blockchainWallets: BlockchainWalletsService

    init(apiClient: APIClient, instanceId: String, customerId: String) {
        // ...existing init...
        self.blockchainWallets = BlockchainWalletsService(
            apiClient: apiClient,
            instanceId: instanceId,
            customerId: customerId
        )
    }
}
```

The sub-service stores the IDs it needs and uses them in its endpoint paths.

### Pattern: Factory method (creates service per call)

Use when a dynamic ID is needed at access time. Example: `BlindPay.customers(customerId:)`.

```swift
public func customers(customerId: String) -> CustomersService {
    return CustomersService(
        apiClient: apiClient,
        instanceId: instanceId,
        customerId: customerId
    )
}
```

### Endpoint path construction

Sub-resources build endpoints by nesting path segments. Follow the REST pattern:

```
/v1/instances/{instanceId}/customers/{customerId}/blockchain-wallets
/v1/instances/{instanceId}/customers/{customerId}/blockchain-wallets/{id}
/v1/instances/{instanceId}/customers/{customerId}/bank-accounts/{bankAccountId}/offramp-wallets
```

---

## 8. Testing

### Running tests

```bash
swift test
```

### Test framework

Tests use Swift Testing (`import Testing`, `@Test`, `#expect`), not XCTest.

### Test target

The test target is `blindpay-swiftTests` defined in `Package.swift`, located at `Tests/blindpay-swiftTests/`.

### Current test coverage

- **Operation coverage:** `OpCoverageTests` has one call per operation of the SDK surface (keyed as in `Fixtures/index.json`). It checks method and path and decodes every variant (`full`, `required_only`, `nullables_null`, `unknown_enum`, `decimals`; lists `.b0` envelope and `.b1` bare array). A new operation needs a row there. A non-optional field absent in `required_only` or `null` in `nullables_null` is a bug; a cent amount stays `Int` (only genuinely decimal fields get `1234.56` in `decimals`).
- **Transport contract:** `ClientBehaviorTests` covers headers, idempotency keys, one test per retry-table row (no test sleeps: `MockServer` records backoffs) and incomplete responses. A mutation must never be resent after any response arrived.
- **Webhooks:** `WebhookTests` runs the 14 shared vectors at each vector's clock and decodes every webhook fixture into its typed case.
- **Request shape:** use `MockServer` (no network). It gives you a `BlindPay` client wired to a `URLProtocol` mock and records each request:

```swift
let server = MockServer(respondWith: .json(try Fixtures.response("POST /v1/upload", variant: "full")))
let response = try await server.client.upload.create(data: input)
let request = try #require(server.requests.first)
#expect(request.method == "POST")
#expect(request.queryItems == [URLQueryItem(name: "instance_id", value: "in_000000000000")])
```

Use placeholder ids (`in_000000000000`, `test_key`) only.

### Adding a test

Create a new file in `Tests/blindpay-swiftTests/` or add to an existing file:

```swift
import Testing
@testable import BlindPay

struct InvoiceTests {
    @Test func createInvoiceInput() {
        let input = CreateInvoiceInput(amount: 100.0)
        #expect(input.amount == 100.0)
    }
}
```

---

## 8b. API Contract Check

`.api-sync/spec-snapshot.json` is a committed copy of the OpenAPI spec this SDK is
synced against. `.api-sync/check-contract.swift` is a dependency-free script (Foundation
only) that verifies the SDK doesn't lie about the wire contract:

- **Direction A (hard failure)**: every wire key the SDK declares -- `CodingKeys` string
  values and `params["..."]` query-parameter literals -- must exist as a property name or
  a parameter name somewhere in the snapshot, unless listed in `.api-sync/allow-list.json`.
- **Direction B (hard failure)**: mapped enums (currently `WebhookEventType` and
  `CurrencyType`) must cover every enum member the spec declares for them. Extend the
  `mappedEnums` array in the script to add more.

Run it locally:

```bash
swift .api-sync/check-contract.swift
```

When the spec changes (a sync PR), `sync.swift --apply` replaces `.api-sync/spec-snapshot.json`
with the new spec byte for byte, inserts the optional fields and enum values it can, and bumps
`BlindPaySDK.version`. It drops operations marked `x-sdk: false`. Anything it can't decide is
"needs-human": fix the code or record it in a ledger (`unmodeled.json`, `enum-exclusions.json`,
`nested-omissions.json`, `known-divergences.json`, spec-map `ignore`) with a reason and the
`sdk-maintainers` owner. If a genuinely pre-existing divergence can't be fixed in that PR, add an entry to
`.api-sync/allow-list.json` with a `reason` and `owner` -- never use it to silence
something the sync should actually fix.

---

## 9. Versioning

- `BlindPaySDK.version` in `Sources/BlindPay/Core/Version.swift` is the single source of the release version. The User-Agent sends `blindpay-swift/<version>`.
- `release.yml` runs on every push to `main`: it reads the constant and, if tag `v<version>` doesn't exist on the remote yet, creates the tag and a GitHub release. Merging a PR that changes the constant is what releases.
- The API-sync workflow bumps the constant itself: `sync.swift --apply` bumps the patch (or the minor, when its report says `minor`) and writes the new version to its report.
- A hand-written release-bearing PR bumps the constant in the same PR (major for breaking changes, minor for additive ones, patch for fixes).
- SPM consumers resolve versions from the git tags.

---

## 10. OpenAPI to SDK Mapping Rules

### Endpoint to method mapping

| HTTP Method | URL Pattern                          | Service Method Name      |
|-------------|--------------------------------------|--------------------------|
| GET         | /v1/{resource}                       | `list()`                 |
| GET         | /v1/{resource}/{id}                  | `get(id:)`               |
| POST        | /v1/{resource}                       | `create(data:)`          |
| PUT         | /v1/{resource}/{id}                  | `update(id:data:)`       |
| PATCH       | /v1/{resource}/{id}                  | `update(id:data:)`       |
| DELETE      | /v1/{resource}/{id}                  | `delete(id:)`            |
| POST        | /v1/{resource}/{action}              | `{action}(data:)`        |
| GET         | /v1/{resource}/{id}/{sub-action}     | `get{SubAction}(id:)`    |

### Schema to Swift type mapping

| OpenAPI Type       | Swift Type                                |
|--------------------|-------------------------------------------|
| `string`           | `String`                                  |
| `string` (enum)    | `struct X: OpenEnum` (open; see §5)       |
| `integer`          | `Int`                                     |
| `number`           | `Double`                                  |
| `boolean`          | `Bool`                                    |
| `string` (date)    | `String` (not `Date` -- raw ISO string)   |
| `object`           | `struct: Codable, Sendable, Equatable`    |
| `array`            | `[ElementType]`                           |
| `nullable`         | `T?`                                      |

### JSON key to Swift property mapping

API JSON keys are `snake_case`. Swift properties are `camelCase`. The mapping is done via `CodingKeys` enums.

```
snake_case_key  ->  camelCaseProperty  (with CodingKeys: case camelCaseProperty = "snake_case_key")
```

### Response envelope

All API responses are wrapped in `APIResponse<T>` which has `data: T?` and `error: APIError?`. The `APIClient` handles unwrapping the envelope. Methods return `APIResponse<T>` directly -- callers check `.data` and `.error`.

### Paginated list responses

Lists whose endpoint accepts cursors (payouts, payins, customers, transfers, payables, wallet deposits) return `ListResult<Element>` (alias `List{Resource}sResponse`, or `WalletDepositsResponse`): `data` plus optional `pagination`. It decodes both the bare array (no cursor sent) and the `{data, pagination}` envelope. Each has an auto-pager named after its list method: `listAutoPaging(params:)`, or `getDepositsAutoPaging(id:params:)` for `getDeposits(id:params:)`. Every other list is always a bare array: `[{Resource}]`.

### Amount fields

Payout, payin, quote, limit and payable amounts are integer cents (`Int`); partner percentage fees are basis points; wallet balances are whole tokens (`Double`). The spec types cent amounts as `number`, but keep them `Int`. Genuinely decimal fields (quotations, scores, latitude/longitude, `total_fee_amount`, token amounts) are `Double`.

### HTTP methods

The `HTTPMethod` enum in `APIClient.swift` supports: `.get`, `.post`, `.put`, `.patch`, `.delete`.
