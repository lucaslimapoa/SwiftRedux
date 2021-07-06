// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRedux",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SwiftRedux",
            targets: ["SwiftRedux"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftRedux",
            dependencies: []),
        .testTarget(
            name: "SwiftReduxTests",
            dependencies: ["SwiftRedux"]),
    ]
)
