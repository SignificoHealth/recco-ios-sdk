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

let Resources: Target = .target(
    name: "SFResources",
    resources: [.process("Haptics")]
)
let Entities: Target = .target(name: "SFEntities")
let Api: Target = .target(
    name: "SFApi",
    dependencies: [
        .add(Core)
    ],
    exclude: [
        "sf-backend-open-api.json",
        "generate-api.sh",
        "patch-api"
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

let Article: Target = .target(
    name: "SFArticle",
    dependencies: [
        .add(SharedUI),
        .add(Repo),
        .product(name: "Nuke", package: "Nuke"),
        .product(name: "NukeUI", package: "Nuke")
    ])

let Questionnaire: Target = .target(
    name: "SFQuestionnaire",
    dependencies: [
        .add(SharedUI),
        .add(Repo)
    ])

let Dashboard: Target = .target(
    name: "SFDashboard",
    dependencies: [
        .add(SharedUI),
        .add(Repo),
        .add(Article),
        .add(Questionnaire),
        .product(name: "Nuke", package: "Nuke"),
        .product(name: "NukeUI", package: "Nuke")
    ]
)

let Onboarding: Target = .target(
    name: "SFOnboarding",
    dependencies: [
        .add(SharedUI),
        .add(Repo),
        .add(Article),
        .add(Dashboard),
    ])

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
        .library(name: SharedUI.name, targets: [SharedUI.name]),
        .library(name: Dashboard.name, targets: [Dashboard.name]),
        .library(name: Article.name, targets: [Article.name]),
        .library(name: Questionnaire.name, targets: [Questionnaire.name]),
        .library(name: Onboarding.name, targets: [Onboarding.name])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", .upToNextMajor(from: "0.1.0")),
        .package(url: "https://github.com/kean/Nuke", .upToNextMajor(from: "12.1.0"))
    ],
    targets: [
        .target(
            name: "SignificoSF",
            dependencies: [
                .add(Onboarding)
            ]
        ),
        Entities,
        Core,
        Repo,
        Api,
        Resources,
        SharedUI,
        Onboarding,
        Dashboard,
        Article,
        Questionnaire
    ]
)
