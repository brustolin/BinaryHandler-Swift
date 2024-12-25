// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BinaryHandler",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(
            name: "BinaryHandler",
            targets: ["BinaryHandler"])
    ],
    targets: [
        .target(
            name: "BinaryHandler"),
        .testTarget(
            name: "BinaryHandlerTests",
            dependencies: ["BinaryHandler"])
    ]
)
