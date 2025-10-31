# Blindpay Swift SDK

The official Swift SDK for [Blindpay](https://blindpay.com) - Global payments infrastructure made simple.

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/blindpaylabs/blindpay-swift.git", from: "1.0.0")
]
```

Or add it via Xcode:
1. File → Add Packages...
2. Enter the repository URL: `https://github.com/blindpaylabs/blindpay-swift.git`
3. Select the version and add to your target

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
- Swift 5.9+

## Authentication

To get started, you will need both your API key and your instance id, you can obtain your API key and instance id from the Blindpay dashboard [https://app.blindpay.com/instances/{instanceId}/api-keys](https://app.blindpay.com/instances/{instanceId}/api-keys)

```swift
import blindpay_swift

let blindpay = BlindPay(
    apiKey: "your-api-key-here",
    instanceId: "your-instance-id-here"
)
```

> [!NOTE]  
> All api calls are going to use the provided api key and instance id

## Quick Start

### Check for available rails

```swift
func getAvailableRails() async {
    let blindpay = BlindPay(
        apiKey: "your-api-key-here",
        instanceId: "your-instance-id-here"
    )
    
    do {
        let response = try await blindpay.available.getRails()
        
        if let error = response.error {
            throw NSError(domain: "BlindPay", code: -1, userInfo: [NSLocalizedDescriptionKey: error.message])
        }
        
        if let data = response.data {
            print("Rails: ", data)
        }
    } catch {
        print("Error: \(error)")
    }
}

await getAvailableRails()
```

## Response format

All API methods return a consistent response format

### Success response

```swift
APIResponse(
    data: /* your data */,
    error: nil
)
```

### Error response

```swift
APIResponse(
    data: nil,
    error: APIError(message: "Error message")
)
```

## Error handling

This SDK uses a consistent error handling pattern. Always check for errors:

```swift
do {
    let response = try await blindpay.payins.list()
    
    if let error = response.error {
        // Handle error
        print("API Error: \(error.message)")
        return
    }
    
    if let data = response.data {
        print("Success:", data) // fully typed
    }
} catch {
    // Handle network or decoding errors
    print("Error: \(error)")
}
```

For detailed API documentation, visit:
- [Blindpay API documentation](https://blindpay.com/docs/getting-started/overview)
- [API Reference](https://api.blindpay.com/reference)

## Support

- 📧 Email: [gabriel@blindpay.com](mailto:gabriel@blindpay.com)
- 🐛 Issues: [GitHub Issues](https://github.com/blindpaylabs/blindpay-swift/issues)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Made with ❤️ by the [Blindpay](https://blindpay.com) team

