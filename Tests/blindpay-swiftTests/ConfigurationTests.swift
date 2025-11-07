//
//  ConfigurationTests.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Testing
@testable import blindpay_swift

struct ConfigurationTests {
    @Test func defaultConfiguration() {
        let config = Configuration.default
        
        #expect(config.baseURL == "https://api.blindpay.com")
    }
    
    @Test func customConfiguration() {
        let customURL = "https://custom.example.com"
        let config = Configuration(baseURL: customURL)
        
        #expect(config.baseURL == customURL)
    }
}

