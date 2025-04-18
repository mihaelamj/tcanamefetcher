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
        .package(url: "https://github.com/realm/SwiftLint", exact: "0.54.0"),
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

// Inject base plugins into each target
package.targets = package.targets.map { target in
    var plugins = target.plugins ?? []
    plugins.append(.plugin(name: "SwiftLintPlugin", package: "SwiftLint"))
    target.plugins = plugins
    return target
}

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}
