//
//  BlindPayTests.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Testing
@testable import blindpay_swift

struct BlindPayTests {
    @Test func initialization() {
        let apiKey = "test_api_key_123"
        let instanceId = "test_instance_456"
        let blindPay = BlindPay(apiKey: apiKey, instanceId: instanceId)
        
        // Verify services are initialized
        let _ = blindPay.available
        let _ = blindPay.instances
    }
}

