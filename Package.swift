// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Removebg",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Removebg",
            targets: ["Removebg"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Removebg",
            resources: [.copy("Framework/RemoveBackGroundView/View/RemoveBackgroundView.xib"),
                        .copy("Framework/ImageResultView/View/ImageResultView.xib"),
                        .copy("Framework/LoaderView/View/LoaderView.xib"),
                        .process("Assets/Loader.gif")
        ]),
        .testTarget(
            name: "RemovebgTests",
            dependencies: ["Removebg"]),
    ]
)
