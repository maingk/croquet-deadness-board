// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "CroquetDeadnessBoard",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.15.0")
    ],
    targets: [
        .target(
            name: "SharedModels",
            dependencies: [
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk")
            ],
            path: "Shared"
        ),
        .testTarget(
            name: "SharedModelsTests",
            dependencies: ["SharedModels"],
            path: "Tests/SharedModelsTests"
        )
    ]
)