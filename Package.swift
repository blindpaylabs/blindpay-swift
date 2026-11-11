// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "blindpay-swift",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "BlindPay",
            targets: ["BlindPay"]
        ),
    ],
    dependencies: [
        // HMAC-SHA256 for webhook verification on Linux, where CryptoKit
        // doesn't exist. Apple platforms use CryptoKit and never link it.
        .package(url: "https://github.com/apple/swift-crypto.git", "3.0.0"..<"5.0.0"),
    ],
    targets: [
        .target(
            name: "BlindPay",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto", condition: .when(platforms: [.linux])),
            ],
            path: "Sources/BlindPay"
        ),
        // Example only: buildable with `swift run GetRails`, but not a
        // product, so packages that depend on BlindPay don't ship it.
        .executableTarget(
            name: "GetRails",
            dependencies: ["BlindPay"],
            path: "Examples",
            sources: ["GetRails.swift"]
        ),
        .testTarget(
            name: "blindpay-swiftTests",
            dependencies: ["BlindPay"],
            resources: [
                // Shared spec-shaped fixtures from the SDK parity effort
                // (reference/fixtures). Keep the layout so a regeneration is a
                // plain copy.
                .copy("Fixtures"),
                // Shared Svix webhook vectors (reference/webhook-vectors.json).
                .copy("Vectors"),
            ]
        ),
    ]
)
