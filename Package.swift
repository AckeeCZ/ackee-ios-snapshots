// swift-tools-version: 6.2

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
            .upToNextMajor(from: "1.19.2")
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
        .testTarget(
            name: "AckeeSnapshotsTests",
            dependencies: ["AckeeSnapshots"]
        ),
    ]
)