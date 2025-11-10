// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPM",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "SPM", targets: ["SPM"]),
    ],
    dependencies: [
        // Private repositories
        .package(id: "OneWelcome.SDKSPM-dev", "13.0.0"..<"13.1.0"),

        // Local repositories for 3rd party libs
        .package(path: "./Sources/Swinject.xcframework.zip"),
        .package(path: "./Sources/SkyFloatingLabelTextField.xcframework.zip"),
        .package(path: "./Sources/BetterSegmentedControl.xcframework.zip"),
        .package(path: "./Sources/TransitionButton.xcframework.zip"),
    ],
    targets: [
        .binaryTarget(name: "Swinject", path: "./Sources/Swinject.xcframework.zip"),
        .binaryTarget(name: "SkyFloatingLabelTextField", path: "./Sources/SkyFloatingLabelTextField.xcframework.zip"),
        .binaryTarget(name: "BetterSegmentedControl", path: "./Sources/BetterSegmentedControl.xcframework.zip"),
        .binaryTarget(name: "TransitionButton", path: "./Sources/TransitionButton.xcframework.zip"),
        .target(
            name: "SPM",
            dependencies: [
                "Swinject", "SkyFloatingLabelTextField", "BetterSegmentedControl", "TransitionButton",
                .product(name: "SDKSPM", package: "OneWelcome.SDKSPM-dev"),
            ]
        )
    ]
)
