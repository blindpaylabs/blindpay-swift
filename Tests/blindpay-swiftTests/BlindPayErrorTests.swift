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
    
    @Test func httpErrorDescription() {
        let statusCode = 404
        let error = BlindPayError.httpError(statusCode: statusCode)
        
        #expect(error.errorDescription == "HTTP error with status code: 404")
    }
    
    @Test func invalidResponseErrorDescription() {
        let error = BlindPayError.invalidResponse
        
        #expect(error.errorDescription == "Invalid response from server")
    }
}

