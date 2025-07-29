import UIKit
import SnapshotTesting

extension SnapshotTest {
    /// Snapshot from all devices
    /// - Parameters:
    ///   - viewController: UIViewController to snapshot
    ///   - testDynamicSize: Whether to test different dynamic type sizes
    ///   - record: Whether to record new reference images
    ///   - wait: Time to wait before taking snapshot
    ///   - scrollViewMultiplier: If set, adds a long snapshot of first device with height multiplied by this value
    ///   - displayScale: Display scale to be used for snapshots, if `nil` uses value from ``init(devices:record:displayScale:contentSizes:colorSchemes:)``
    ///   - line: Source code line number
    ///   - file: Source code file path
    ///   - testName: Name of the test function
    ///   - precision: Precision for snapshot comparison
    ///   - nameAddition: Optional addition to snapshot name
    public func devices(
        _ viewController: UIViewController,
        testDynamicSize: Bool = true,
        record: Bool? = nil,
        wait: TimeInterval = 0,
        scrollViewMultiplier: Double? = nil,
        displayScale: CGFloat? = nil,
        line: UInt = #line,
        file: StaticString = #file,
        testName: String = #function,
        precision: Double = 1.0,
        nameAddition: String? = nil
    ) {
        devices.forEach { deviceToSnapshot in
            device(
                viewController,
                testDynamicSize: testDynamicSize,
                device: deviceToSnapshot,
                record: record,
                wait: wait,
                scrollViewMultiplier: scrollViewMultiplier,
                displayScale: displayScale,
                line: line,
                file: file,
                testName: testName,
                precision: precision,
                nameAddition: nameAddition
            )
        }
    }

    /// Snapshot from one device
    /// - Parameters:
    ///   - viewController: UIViewController to snapshot
    ///   - testDynamicSize: Whether to test different dynamic type sizes
    ///   - device: Device configuration to use for snapshot
    ///   - record: Whether to record new reference images
    ///   - wait: Time to wait before taking snapshot
    ///   - scrollViewMultiplier: If set, uses a long snapshot of device with height multiplied by this value (currently not supported for UIKit)
    ///   - displayScale: Display scale to be used for snapshots, if `nil` uses value from ``init(devices:record:displayScale:contentSizes:colorSchemes:)``
    ///   - line: Source code line number
    ///   - file: Source code file path
    ///   - testName: Name of the test function
    ///   - precision: Precision for snapshot comparison
    ///   - nameAddition: Optional addition to snapshot name
    public func device(
        _ viewController: UIViewController,
        testDynamicSize: Bool = true,
        device: SnapshotDevice,
        record: Bool? = nil,
        wait: TimeInterval = 0,
        scrollViewMultiplier: Double? = nil,
        displayScale: CGFloat? = nil,
        line: UInt = #line,
        file: StaticString = #file,
        testName: String = #function,
        precision: Double = 1.0,
        nameAddition: String? = nil
    ) {
        if colorSchemes.count > 1 {
            colorSchemes.forEach { colorScheme in
                let strategy = Snapshotting<UIViewController, UIImage>.image(
                    on: device.config,
                    perceptualPrecision: Float(precision),
                    traits: .init(traitsFrom: [
                        .init(userInterfaceStyle: colorScheme.uiUserInterfaceStyle),
                        (displayScale ?? self.displayScale).map { .init(displayScale: $0) },
                    ].compactMap { $0 })
                )

                assertAny(
                    viewController,
                    record: record,
                    wait: wait,
                    precision: precision,
                    strategy: strategy,
                    deviceName: device.name,
                    name: colorScheme.name,
                    file: file,
                    testName: testName,
                    line: line
                )
            }
        }

        let sizes: any Collection<SnapshotContentSize> = if testDynamicSize {
            contentSizes
        } else {
            [.large]
        }

        sizes.forEach { contentSize in
            let strategy = Snapshotting<UIViewController, UIImage>.image(
                on: device.config,
                perceptualPrecision: Float(precision),
                traits: .init(traitsFrom: [
                    .init(preferredContentSizeCategory: contentSize.uiContentSizeCategory),
                    (displayScale ?? self.displayScale).map { .init(displayScale: $0) },
                ].compactMap { $0 })
            )

            assertAny(
                viewController,
                record: record,
                wait: wait,
                precision: precision,
                strategy: strategy,
                deviceName: device.name,
                name: contentSize.name,
                file: file,
                testName: testName,
                line: line
            )
        }
    }
}
