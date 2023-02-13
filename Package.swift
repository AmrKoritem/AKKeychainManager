// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AKKeychainManager",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "AKKeychainManager",
            targets: ["AKKeychainManager"]),
    ],
    targets: [
        .target(
            name: "AKKeychainManager",
            dependencies: []),
        .testTarget(
            name: "AKKeychainManagerTests",
            dependencies: ["AKKeychainManager"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
