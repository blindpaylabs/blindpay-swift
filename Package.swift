// swift-tools-version: 6.2
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
            name: "blindpay-swift",
            targets: ["blindpay-swift"]
        ),
        .executable(
            name: "GetRails",
            targets: ["GetRails"]
        ),
    ],
    targets: [
        .target(
            name: "blindpay-swift"
        ),
        .executableTarget(
            name: "GetRails",
            dependencies: ["blindpay-swift"],
            path: "Examples",
            sources: ["GetRails.swift"]
        ),
        .testTarget(
            name: "blindpay-swiftTests",
            dependencies: ["blindpay-swift"]
        ),
    ]
)
