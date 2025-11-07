import UIKit
import SnapshotTesting

extension SnapshotTest {
    /// Snapshot from all devices
    /// - Parameters:
    ///   - view: UIView to snapshot
    ///   - testDynamicSize: Whether to test different dynamic type sizes
    ///   - record: Whether to record new reference images
    ///   - wait: Time to wait before taking snapshot
    ///   - scrollViewMultiplier: If set, adds a long snapshot of first device with height multiplied by this value (currently not supported for UIKit)
    ///   - displayScale: Display scale to be used for snapshots, if `nil` uses value from ``init(devices:record:displayScale:contentSizes:colorSchemes:)``
    ///   - line: Source code line number
    ///   - file: Source code file path
    ///   - testName: Name of the test function
    ///   - precision: Precision for snapshot comparison
    ///   - nameAddition: Optional addition to snapshot name
    @MainActor
    public func devices(
        _ view: UIView,
        testDynamicSize: Bool = true,
        record: Bool? = nil,
        wait: TimeInterval = 0,
        scrollViewMultiplier: Double? = nil,
        displayScale: CGFloat? = nil,
        line: UInt = #line,
        file: StaticString = #filePath,
        testName: String = #function,
        precision: Double = 1.0,
        nameAddition: String? = nil
    ) {
        let devices: [SnapshotDevice] = if let scrollViewMultiplier {
            devices + [SnapshotDevice.snapshotLongDevice(scrollViewMultiplier, device: devices.first)]
        } else {
            devices
        }

        devices.forEach { deviceToSnapshot in
            device(
                view,
                testDynamicSize: testDynamicSize,
                device: deviceToSnapshot,
                record: record,
                wait: wait,
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
    ///   - view: UIView to snapshot
    ///   - testDynamicSize: Whether to test different dynamic type sizes
    ///   - device: Device configuration to use for snapshot
    ///   - record: Whether to record new reference images
    ///   - wait: Time to wait before taking snapshot
    ///   - displayScale: Display scale to be used for snapshots, if `nil` uses value from ``init(devices:record:displayScale:contentSizes:colorSchemes:)``
    ///   - line: Source code line number
    ///   - file: Source code file path
    ///   - testName: Name of the test function
    ///   - precision: Precision for snapshot comparison
    ///   - nameAddition: Optional addition to snapshot name
    @MainActor
    public func device(
        _ view: UIView,
        testDynamicSize: Bool = true,
        device: SnapshotDevice,
        record: Bool? = nil,
        wait: TimeInterval = 0,
        displayScale: CGFloat? = nil,
        line: UInt = #line,
        file: StaticString = #filePath,
        testName: String = #function,
        precision: Double = 1.0,
        nameAddition: String? = nil
    ) {
        if colorSchemes.count > 1 {
            colorSchemes.forEach { colorScheme in
                let strategy = Snapshotting<UIView, UIImage>.image(
                    drawHierarchyInKeyWindow: false,
                    size: device.config.size,
                    traits: .init(traitsFrom: [
                        device.config.traits,
                        .init(userInterfaceStyle: colorScheme.uiUserInterfaceStyle),
                        (displayScale ?? self.displayScale).map { .init(displayScale: $0) },
                    ].compactMap { $0 })
                )

                assertAny(
                    view,
                    record: record,
                    wait: wait,
                    precision: precision,
                    strategy: strategy,
                    deviceName: device.name,
                    name: colorScheme.name,
                    nameAddition: nameAddition,
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
            let strategy = Snapshotting<UIView, UIImage>.image(
                drawHierarchyInKeyWindow: false,
                size: device.config.size,
                traits: .init(traitsFrom: [
                    device.config.traits,
                    .init(preferredContentSizeCategory: contentSize.uiContentSizeCategory),
                    .init(userInterfaceStyle: colorSchemes.first?.uiUserInterfaceStyle ?? .light),
                    (displayScale ?? self.displayScale).map { .init(displayScale: $0) },
                ].compactMap { $0 })
            )

            assertAny(
                view,
                record: record,
                wait: wait,
                precision: precision,
                strategy: strategy,
                deviceName: device.name,
                name: contentSize.name,
                nameAddition: nameAddition,
                file: file,
                testName: testName,
                line: line
            )
        }
    }

    /// Snapshot design component using sizeThatFits layout
    /// - Parameters:
    ///   - view: UIView to snapshot
    ///   - testDynamicSize: Whether to test different dynamic type sizes
    ///   - record: Whether to record new reference images
    ///   - wait: Time to wait before taking snapshot
    ///   - displayScale: Display scale to be used for snapshots, if `nil` uses value from ``init(devices:record:displayScale:contentSizes:colorSchemes:)``
    ///   - line: Source code line number
    ///   - file: Source code file path
    ///   - testName: Name of the test function
    ///   - precision: Precision for snapshot comparison
    ///   - nameAddition: Optional addition to snapshot name
    @MainActor
    public func component(
        _ view: UIView,
        size: CGSize? = nil,
        testDynamicSize: Bool = true,
        record: Bool? = nil,
        wait: TimeInterval = 0,
        displayScale: CGFloat? = nil,
        line: UInt = #line,
        file: StaticString = #filePath,
        testName: String = #function,
        precision: Double = 1.0,
        nameAddition: String? = nil
    ) {
        var size = size ?? view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if size == .zero {
            size = view.bounds.size
        }

        let sizes: any Collection<SnapshotContentSize> = if testDynamicSize {
            contentSizes
        } else {
            [.large]
        }

        sizes.forEach { contentSize in
            let strategy = Snapshotting<UIView, UIImage>.image(
                drawHierarchyInKeyWindow: false,
                size: size,
                traits: .init(traitsFrom: [
                    .init(preferredContentSizeCategory: contentSize.uiContentSizeCategory),
                    .init(userInterfaceStyle: colorSchemes.first?.uiUserInterfaceStyle ?? .light),
                    (displayScale ?? self.displayScale).map { .init(displayScale: $0) },
                ].compactMap { $0 })
            )

            assertAny(
                view,
                record: record,
                wait: wait,
                precision: precision,
                strategy: strategy,
                deviceName: "",
                name: contentSize.name,
                nameAddition: nameAddition,
                file: file,
                testName: testName,
                line: line
            )
        }
    }
}
