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
        .target(name: "SignificoSF",
            dependencies: [
                "SFDashboard"
            ]
        ),
        .target(name: "SFCore"),
        .target(
            name: "SFApi",
            dependencies: [
                "SFCore"
            ],
            exclude: [
                "sf-backend-open-api.json",
                "generate-api.sh"
            ]
        ),
        .target(
            name: "SFDashboard",
            dependencies: [
                "SFSharedUI",
                "SFCore",
                "SFApi"
            ]
        ),
        .target(
            name: "SFResources",
            dependencies: []
        ),
        .target(
            name: "SFSharedUI",
            dependencies: ["SFResources"]
        )
    ]
)
