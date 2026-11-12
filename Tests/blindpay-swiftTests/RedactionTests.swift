//
//  RedactionTests.swift
//  blindpay-swift
//
//  The API key never appears in dumps, mirrors, descriptions or errors.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Testing
@testable import BlindPay

struct RedactionTests {
    private let key = "sk_live_should_never_leak"

    @Test func theClientNeverPrintsItsKey() {
        let client = BlindPay(apiKey: key, instanceId: "in_000000000000")
        var dumped = ""
        dump(client, to: &dumped)
        var dumpedService = ""
        dump(client.instances.payouts, to: &dumpedService)
        for text in [dumped, dumpedService, String(describing: client), String(reflecting: client), "\(Mirror(reflecting: client).children.map { "\($0)" })"] {
            #expect(!text.contains(key))
        }
        #expect(String(describing: client).contains("<redacted>"))
    }

    @Test func errorsDontCarryTheKeyOrTheBody() async throws {
        let server = MockServer(respondWith: .status(500))
        let response = try await server.client.instances.quotes.getFxRate(data: GetFxRateInput(currencyType: .sender, from: .usdc, to: .brl, requestAmount: 1000))
        let error = try #require(response.error)
        let text = "\(error) \(error.localizedDescription) \(String(reflecting: error))"
        #expect(!text.contains("test_key"))
        #expect(!text.contains("request_amount"))
    }
}

/// Fails like URLSession does: a URLError whose userInfo carries the full
/// request URL, query string included.
private struct FailingURLTransport: HTTPTransport {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        var info: [String: Any] = [NSLocalizedDescriptionKey: "Could not connect to the server."]
        if let url = request.url {
            info[NSURLErrorFailingURLErrorKey] = url
            info[NSURLErrorFailingURLStringErrorKey] = url.absoluteString
        }
        throw URLError(.cannotConnectToHost, userInfo: info)
    }
}

/// Headers arrive, then the body fails like URLSession's does: the error
/// carries the full request URL.
private struct IncompleteBodyTransport: HTTPTransport {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let url = request.url!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [:])!
        throw HTTPTransportError.incompleteResponse(response, underlying: URLError(.networkConnectionLost, userInfo: [
            NSURLErrorFailingURLErrorKey: url, NSURLErrorFailingURLStringErrorKey: url.absoluteString,
        ]))
    }
}

private func expectNoQuery(_ error: Error, _ underlying: Error, file: String = #fileID, line: Int = #line) {
    var dumped = ""
    dump(error, to: &dumped)
    let texts = [String(describing: error), String(reflecting: error), error.localizedDescription,
                 String(describing: underlying), "\((underlying as NSError).userInfo)", dumped]
    for text in texts {
        #expect(!text.contains("Jane"), "query string leaked: \(text)")
        #expect(!text.contains("full_name"), "query string leaked: \(text)")
    }
}

struct SecretHygieneTests {
    private let key = "sk_live_should_never_leak"

    @Test func anIncompleteResponseDoesNotCarryTheQueryString() async throws {
        let client = BlindPay(apiKey: key, instanceId: "in_000000000000", configuration: Configuration(
            baseURL: "https://api.example.com", maxRetries: 0, transport: IncompleteBodyTransport()))
        do {
            _ = try await client.instances.customers.list(params: ListCustomersInput(fullName: "Jane Private Doe"))
            Issue.record("expected an incomplete response")
        } catch BlindPayError.incompleteResponse(_, let underlying, _) {
            expectNoQuery(BlindPayError.incompleteResponse(status: 200, underlying: underlying, idempotencyKey: nil), underlying)
        }
    }

    /// The real URLSession transport against a closed local port: whatever
    /// error URLSession builds (on macOS or Linux), the query never surfaces.
    @Test func aRealConnectionFailureDoesNotCarryTheQueryString() async throws {
        let client = BlindPay(apiKey: key, instanceId: "in_000000000000", configuration: Configuration(
            baseURL: "http://127.0.0.1:1", timeout: 10, maxRetries: 0))
        do {
            _ = try await client.instances.customers.list(params: ListCustomersInput(fullName: "Jane Private Doe"))
            Issue.record("expected a network error")
        } catch BlindPayError.networkError(let underlying, _) {
            expectNoQuery(BlindPayError.networkError(underlying, idempotencyKey: nil), underlying)
        } catch {
            Issue.record("expected .networkError, got \(error)")
        }
    }

    @Test func theConfigurationAndServicesNeverPrintTheKey() {
        let client = BlindPay(apiKey: key, instanceId: "in_000000000000", configuration: Configuration(baseURL: "https://api.example.com"))
        var dumped = ""
        dump(Configuration(baseURL: "https://api.example.com"), to: &dumped)
        dump(client.customers(customerId: "cu_000000000000").bankAccounts, to: &dumped)
        dump(client.instances, to: &dumped)
        #expect(!dumped.contains(key))
        #expect(!String(reflecting: client.instances).contains(key))
    }

    @Test func aNetworkErrorDoesNotCarryTheQueryString() async throws {
        let client = BlindPay(apiKey: key, instanceId: "in_000000000000", configuration: Configuration(
            baseURL: "https://api.example.com", maxRetries: 0, transport: FailingURLTransport()))
        do {
            _ = try await client.instances.customers.list(params: ListCustomersInput(fullName: "Jane Private Doe"))
            Issue.record("expected a network error")
        } catch {
            guard case BlindPayError.networkError(let underlying, _) = error else {
                Issue.record("expected .networkError, got \(error)"); return
            }
            var dumped = ""
            dump(error, to: &dumped)
            let texts = [String(describing: error), String(reflecting: error), error.localizedDescription,
                         String(describing: underlying), "\((underlying as NSError).userInfo)", dumped]
            for text in texts {
                #expect(!text.contains("Jane"), "query string leaked: \(text)")
                #expect(!text.contains("full_name"), "query string leaked: \(text)")
                #expect(!text.contains(key))
            }
            // The path stays, so the failure is still diagnosable.
            let failingURL = (underlying as NSError).userInfo[NSURLErrorFailingURLErrorKey] as? URL
            #expect(failingURL?.path == "/v1/instances/in_000000000000/customers")
            #expect(failingURL?.query == nil)
        }
    }
}
