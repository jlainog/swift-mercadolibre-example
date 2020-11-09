// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MercadoLibreClient",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "MercadoLibreClient",
            targets: ["MercadoLibreClient"]
        ),
        .library(
            name: "MercadoLibreClientLive",
            targets: ["MercadoLibreClientLive"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/jlainog/Codable-Utils",
            from: "0.0.2"
        ),
    ],
    targets: [
        .target(
            name: "MercadoLibreClient",
            dependencies: []
        ),
        .target(
            name: "MercadoLibreClientLive",
            dependencies: ["MercadoLibreClient"]
        ),
        .testTarget(
            name: "MercadoLibreClientLiveTests",
            dependencies: [
                "MercadoLibreClientLive",
                "Codable-Utils"
            ]
        ),
    ]
)
