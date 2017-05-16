// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Swambda",
    dependencies: [
        .Package(url: "https://github.com/behrang/SwiftParsec.git", majorVersion: 2),
    ]
)
