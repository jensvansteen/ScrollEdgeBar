// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "ScrollEdgeBar",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ScrollEdgeBar",
            targets: ["ScrollEdgeBar"]
        ),
    ],
    targets: [
        .target(
            name: "ScrollEdgeBar",
            dependencies: [],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
    ]
)
