// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KralBasic",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "KralBasic",
            targets: ["KralObjc", "KralCommon", "KralProtocols"]),
    ],
    dependencies: [
        .package(url: "https://gitee.com/krallee/DeviceKit.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "KralObjc",
               dependencies: []),
        .target(name: "KralCommon",
               dependencies: ["KralObjc", "DeviceKit"]),
        .target(name: "KralProtocols",
               dependencies: []),
        .testTarget(
            name: "KralBasicTests",
            dependencies: ["KralCommon"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
