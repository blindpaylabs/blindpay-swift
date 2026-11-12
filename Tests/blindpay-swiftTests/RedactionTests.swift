//
//  RedactionTests.swift
//  blindpay-swift
//
//  The API key never appears in dumps, mirrors, descriptions or errors.
//

import Foundation
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

struct SecretHygieneTests {
    private let key = "sk_live_should_never_leak"

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
            #expect(String(describing: underlying).contains("/v1/instances/in_000000000000/customers"))
        }
    }
}
