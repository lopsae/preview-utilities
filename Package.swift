// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

// https://theswiftdev.com/the-swift-package-manifest-file/


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
