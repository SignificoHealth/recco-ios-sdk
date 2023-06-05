// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target.Dependency {
    static func add(_ target: Target) -> Self {
        .init(stringLiteral: target.name)
    }
}

// MARK: Modules

let Core: Target = .target(name: "SFCore", dependencies: [
    .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
])
let Resources: Target = .target(name: "SFResources")
let Entities: Target = .target(name: "SFEntities")
let Api: Target = .target(
    name: "SFApi",
    dependencies: [
        .add(Core)
    ],
    exclude: [
        "sf-backend-open-api.json",
        "generate-api.sh"
    ]
)
let Repo: Target = .target(name: "SFRepo", dependencies: [
    .add(Api),
    .add(Entities),
    .add(Core)
])

let SharedUI: Target = .target(name: "SFSharedUI", dependencies: [
    .add(Resources),
    .add(Repo)
])

// MARK: Feature

let Dashboard: Target = .target(
    name: "SFDashboard",
    dependencies: [
        .add(SharedUI),
        .add(Repo)
    ]
)

// MARK: Definition

let package = Package(
    name: "significo-sf",
    defaultLocalization: "en",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "SignificoSF",
            targets: ["SignificoSF"]
        ),
        .library(name: SharedUI.name, targets: [SharedUI.name])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", .upToNextMajor(from: "0.1.0"))
    ],
    targets: [
        .target(name: "SignificoSF",
            dependencies: [
                .add(Dashboard)
            ]
        ),
        Entities,
        Core,
        Repo,
        Api,
        Resources,
        SharedUI,
        Dashboard
    ]
)
