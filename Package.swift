// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
// https://docs.swift.org/swiftpm/documentation/packagemanagerdocs/settingswifttoolsversion/


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
    targets: [
        .target(
            name: "PreviewUtilities",
            path: "sources"
        ),
        .testTarget(
            name: "PreviewUtilitiesTests",
            dependencies: ["PreviewUtilities"],
            path: "tests"
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
        .enableUpcomingFeature("InferIsolatedConformances")
    ])
    target.swiftSettings = settings
}
