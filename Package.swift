// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BindableUIKit",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "BindableUIKit",
            targets: ["BindableUIKit"]
        ),
    ],
    targets: [
        .target(
            name: "BindableUIKit"
        ),
    ]
)
