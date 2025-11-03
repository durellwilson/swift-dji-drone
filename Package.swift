// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftDJIDrone",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "SwiftDJIDrone", targets: ["SwiftDJIDrone"]),
        .executable(name: "drone-cli", targets: ["DroneCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
    ],
    targets: [
        .target(
            name: "SwiftDJIDrone",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
            ]
        ),
        .executableTarget(
            name: "DroneCLI",
            dependencies: ["SwiftDJIDrone"]
        ),
        .testTarget(
            name: "SwiftDJIDroneTests",
            dependencies: ["SwiftDJIDrone"]
        ),
    ]
)
