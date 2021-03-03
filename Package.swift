// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "log",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "log",
            targets: ["log"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "SwiftUtilities", url: "https://github.com/moyoteg/SwiftUtilities", .branch("master")),
        .package(name: "SwiftUIComponents", url: "https://github.com/moyoteg/SwiftUIComponents", .branch("master")),
        // 3rd Party
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "log",
            dependencies: [
                "SwiftUtilities",
                "SwiftUIComponents",
                
                // 3rd Party
                "Alamofire",
            ]),
        .testTarget(
            name: "logTests",
            dependencies: [
            ])
    ]
)
