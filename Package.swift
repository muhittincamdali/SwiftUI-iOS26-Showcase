// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftUIiOS26Showcase",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SwiftUIiOS26Showcase",
            targets: ["SwiftUIiOS26Showcase"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUIiOS26Showcase",
            dependencies: [],
            path: "Sources/SwiftUIiOS26Showcase"
        ),
        .testTarget(
            name: "SwiftUIiOS26ShowcaseTests",
            dependencies: ["SwiftUIiOS26Showcase"]
        )
    ]
)
