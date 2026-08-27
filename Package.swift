// swift-tools-version: 6.2


import PackageDescription


let package = Package(
    name: "PreviewUtilities",
    platforms: [
        .iOS(.v26),
        .macOS(.v26)
    ],
    products: [
        .library(
            name: "PreviewUtilities",
            targets: ["PreviewUtilities"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/lopsae/geometry-additions", branch: "feature/initial-release"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.19.0")
    ],
    targets: [
        .target(
            name: "PreviewUtilities",
            dependencies: [
                .product(name: "GeometryAdditions", package: "geometry-additions")
            ],
            path: "sources",
            resources: [
                .process("assets.xcassets")
            ]
        ),
        .testTarget(
            name: "UnitTests",
            dependencies: [
                "PreviewUtilities",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "tests",
            exclude: [
                "UnitTests.xctestplan",
            ]
        ),
        .testTarget(
            name: "Illustrations",
            dependencies: ["PreviewUtilities"],
            path: "illustrations",
            exclude: [
                "Illustrations.xctestplan",
            ]
        ),
    ]
)


// Target settings.
for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(contentsOf: [
        // https://developer.apple.com/documentation/xcode/build-settings-reference#Approachable-Concurrency
        // https://developer.apple.com/documentation/xcode/build-settings-reference#Approachable-Concurrency
        // https://useyourloaf.com/blog/approachable-concurrency-in-swift-packages/
        // https://www.avanderlee.com/concurrency/approachable-concurrency-in-swift-6-2-a-clear-guide/

        .defaultIsolation(MainActor.self),

        // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),

        // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0470-isolated-conformances.md
        .enableUpcomingFeature("InferIsolatedConformances"),

        // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0409-access-level-on-imports.md
        .enableUpcomingFeature("InternalImportsByDefault")
    ])
    target.swiftSettings = settings
}
