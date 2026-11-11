//
//  ClientBehaviorTests.swift
//  blindpay-swift
//
//  Transport contract: headers, idempotency keys (C2), the shared retry table
//  (plan Appendix A2, v3), timeouts, and typed errors (C4). No test sleeps:
//  backoffs are recorded by the mock instead.
//

import Foundation
import Testing
@testable import BlindPay

private let quoteInput = CreatePayinQuoteInput(currencyType: .sender, requestAmount: 10, paymentMethod: .pix, token: .usdc)

private func createQuote(_ client: BlindPay, options: RequestOptions? = nil) async throws -> APIResponse<CreatePayinQuoteResponse> {
    try await client.instances.payins.quotes.create(data: quoteInput, options: options)
}

private func getRails(_ client: BlindPay) async throws -> APIResponse<[RailResponse]> {
    try await client.available.getRails()
}

private let railsBody = (try? Fixtures.response("GET /v1/available/rails", variant: "full")) ?? Data("[]".utf8)
private let quoteBody = (try? Fixtures.response("POST /v1/instances/{instance_id}/payin-quotes", variant: "full")) ?? Data("{}".utf8)

struct RequestHeaderTests {
    @Test func jsonMutationSendsAuthUserAgentContentTypeAndAnAutoKey() async throws {
        let server = MockServer(respondWith: .json(quoteBody))
        _ = try await createQuote(server.client)

        let request = try #require(server.requests.first)
        #expect(request.header("Authorization") == "Bearer test_key")
        #expect(request.header("User-Agent")?.hasPrefix("blindpay-swift/") == true)
        #expect(request.header("Accept") == "application/json")
        #expect(request.header("Content-Type") == "application/json")
        let key = try #require(request.header("Idempotency-Key"))
        #expect(UUID(uuidString: key) != nil)
        #expect(key == key.lowercased())
    }

    @Test func getSendsNoContentTypeAndNoKey() async throws {
        let server = MockServer(respondWith: .json(railsBody))
        _ = try await getRails(server.client)

        let request = try #require(server.requests.first)
        #expect(request.header("Content-Type") == nil)
        #expect(request.header("Idempotency-Key") == nil)
    }

    @Test func bodylessDeleteGetsAKeyButNoContentType() async throws {
        let server = MockServer(respondWith: .ok)
        _ = try await server.client.instances.partnerFees.delete(id: "pf_000000000000")

        let request = try #require(server.requests.first)
        #expect(request.method == "DELETE")
        #expect(request.header("Content-Type") == nil)
        #expect(request.header("Idempotency-Key") != nil)
    }

    @Test func callerKeyAndHeadersAreForwarded() async throws {
        let server = MockServer(respondWith: .json(quoteBody))
        _ = try await createQuote(server.client, options: RequestOptions(idempotencyKey: "order-42", headers: ["X-Trace": "abc", "Authorization": "Bearer stolen"]))

        let request = try #require(server.requests.first)
        #expect(request.header("Idempotency-Key") == "order-42")
        #expect(request.header("X-Trace") == "abc")
        #expect(request.header("Authorization") == "Bearer test_key")
    }

    @Test func noAutoKeyWhenRetriesAreOff() async throws {
        let server = MockServer(respondWith: .json(quoteBody))
        _ = try await createQuote(server.client(maxRetries: 0))
        #expect(server.requests.first?.header("Idempotency-Key") == nil)
    }

    @Test(arguments: ["", String(repeating: "k", count: 256)])
    func invalidCallerKeyIsRejectedBeforeSending(key: String) async throws {
        let server = MockServer(respondWith: .json(quoteBody))
        await #expect(throws: BlindPayError.self) {
            _ = try await createQuote(server.client, options: RequestOptions(idempotencyKey: key))
        }
        #expect(server.requests.isEmpty)
    }

    @Test func a255CharacterKeyIsAccepted() async throws {
        let server = MockServer(respondWith: .json(quoteBody))
        let key = String(repeating: "k", count: 255)
        _ = try await createQuote(server.client, options: RequestOptions(idempotencyKey: key))
        #expect(server.requests.first?.header("Idempotency-Key") == key)
    }

    @Test func queryParametersAreOrderedAndUnsetOnesOmitted() async throws {
        let server = MockServer(respondWith: .json(Data("[]".utf8)))
        _ = try await server.client.instances.payouts.list(params: ListPayoutsInput(limit: "10", startingAfter: "po_000000000000"))
        let request = try #require(server.requests.first)
        #expect(request.queryItems.map(\.name) == ["limit", "starting_after"])
        #expect(request.url.query?.contains("offset") == false)
    }
}

struct RetryTableTests {
    // Row 9: GET retried on 503, then succeeds; no key on GETs.
    @Test func getIsRetriedOn503ThenSucceeds() async throws {
        let server = MockServer(sequence: [.status(503), .json(railsBody)])
        let response = try await getRails(server.client)

        #expect(response.data?.isEmpty == false)
        #expect(server.requests.count == 2)
        #expect(server.requests.allSatisfy { $0.header("Idempotency-Key") == nil })
        #expect(server.sleeps == [0.5])
    }

    @Test(arguments: [408, 500, 502, 504])
    func getIsRetriedOnTransientStatuses(status: Int) async throws {
        let server = MockServer(sequence: [.status(status), .json(railsBody)])
        _ = try await getRails(server.client)
        #expect(server.requests.count == 2)
    }

    // Row 7 (v3): a mutation is never auto-retried on 5xx.
    @Test(arguments: [500, 502, 503])
    func mutationIsNotRetriedOn5xx(status: Int) async throws {
        let server = MockServer(sequence: [.status(status), .json(quoteBody)])
        let response = try await createQuote(server.client)

        #expect(server.requests.count == 1)
        let error = try #require(response.error)
        #expect(error.status == status)
        #expect(error.retryable)
        #expect(error.idempotencyKey == server.requests.first?.header("Idempotency-Key"))
        #expect(error.idempotencyKey != nil)
    }

    // Row 6: 429 is retried for mutations, honouring Retry-After, same key.
    @Test func mutationIsRetriedOn429WithRetryAfterAndTheSameKey() async throws {
        let server = MockServer(sequence: [try .errorFixture("rate_limited_429"), .json(quoteBody)])
        let response = try await createQuote(server.client)

        #expect(response.data != nil)
        #expect(server.requests.count == 2)
        let keys = server.requests.map { $0.header("Idempotency-Key") }
        #expect(keys[0] != nil && keys[0] == keys[1])
        #expect(server.requests[0].body == server.requests[1].body)
        #expect(server.sleeps == [2])
    }

    // Row 5: 409 in-flight is retried; Retry-After > 60 falls back to backoff.
    @Test func inFlight409WithLongRetryAfterUsesBackoff() async throws {
        let server = MockServer(sequence: [.status(409, retryAfter: "120", body: #"{"success":false,"message":"idempotency_key_in_flight"}"#), .json(quoteBody)])
        _ = try await createQuote(server.client)

        #expect(server.requests.count == 2)
        #expect(server.sleeps == [0.5])
    }

    @Test func inFlight409FixtureIsRetriedAfterRetryAfter() async throws {
        let server = MockServer(sequence: [try .errorFixture("idempotency_in_flight_409"), .json(quoteBody)])
        _ = try await createQuote(server.client)
        #expect(server.sleeps == [1])
    }

    @Test func other409IsNotRetried() async throws {
        let server = MockServer(sequence: [.status(409, body: #"{"success":false,"code":"WALLETS_SELF_CUSTODY_ALREADY_SET","message":"already_set"}"#)])
        let response = try await createQuote(server.client)
        #expect(server.requests.count == 1)
        #expect(response.error?.retryable == false)
    }

    // Row 8: a terminal 5xx code is never retried.
    @Test func getWithTerminal502CodeIsNotRetried() async throws {
        let server = MockServer(sequence: [.status(502, body: #"{"success":false,"code":"PAYINS_CARD_PAYMENT_PENDING","message":"pending"}"#), .json(railsBody)])
        let response = try await getRails(server.client)
        #expect(server.requests.count == 1)
        #expect(response.error?.retryable == false)
    }

    // Row 10: other 4xx are terminal.
    @Test(arguments: ["idempotency_key_invalid_400", "idempotency_payload_mismatch_422", "auth_401_no_trace_id"])
    func terminal4xxIsNotRetried(fixture: String) async throws {
        let server = MockServer(sequence: [try .errorFixture(fixture), .json(quoteBody)])
        let response = try await createQuote(server.client)
        #expect(server.requests.count == 1)
        #expect(response.error?.retryable == false)
    }

    @Test func retriesStopAfterMaxRetries() async throws {
        let server = MockServer(respondWith: .status(503))
        let response = try await getRails(server.client)
        #expect(server.requests.count == 3)
        #expect(server.sleeps == [0.5, 1.0])
        #expect(response.error?.status == 503)
    }

    @Test func maxRetriesZeroDisablesRetries() async throws {
        let server = MockServer(respondWith: .status(503))
        _ = try await getRails(server.client(maxRetries: 0))
        #expect(server.requests.count == 1)
    }

    // Row 2: multipart uploads are not retried.
    @Test func multipartIsNotRetried() async throws {
        let server = MockServer(sequence: [.status(503), .json(Data(#"{"file_url":"https://x"}"#.utf8))])
        let input = UploadInput(file: Data("x".utf8), fileName: "a.txt", contentType: "text/plain", bucket: .documents)
        let response = try await server.client.upload.create(data: input)
        #expect(server.requests.count == 1)
        #expect(response.error?.status == 503)
        #expect(server.requests.first?.header("Idempotency-Key") == nil)
    }

    // Row 3: a mutation without a key (retries off) is never retried.
    @Test func mutationWithoutKeyIsNotRetriedOnConnectionError() async throws {
        let server = MockServer(respondWith: .json(quoteBody))
        let transport = ScriptedTransport([.fail(.networkConnectionLost)])
        await #expect(throws: BlindPayError.self) {
            _ = try await createQuote(server.client(transport: transport, maxRetries: 0))
        }
        #expect(transport.attempts == 1)
    }

    // Row 4: no response -> retried with the same key.
    @Test func connectionErrorThenSuccessReusesTheKey() async throws {
        let server = MockServer(respondWith: .json(quoteBody))
        let transport = ScriptedTransport([.fail(.networkConnectionLost)])
        let response = try await createQuote(server.client(transport: transport))

        #expect(response.data != nil)
        #expect(transport.attempts == 2)
        #expect(server.requests.count == 1)
        #expect(server.sleeps == [0.5])
    }

    @Test func timeoutThenSuccessReusesTheKey() async throws {
        let server = MockServer(respondWith: .json(quoteBody))
        let transport = ScriptedTransport([.hang])
        let response = try await createQuote(server.client(transport: transport, timeout: 0.05), options: RequestOptions(idempotencyKey: "resume-1"))

        #expect(response.data != nil)
        #expect(transport.attempts == 2)
        #expect(server.requests.first?.header("Idempotency-Key") == "resume-1")
    }

    @Test func exhaustedTimeoutsThrowWithTheKey() async throws {
        let server = MockServer(respondWith: .json(quoteBody))
        let transport = ScriptedTransport([.hang, .hang])
        do {
            _ = try await createQuote(server.client(transport: transport, maxRetries: 1, timeout: 0.05), options: RequestOptions(idempotencyKey: "resume-2"))
            Issue.record("expected a timeout")
        } catch let error as BlindPayError {
            guard case .timeout(let key) = error else { Issue.record("expected .timeout, got \(error)"); return }
            #expect(key == "resume-2")
        }
        #expect(transport.attempts == 2)
    }

    @Test func networkErrorsAfterRetriesThrowNetworkError() async throws {
        let server = MockServer(respondWith: .json(railsBody))
        let transport = ScriptedTransport([.fail(.cannotFindHost), .fail(.cannotFindHost), .fail(.cannotFindHost)])
        do {
            _ = try await getRails(server.client(transport: transport))
            Issue.record("expected a network error")
        } catch let error as BlindPayError {
            guard case .networkError = error else { Issue.record("expected .networkError, got \(error)"); return }
        }
        #expect(transport.attempts == 3)
    }

    // Row 1: a retry sleep stops when the caller cancels.
    @Test func backoffSleepStopsOnCancellation() async throws {
        let server = MockServer(respondWith: .status(503))
        let base = server.configuration()
        let client = BlindPay(apiKey: "test_key", instanceId: server.instanceId, configuration: Configuration(
            baseURL: base.baseURL, timeout: 60, maxRetries: 2, transport: MockServer.transport,
            sleep: { try await Task.sleep(nanoseconds: UInt64($0 * 60 * 1_000_000_000)) },
            jitter: { 1.0 }))
        let task = Task { try await getRails(client) }
        while server.requests.isEmpty { await Task.yield() }
        let started = Date()
        task.cancel()
        await #expect(throws: CancellationError.self) { _ = try await task.value }
        #expect(Date().timeIntervalSince(started) < 5)
        #expect(server.requests.count == 1)
    }
}

struct RetryDelayTests {
    @Test func backoffDoublesAndCapsAtEightSeconds() {
        #expect(RetryPolicy.delay(attempt: 0, retryAfter: nil, jitter: 1) == 0.5)
        #expect(RetryPolicy.delay(attempt: 3, retryAfter: nil, jitter: 1) == 4)
        #expect(RetryPolicy.delay(attempt: 10, retryAfter: nil, jitter: 1) == 8)
        #expect(RetryPolicy.delay(attempt: 1, retryAfter: nil, jitter: 0.5) == 0.5)
    }

    @Test func retryAfterIsUsedOnlyWhenAnIntegerUpTo60() {
        #expect(RetryPolicy.delay(attempt: 0, retryAfter: "60", jitter: 1) == 60)
        #expect(RetryPolicy.delay(attempt: 0, retryAfter: "61", jitter: 1) == 0.5)
        #expect(RetryPolicy.delay(attempt: 0, retryAfter: "1.5", jitter: 1) == 0.5)
        #expect(RetryPolicy.delay(attempt: 0, retryAfter: "Wed, 21 Oct 2026 07:28:00 GMT", jitter: 1) == 0.5)
    }
}

struct APIErrorTests {
    @Test func errorEnvelopeIsFullyDecoded() async throws {
        let server = MockServer(respondWith: try .errorFixture("api_error_envelope"))
        let response = try await server.client.available.getRails()
        let error = try #require(response.error)

        #expect(error.status == 404)
        #expect(error.code == "CUSTOMERS_NOT_FOUND")
        #expect(error.message == "customer_not_found")
        #expect(error.description == "The customer was not found.")
        #expect(error.errors == [])
        #expect(error.traceId == "0af7651916cd43dd8448eb211c80319c")
        #expect(error.requestId == "req_api_error_envelope")
        #expect(error.retryable == false)
        #expect(throws: APIError.self) { try response.get() }
    }

    @Test func authErrorWithoutTraceIdDecodes() async throws {
        let server = MockServer(respondWith: try .errorFixture("auth_401_no_trace_id"))
        let error = try #require(try await getRails(server.client).error)
        #expect(error.status == 401)
        #expect(error.code == "AUTH_INVALID_API_KEY")
        #expect(error.traceId == nil)
        #expect(error.errors == [])
    }

    @Test func idempotencyErrorWithoutCodeKeepsItsMessage() async throws {
        let server = MockServer(respondWith: try .errorFixture("idempotency_payload_mismatch_422"))
        let error = try #require(try await createQuote(server.client).error)
        #expect(error.code == nil)
        #expect(error.message == "idempotency_key_payload_mismatch")
        #expect(error.errors.count == 1)
    }

    @Test func internalErrorWithoutErrorsArray() async throws {
        let server = MockServer(respondWith: try .errorFixture("internal_error_no_errors_500"))
        let error = try #require(try await getRails(server.client(maxRetries: 0)).error)
        #expect(error.code == "INTERNAL_ERROR")
        #expect(error.errors == [])
        #expect(error.retryable)
    }

    @Test func nonJSON502BecomesAnAPIError() async throws {
        let server = MockServer(respondWith: try .errorFixture("non_json_502"))
        let error = try #require(try await getRails(server.client(maxRetries: 0)).error)
        #expect(error.status == 502)
        #expect(error.code == nil)
        #expect(!error.message.isEmpty)
        #expect(error.retryable)
    }

    @Test func emptyNoContentIsSuccessWithNoData() async throws {
        let server = MockServer(respondWith: try .errorFixture("empty_204"))
        let response = try await server.client.instances.partnerFees.delete(id: "pf_000000000000")
        #expect(response.data == nil)
        #expect(response.error == nil)
    }

    @Test func objectErrorItemsAreKeptAsJSONText() async throws {
        let server = MockServer(respondWith: .status(400, body: #"{"success":false,"message":"validation_error","errors":["plain",{"field":"name"}]}"#))
        let error = try #require(try await getRails(server.client).error)
        #expect(error.errors == ["plain", #"{"field":"name"}"#])
    }

    @Test func errorTextNeverContainsTheAPIKey() async throws {
        let server = MockServer(respondWith: try .errorFixture("api_error_envelope"))
        let error = try #require(try await getRails(server.client).error)
        #expect(!String(describing: error).contains("test_key"))
        #expect(error.errorDescription?.contains("test_key") == false)
    }
}
