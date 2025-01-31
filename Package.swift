// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-powmod",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "swift-powmod",
            targets: ["swift-powmod"])
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.5.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "swift-powmod", dependencies: ["lib"], path: "Sources/swift-powmod"),
        .target(name: "lib", path: "Sources/lib"),
        .testTarget(
            name: "swift-powmodTests",
            dependencies: [
                .product(name: "BigInt", package: "bigint"),
                "swift-powmod",
            ]
        ),
    ]
)
