// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let ReccoHeadless: Target = .target(
    name: "ReccoHeadless",
    dependencies: [],
    exclude: [
        "Api/sf-backend-open-api.json",
        "Api/generate-api.sh",
    ],
    plugins: [
        .plugin(name: "SwiftLintPlugin", package: "SwiftLint"),
    ]
)

let ReccoHeadlessTests: Target = .testTarget(
    name: "ReccoHeadlessTests",
    dependencies: [
        "ReccoHeadless",
    ]
)

let ReccoUI: Target = .target(
    name: "ReccoUI",
    dependencies: [
        "ReccoHeadless",
        .product(name: "Nuke", package: "Nuke"),
        .product(name: "NukeUI", package: "Nuke"),
    ],
    resources: [
        .process("Resources/Haptics"),
    ],
    plugins: [
        .plugin(name: "SwiftLintPlugin", package: "SwiftLint"),
    ]
)

let ReccoUITests: Target = .testTarget(
    name: "ReccoUITests",
    dependencies: [
        "ReccoUI",
    ]
)

let package = Package(
    name: "Recco",
    defaultLocalization: "en",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "ReccoUI",
            targets: ["ReccoUI"]
        ),
        .library(
            name: "ReccoHeadless",
            targets: ["ReccoHeadless"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Nuke", .upToNextMajor(from: "12.1.0")),
        .package(url: "https://github.com/realm/SwiftLint", branch: "main"),
    ],
    targets: [
        ReccoHeadless,
        ReccoHeadlessTests,
        ReccoUI,
        ReccoUITests,
    ]
)
