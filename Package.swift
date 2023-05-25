// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "significo-sf",
    defaultLocalization: "en",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "SignificoSF",
            targets: ["SignificoSF"]
        )
    ],
    dependencies: [],
    targets: [
        .target(name: "Core"),
        .target(name: "SignificoSF",
            dependencies: [
                "DashboardFeature"
            ]
        ),
        .target(
            name: "DashboardFeature",
            dependencies: [
                "SharedUI"
            ]
        ),
        .target(
            name: "Resources",
            dependencies: []
        ),
        .target(
            name: "SharedUI",
            dependencies: ["Resources"]
        )
    ]
)
