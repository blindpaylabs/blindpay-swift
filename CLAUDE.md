# BlindPay Swift SDK -- Agent Reference

This document is optimized for an AI agent modifying this codebase. It describes the project structure, conventions, and step-by-step procedures for common changes.

## 1. Project Structure

```
blindpay-swift/
  Package.swift                         # SPM manifest. swift-tools-version: 5.7. Platforms: iOS 15+, macOS 12+, tvOS 15+, watchOS 8+.
  Sources/BlindPay/
    blindpay_swift.swift                # Empty entry point (ASCII art only).
    Core/
      BlindPay.swift                    # Main client class. Facade that duplicates every service method as a flat convenience method AND exposes service objects.
      Configuration.swift               # Configuration struct (baseURL only).
    API/
      APIClient.swift                   # Internal HTTP client. Generic request<T: Codable>() method. Handles APIResponse<T> envelope and error decoding.
      Errors.swift                      # BlindPayError enum (invalidURL, invalidResponse, encodingError, decodingError, networkError, httpError).
    Models/
      APIResponse.swift                 # APIResponse<T> and APIError. Generic response envelope.
      Common.swift                      # Country enum (ISO 3166-1 alpha-2), PaginationParams, PaginationMetadata.
      Available.swift                   # Rail, BankAccountType, AccountClass, RecipientRelationship, NaicsCode, RailResponse, BankDetailKey, BankDetailItem, BankDetailField, SwiftCodeResponse.
      Instance.swift                    # InstanceMemberRole, InstanceMember, UpdateInstanceInput, UpdateMemberRoleInput, VoidResponse.
      Receiver.swift                    # KYCType, ReceiverType, IDDocType, ProofOfAddressDocType, SourceOfFundsDocType, PurposeOfTransactions, OwnerRole, ReceiverOwner, CreateReceiverInput, Receiver (full model), UpdateReceiverInput, response types, ListReceiversResponse.
      ApiKey.swift                      # ApiKeyPermission, ApiKey, CreateApiKeyInput, CreateApiKeyResponse.
      BankAccount.swift                 # BankAccount, CreateBankAccountInput, CreateBankAccountResponse, SpeiProtocol, TransfersType + related enums.
      BlockchainWallet.swift            # BlockchainWallet, CreateBlockchainWalletInput, BlockchainWalletSignMessageResponse, asset trustline types, mint USDB types, Solana delegate types.
      CustodialWallet.swift             # CustodialWallet, CreateCustodialWalletInput, WalletTokenBalance, CustodialWalletBalanceResponse.
      Fee.swift                         # FeeOptions, FeesResponse (per-rail fee structure).
      OfframpWallet.swift               # OfframpWallet, CreateOfframpWalletInput, CreateOfframpWalletResponse.
      PartnerFee.swift                  # PartnerFee, CreatePartnerFeeInput, CreatePartnerFeeResponse.
      Payin.swift                       # PayinStatus, PaymentMethod, PayinType, PayinTrackingTransaction, Payin, CreatePayinInput, ListPayinsInput, response types.
      PayinQuote.swift                  # PayinQuotePayerRules, PayinQuote, CreatePayinQuoteInput, ListPayinQuotesInput, response types.
      Payout.swift                      # PayoutStatus, TrackingStep, ProviderStatus, PaymentType, Payout, CreatePayoutEvmInput, CreatePayoutStellarInput, CreatePayoutSolanaInput, AuthorizeStellarInput/Response, AuthorizeSolanaInput/Response, ListPayoutsInput, response types.
      Quote.swift                       # CurrencyType, Network, StablecoinToken, TransactionDocumentType, Currency, CreateQuoteInput, QuoteNetwork, QuoteContract, CreateQuoteResponse, GetFxRateInput, GetFxRateResponse, AnyCodable helper.
      ReceiverLimits.swift              # SupportingDocumentType, LimitIncreaseRequestStatus, PayinLimits, PayoutLimits, ReceiverLimitsResponse, RequestLimitIncreaseInput/Response, LimitIncreaseRequest.
      TermsOfService.swift              # InitiateTosInput, InitiateTosResponse.
      Transaction.swift                 # TransactionStatus, TrackingTransaction, TrackingPayment, TrackingLiquidity, TrackingComplete, TrackingPartnerFee.
      Transfer.swift                    # TransferTrackingStep, TransferTrackingTransactionMonitoring, Transfer.
      VirtualAccount.swift              # BankingPartner, BlockchainWalletRef, VirtualAccountAccountType, VirtualAccountACH, VirtualAccount, CreateVirtualAccountInput, UpdateVirtualAccountInput, response types.
      WebhookEndpoint.swift             # WebhookEvent, WebhookEndpoint, CreateWebhookEndpointInput, CreateWebhookEndpointResponse, WebhookEndpointSecret, WebhookPortalAccess, DeleteWebhookEndpointResponse.
    Services/
      AvailableService.swift            # Top-level service. No instanceId. Methods: getRails, getBankDetails, getSwiftCode.
      InstancesService.swift            # Instance-scoped service. Holds sub-services (apiKeys, partnerFees, quotes, webhookEndpoints, payins, payouts, termsOfService). Direct methods for members, receivers, asset trustline, mint, delegate. Factory method: receivers(receiverId:) -> ReceiversService.
      ReceiversService.swift            # Receiver-scoped service. Holds sub-services (blockchainWallets, virtualAccounts, bankAccounts, custodialWallets). No direct methods -- purely a sub-service container.
      ApiKeysService.swift              # CRUD for API keys. Instance-scoped.
      BankAccountsService.swift         # CRUD for bank accounts. Receiver-scoped. Holds sub-service: offrampWallets.
      BlockchainWalletsService.swift    # CRUD for blockchain wallets + getSignMessage. Receiver-scoped.
      CustodialWalletsService.swift     # CRUD + getBalance for custodial wallets. Receiver-scoped.
      OfframpWalletsService.swift       # List/create/get for offramp wallets. Instance-scoped (takes receiverId + bankAccountId as params).
      PartnerFeesService.swift          # CRUD for partner fees. Instance-scoped.
      PayinQuotesService.swift          # Create/get/list + getFxRate. Instance-scoped. Nested under PayinsService.
      PayinsService.swift               # List/get/getTrack/createEvm. Instance-scoped. Holds sub-service: quotes (PayinQuotesService).
      PayoutsService.swift              # List/get/getTrack/createEvm/createStellar/createSolana/authorizeStellar/authorizeSolana. Instance-scoped.
      QuotesService.swift               # Create + getFxRate. Instance-scoped.
      TermsOfServiceService.swift       # Initiate TOS. Instance-scoped.
      VirtualAccountsService.swift      # CRUD for virtual accounts. Receiver-scoped.
      WebhookEndpointsService.swift     # CRUD + getSecret + getPortalAccessUrl. Instance-scoped.
  Examples/
    GetRails.swift                      # Executable example target.
  Tests/blindpay-swiftTests/
    BlindPayTests.swift                 # Initialization test.
    BlindPayErrorTests.swift            # Error description tests.
    ConfigurationTests.swift            # Configuration tests.
```

### Service hierarchy (access path from client)

```
BlindPay
  .available                         -> AvailableService
  .instances                         -> InstancesService
    .apiKeys                           -> ApiKeysService
    .partnerFees                       -> PartnerFeesService
    .quotes                            -> QuotesService
    .webhookEndpoints                  -> WebhookEndpointsService
    .payins                            -> PayinsService
      .quotes                            -> PayinQuotesService
    .payouts                           -> PayoutsService
    .termsOfService                    -> TermsOfServiceService
    .receivers(receiverId:)            -> ReceiversService
      .blockchainWallets                 -> BlockchainWalletsService
      .virtualAccounts                   -> VirtualAccountsService
      .bankAccounts                      -> BankAccountsService
        .offrampWallets                    -> OfframpWalletsService
      .custodialWallets                  -> CustodialWalletsService
```

IMPORTANT: `BlindPay.swift` (the facade) duplicates every service method as a flat convenience method on the root `BlindPay` class. When you add or modify a service method, you MUST also add or update the corresponding convenience method in `BlindPay.swift`.

---

## 2. Conventions

### Naming

- **Files**: PascalCase matching the primary type. Model files go in `Models/`, service files in `Services/`.
- **Service classes**: `{Resource}Service` (e.g., `ApiKeysService`, `BlockchainWalletsService`). Plural nouns.
- **Model structs**: Match the API resource name. PascalCase. (e.g., `BlockchainWallet`, `PartnerFee`).
- **Input structs**: `Create{Resource}Input`, `Update{Resource}Input`, `List{Resource}Input`, `Delete{Resource}Input`.
- **Response types**: `Create{Resource}Response`, `{Resource}Response`, `List{Resource}Response`. For list responses returning raw arrays, use `typealias {Resource}sResponse = [{Resource}]`.
- **Enums**: PascalCase type name, camelCase cases. Raw values are the snake_case API string values.
- **Properties**: camelCase in Swift. `CodingKeys` maps to snake_case API field names.
- **Service method names**: `list()`, `get(id:)`, `create(data:)`, `delete(id:)`, `update(id:data:)`. For non-CRUD methods, use descriptive verbs (e.g., `getSignMessage()`, `getFxRate(data:)`, `getTrack(payinId:)`).

### Swift Patterns

- All public types conform to `Codable` and `Sendable`.
- Response model structs also conform to `Equatable`.
- All service classes: `@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) public final class ... : Sendable`.
- Service classes hold `private let apiClient: APIClient` (and `instanceId`, `receiverId`, etc. as needed).
- Initializers are `internal` on service classes, `public` on model structs.
- All API methods are `public func ... async throws -> APIResponse<T>`.
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

Some Input types implement custom `encode(to:)` to:
- Convert amounts from Double to Int (smallest unit: `Int(requestAmount * 100)`)
- Skip nil optional fields with `encodeIfPresent`

Only add custom encoding when the API expects a different type than the Swift property stores (e.g., amount conversion). Do not add it merely to skip nils -- Codable already skips nils with optional properties.

### Query Parameters Pattern

For `list()` methods with filters, define a dedicated input type with a `toQueryParameters() -> [String: String]` method, or build the dictionary inline in the service method. Query parameter keys use snake_case (matching the API).

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

public enum InvoiceStatus: String, Codable, Sendable {
    case draft = "draft"
    case sent = "sent"
    case paid = "paid"
}

// MARK: - Invoice

public struct Invoice: Codable, Sendable, Equatable {
    public let id: String
    public let status: InvoiceStatus
    public let amount: Double
    public let createdAt: String

    public init(id: String, status: InvoiceStatus, amount: Double, createdAt: String) {
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
    public let amount: Double

    public init(amount: Double) {
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

    public func list() async throws -> APIResponse<InvoicesResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/invoices",
            method: .get
        )
    }

    public func get(id: String) async throws -> APIResponse<InvoiceResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/invoices/\(id)",
            method: .get
        )
    }

    public func create(data: CreateInvoiceInput) async throws -> APIResponse<CreateInvoiceResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/invoices",
            method: .post,
            body: data
        )
    }

    public func delete(id: String) async throws -> APIResponse<VoidResponse> {
        return try await apiClient.request(
            endpoint: "/v1/instances/\(instanceId)/invoices/\(id)",
            method: .delete
        )
    }
}
```

### Step 3: Wire the service into the parent

In `InstancesService.swift`:
1. Add a public property: `public let invoices: InvoicesService`
2. Initialize it in `init(...)`: `self.invoices = InvoicesService(apiClient: apiClient, instanceId: instanceId)`

### Step 4: Add convenience methods to BlindPay.swift

In `BlindPay.swift`, add flat convenience methods that delegate to the service. Follow the existing pattern -- each method should have full doc comments with examples, matching the service method signature but with a descriptive verb name (e.g., `listInvoices`, `getInvoice`, `createInvoice`, `deleteInvoice`).

### Step 5: No Package.swift changes needed

All `.swift` files under `Sources/BlindPay/` are automatically included by SPM. No target configuration changes are needed.

---

## 4. How to Add a Method to an Existing Service

1. **Add Input/Response types** to the corresponding model file if they do not exist. Follow naming conventions.
2. **Add the method** to the service class file. Match the method signature pattern of existing methods.
3. **Add the convenience method** to `BlindPay.swift` with full doc comments. This is mandatory -- the facade must mirror every service method.

Example -- adding `update(id:data:)` to `ApiKeysService`:

In `ApiKey.swift`, add `UpdateApiKeyInput` and `UpdateApiKeyResponse`.

In `ApiKeysService.swift`:
```swift
public func update(id: String, data: UpdateApiKeyInput) async throws -> APIResponse<UpdateApiKeyResponse> {
    return try await apiClient.request(
        endpoint: "/v1/instances/\(instanceId)/api-keys/\(id)",
        method: .put,
        body: data
    )
}
```

In `BlindPay.swift`, add:
```swift
public func updateApiKey(id: String, data: UpdateApiKeyInput) async throws -> APIResponse<UpdateApiKeyResponse> {
    return try await apiClient.request(
        endpoint: "/v1/instances/\(instanceId)/api-keys/\(id)",
        method: .put,
        body: data
    )
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

Add the new case to the enum. The raw value must match the API's string exactly.

```swift
public enum InvoiceStatus: String, Codable, Sendable {
    case draft = "draft"
    case sent = "sent"
    case paid = "paid"
    case cancelled = "cancelled"  // new case
}
```

### Changing a field type

Update the property type, the init parameter type, and any custom encoding/decoding logic. Verify all call sites compile.

---

## 6. How to Remove a Resource

1. **Delete the model file**: `Sources/BlindPay/Models/{Resource}.swift`.
2. **Delete the service file**: `Sources/BlindPay/Services/{Resource}Service.swift`.
3. **Remove the service property** from its parent service (e.g., remove `public let invoices: InvoicesService` and its initialization from `InstancesService`).
4. **Remove all convenience methods** from `BlindPay.swift` that reference the deleted types.
5. **Search the codebase** for any remaining references to the deleted types and remove them. Check `ReceiversService.swift` and other service containers.
6. No `Package.swift` changes needed.

---

## 7. How to Add a Sub-Resource (Nested Service Pattern)

Sub-resources are services accessed through a parent service. Example: `BlockchainWalletsService` is a sub-resource of `ReceiversService`.

### Pattern: Static sub-service (initialized in parent init)

Use when the sub-resource shares the same parent IDs for all operations.

In the parent service class:

```swift
public final class ReceiversService: Sendable {
    // ...existing properties...

    public let blockchainWallets: BlockchainWalletsService

    init(apiClient: APIClient, instanceId: String, receiverId: String) {
        // ...existing init...
        self.blockchainWallets = BlockchainWalletsService(
            apiClient: apiClient,
            instanceId: instanceId,
            receiverId: receiverId
        )
    }
}
```

The sub-service stores the IDs it needs and uses them in its endpoint paths.

### Pattern: Factory method (creates service per call)

Use when a dynamic ID is needed at access time. Example: `InstancesService.receivers(receiverId:)`.

```swift
public func receivers(receiverId: String) -> ReceiversService {
    return ReceiversService(
        apiClient: apiClient,
        instanceId: instanceId,
        receiverId: receiverId
    )
}
```

### Endpoint path construction

Sub-resources build endpoints by nesting path segments. Follow the REST pattern:

```
/v1/instances/{instanceId}/receivers/{receiverId}/blockchain-wallets
/v1/instances/{instanceId}/receivers/{receiverId}/blockchain-wallets/{id}
/v1/instances/{instanceId}/receivers/{receiverId}/bank-accounts/{bankAccountId}/offramp-wallets
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

Tests are minimal -- they cover initialization, error descriptions, and configuration defaults. There are no network-level tests or mocked API tests.

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

## 9. Versioning

- Versioning is git-tag-based. There is no version string in the code.
- The SDK reports its version via the User-Agent header in `APIClient.swift` using `CFBundleShortVersionString`, which resolves at runtime from the host app's bundle.
- SPM resolves the version from git tags when consumers add the package dependency.
- Do NOT add version constants to the source code.

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
| `string` (enum)    | `enum: String, Codable, Sendable`         |
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

Paginated endpoints return a wrapper struct:

```swift
public struct List{Resource}Response: Codable, Sendable, Equatable {
    public let data: [{Resource}]
    public let pagination: PaginationMetadata  // or Pagination
}
```

Non-paginated list endpoints use `typealias {Resource}sResponse = [{Resource}]`.

### Amount fields

The API uses integer amounts in smallest currency unit (e.g., 100 = $1.00). Some Input types accept `Double` in Swift and convert to `Int` in custom `encode(to:)`:

```swift
try container.encode(Int(requestAmount * 100), forKey: .requestAmount)
```

### HTTP methods

The `HTTPMethod` enum in `APIClient.swift` supports: `.get`, `.post`, `.put`, `.patch`, `.delete`.
