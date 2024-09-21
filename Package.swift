// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ackee-ios-snapshots",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "AckeeSnapshots",
            targets: ["AckeeSnapshots"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/alexey1312/SnapshotTestingHEIC",
            from: "1.5.0"
        )
    ],
    targets: [
        .target(
            name: "AckeeSnapshots",
            dependencies: [
                .product(
                    name: "SnapshotTestingHEIC",
                    package: "SnapshotTestingHEIC"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
