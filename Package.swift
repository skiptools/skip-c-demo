// swift-tools-version: 5.9
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import PackageDescription

let package = Package(
    name: "skip-c-demo",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipCDemo", type: .dynamic, targets: ["SkipCDemo"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.7.40"),
        .package(url: "https://source.skip.tools/skip-unit.git", from: "0.5.0"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.0.0"),
        .package(url: "https://source.skip.tools/skip-ffi.git", from: "0.0.0")
    ],
    targets: [
        .target(name: "SkipCDemo", dependencies: [
            "LibCLibrary",
            .product(name: "SkipFoundation", package: "skip-foundation"),
            .product(name: "SkipFFI", package: "skip-ffi")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),

        .testTarget(name: "SkipCDemoTests", dependencies: [
            "SkipCDemo",
            .product(name: "SkipTest", package: "skip")
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),

        .target(name: "LibCLibrary", dependencies: [
            .product(name: "SkipUnit", package: "skip-unit")
        ], sources: ["src"], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
