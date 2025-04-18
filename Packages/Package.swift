// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Main",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .singleTargetLibrary("AppFeature"),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.0.0"),
    ],
    targets: {
        let sharedModelsTarget = Target.target(
            name: "SharedModels",
            dependencies: []
        )
        
        let homeFeatureTarget = Target.target(
            name: "HomeFeature",
            dependencies: [
                "SharedModels",
                "DataFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
        
        let dataFeatureTarget = Target.target(
            name: "DataFeature",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
        
        let appFeatureTarget = Target.target(
            name: "AppFeature",
            dependencies: [
                "SharedModels",
                "DataFeature",
                "HomeFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
        var targets: [Target] = [
            sharedModelsTarget,
            dataFeatureTarget,
            homeFeatureTarget,
            appFeatureTarget
        ]
        return targets
    }()
)

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}
