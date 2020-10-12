// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-data-structures",
    products: [
        .library(
            name: "DataStructures",
            targets: ["DataStructures"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DataStructures",
            dependencies: []
        ),
        .testTarget(
            name: "DataStructuresTests",
            dependencies: ["DataStructures"]
        ),
    ]
)
