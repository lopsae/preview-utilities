// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

// https://theswiftdev.com/the-swift-package-manifest-file/


import PackageDescription


let package = Package(
    name: "PreviewUtilities",
    platforms: [
        .iOS("26.0")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PreviewUtilities",
            targets: ["PreviewUtilities"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
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
