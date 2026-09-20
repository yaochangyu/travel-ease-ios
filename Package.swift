// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TravelEase",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "TravelEase",
            targets: ["TravelEase"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TravelEase",
            dependencies: [],
            path: "Sources/TravelEase"
        ),
        .testTarget(
            name: "TravelEaseTests",
            dependencies: ["TravelEase"],
            path: "Tests/TravelEaseTests"
        ),
    ]
)
