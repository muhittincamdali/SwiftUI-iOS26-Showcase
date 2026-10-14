// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftUIiOS26Showcase",
    platforms: [
        .iOS(.v26),
        .macOS(.v26)
    ],
    products: [
        .library(name: "SwiftUIiOS26Showcase", targets: ["SwiftUIiOS26Showcase"])
    ],
    targets: [
        .target(name: "SwiftUIiOS26Showcase"),
        .testTarget(
            name: "SwiftUIiOS26ShowcaseTests",
            dependencies: ["SwiftUIiOS26Showcase"]
        )
    ]
)
