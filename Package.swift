// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PizzaCookingWorld",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "PizzaCookingWorld",
            targets: ["PizzaCookingWorld"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PizzaCookingWorld",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "PizzaCookingWorldTests",
            dependencies: ["PizzaCookingWorld"],
            path: "Tests"
        ),
    ]
)
