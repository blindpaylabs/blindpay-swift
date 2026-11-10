//
//  BlindPayErrorTests.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Testing
@testable import BlindPay

struct BlindPayErrorTests {
    @Test func invalidURLErrorDescription() {
        let error = BlindPayError.invalidURL
        
        #expect(error.errorDescription == "Invalid URL")
    }
    
    @Test func timeoutCarriesTheIdempotencyKey() {
        let error = BlindPayError.timeout(idempotencyKey: "key_1")

        #expect(error.errorDescription == "The request timed out")
        #expect(error.idempotencyKey == "key_1")
    }
    
    @Test func invalidResponseErrorDescription() {
        let error = BlindPayError.invalidResponse
        
        #expect(error.errorDescription == "Invalid response from server")
    }
}

