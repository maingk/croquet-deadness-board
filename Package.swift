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
        ),
        .library(
            name: "SharedServices",
            targets: ["SharedServices"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.15.0")
    ],
    targets: [
        .target(
            name: "SharedModels",
            dependencies: [],
            path: "Shared/Models"
        ),
        .target(
            name: "SharedServices",
            dependencies: [
                "SharedModels",
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "FirebasePerformance", package: "firebase-ios-sdk")
            ],
            path: "Shared/Services"
        ),
        .testTarget(
            name: "SharedModelsTests",
            dependencies: ["SharedModels"],
            path: "Tests/SharedModelsTests"
        ),
        .testTarget(
            name: "SharedServicesTests",
            dependencies: ["SharedServices"],
            path: "Tests/SharedServicesTests"
        )
    ]
)