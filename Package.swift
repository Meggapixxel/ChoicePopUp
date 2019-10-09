// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChoicePopUp",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "ChoicePopUp",
            targets: ["ChoicePopUp"]
        )
    ],
    targets: [
        .target(
            name: "ChoicePopUp",
            dependencies: []
        )
    ]
)
