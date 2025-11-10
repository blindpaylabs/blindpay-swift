// swift-tools-version: 5.7
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
        .executable(
            name: "GetRails",
            targets: ["GetRails"]
        ),
    ],
    targets: [
        .target(
            name: "BlindPay",
            path: "Sources/BlindPay"
        ),
        .executableTarget(
            name: "GetRails",
            dependencies: ["BlindPay"],
            path: "Examples",
            sources: ["GetRails.swift"]
        ),
        .testTarget(
            name: "blindpay-swiftTests",
            dependencies: ["BlindPay"]
        ),
    ]
)
