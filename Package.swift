// swift-tools-version: 5.10

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
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.17.4"
        )
    ],
    targets: [
        .target(
            name: "AckeeSnapshots",
            dependencies: [
                .product(
                    name: "SnapshotTesting",
                    package: "swift-snapshot-testing"
                ),
            ]
        ),
    ]
)
