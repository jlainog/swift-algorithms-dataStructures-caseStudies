// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-algorithms",
    products: [
        .library(
            name: "Algorithms",
            targets: ["Algorithms"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Algorithms",
            dependencies: []
        ),
        .testTarget(
            name: "AlgorithmsTests",
            dependencies: ["Algorithms"]
        ),
    ]
)
