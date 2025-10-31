//
//  GetRails.swift
//  blindpay-swift
//
//  Created by Eric Viana on 31/10/25.
//

import Foundation
import blindpay_swift

@main
struct GetRails {
    static func main() async {
        // Replace with your actual API credentials
        let apiKey = ProcessInfo.processInfo.environment["BLINDPAY_API_KEY"] ?? "your-api-key-here"
        let instanceId = ProcessInfo.processInfo.environment["BLINDPAY_INSTANCE_ID"] ?? "your-instance-id-here"
        
        guard apiKey != "your-api-key-here" && instanceId != "your-instance-id-here" else {
            print("⚠️  Please set BLINDPAY_API_KEY and BLINDPAY_INSTANCE_ID environment variables")
            print("   Or edit this file to include your credentials")
            print("\n   Example:")
            print("   export BLINDPAY_API_KEY='your-api-key'")
            print("   export BLINDPAY_INSTANCE_ID='your-instance-id'")
            print("   swift run TestGetRails")
            exit(1)
        }
        
        let client = BlindPay(apiKey: apiKey, instanceId: instanceId)
        
        print("🔍 Testing getRails endpoint...\n")
        
        do {
            let response = try await client.available.getRails()
            
            if let error = response.error {
                print("❌ Error: \(error.message)")
                exit(1)
            }
            
            guard let rails = response.data else {
                print("❌ No data received")
                exit(1)
            }
            
            print("✅ Success! Found \(rails.count) rails:\n")
            
            for (index, rail) in rails.enumerated() {
                print("\(index + 1). \(rail.label)")
                print("   Value: \(rail.value)")
                print("   Country: \(rail.country)")
                print()
            }
            
            print("✅ Test completed successfully!")
            
        } catch {
            print("❌ Exception: \(error.localizedDescription)")
            if let blindPayError = error as? BlindPayError {
                print("   Error: \(blindPayError.errorDescription ?? "Unknown error")")
            }
            exit(1)
        }
    }
}

