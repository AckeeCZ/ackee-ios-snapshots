import SnapshotTesting
import SwiftUI
import XCTest
import UIKit

extension SnapshotTest {
    /// Snapshot specific layout
    /// - Parameters:
    ///   - view: View to snapshot
    ///   - testDynamicSize: Whether to test different dynamic type sizes
    ///   - layout: SwiftUI layout to use for snapshot (e.g. .device, .sizeThatFits)
    ///   - record: Whether to record new reference images
    ///   - wait: Time to wait before taking snapshot
    ///   - displayScale: Display scale to be used for snapshots, if `nil` uses value from ``init(devices:record:displayScale:contentSizes:colorSchemes:)``
    ///   - line: Source code line number
    ///   - file: Source code file path
    ///   - testName: Name of the test function
    ///   - precision: Precision for snapshot comparison
    ///   - nameAddition: Optional addition to snapshot name
    public func layout<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool = true,
        layout: SwiftUISnapshotLayout,
        record: Bool? = nil,
        wait: TimeInterval = 0,
        displayScale: CGFloat? = nil,
        line: UInt = #line,
        file: StaticString = #file,
        testName: String = #function,
        precision: Double = 1.0,
        nameAddition: String? = nil
    ) {
        if colorSchemes.count > 1 {
            assertColorSchemes(
                view,
                record: record,
                wait: wait,
                precision: precision,
                layout: layout,
                displayScale: displayScale,
                file: file,
                testName: testName,
                line: line
            )
        }

        assertDynamicTypes(
            view,
            testDynamicSize: testDynamicSize,
            record: record,
            wait: wait,
            precision: precision,
            layout: layout,
            displayScale: displayScale,
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Snapshot design component using sizeThatFits layout
    /// - Parameters:
    ///   - view: View to snapshot
    ///   - testDynamicSize: Whether to test different dynamic type sizes
    ///   - record: Whether to record new reference images
    ///   - wait: Time to wait before taking snapshot
    ///   - displayScale: Display scale to be used for snapshots, if `nil` uses value from ``init(devices:record:displayScale:contentSizes:colorSchemes:)``
    ///   - line: Source code line number
    ///   - file: Source code file path
    ///   - testName: Name of the test function
    ///   - precision: Precision for snapshot comparison
    ///   - nameAddition: Optional addition to snapshot name
    public func component<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool = true,
        record: Bool? = nil,
        wait: TimeInterval = 0,
        displayScale: CGFloat? = nil,
        line: UInt = #line,
        file: StaticString = #file,
        testName: String = #function,
        precision: Double = 1.0,
        nameAddition: String? = nil
    ) {
        assertUIVariants(
            view,
            testDynamicSize: testDynamicSize,
            record: record,
            wait: wait,
            precision: precision,
            displayScale: displayScale,
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Snapshot from all devices
    /// - Parameters:
    ///   - view: View to snapshot
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
    public func devices<View: SwiftUI.View>(
        _ view: View,
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
        assertDevices(
            view,
            testDynamicSize: testDynamicSize,
            record: record,
            scrollViewMultiplier: scrollViewMultiplier,
            wait: wait,
            precision: precision,
            displayScale: displayScale,
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Snapshot from one device
    /// - Parameters:
    ///   - view: View to snapshot
    ///   - testDynamicSize: Whether to test different dynamic type sizes
    ///   - device: Device configuration to use for snapshot
    ///   - record: Whether to record new reference images
    ///   - wait: Time to wait before taking snapshot
    ///   - scrollViewMultiplier: If set, uses a long snapshot of device with height multiplied by this value
    ///   - displayScale: Display scale to be used for snapshots, if `nil` uses value from ``init(devices:record:displayScale:contentSizes:colorSchemes:)``
    ///   - line: Source code line number
    ///   - file: Source code file path
    ///   - testName: Name of the test function
    ///   - precision: Precision for snapshot comparison
    ///   - nameAddition: Optional addition to snapshot name
    public func device<View: SwiftUI.View>(
        _ view: View,
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
        let device: SnapshotDevice = if let scrollViewMultiplier {
            .snapshotLongDevice(scrollViewMultiplier, device: device)
        } else {
            device
        }

        assertDevice(
            view,
            testDynamicSize: testDynamicSize,
            device: device,
            record: record,
            wait: wait,
            precision: precision,
            displayScale: displayScale,
            file: file,
            testName: testName,
            line: line
        )
    }

    private func assertDevices<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool,
        record: Bool?,
        scrollViewMultiplier: Double?,
        wait: TimeInterval,
        precision: Double,
        displayScale: CGFloat?,
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        let devices: [SnapshotDevice] = if let scrollViewMultiplier {
            devices + [SnapshotDevice.snapshotLongDevice(scrollViewMultiplier, device: devices.first)]
        } else {
            devices
        }

        devices.forEach { device in
            assertDevice(
                view,
                testDynamicSize: testDynamicSize,
                device: device,
                record: record,
                wait: wait,
                precision: precision,
                displayScale: displayScale,
                file: file,
                testName: testName,
                line: line
            )
        }
    }

    private func assertDevice<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool,
        device: SnapshotDevice,
        record: Bool?,
        wait: TimeInterval,
        precision: Double,
        displayScale: CGFloat?,
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        if colorSchemes.count > 1 {
            assertColorSchemes(
                view,
                record: record,
                wait: wait,
                precision: precision,
                layout: device.layout,
                deviceName: device.name,
                displayScale: displayScale,
                file: file,
                testName: testName,
                line: line
            )
        }

        assertDynamicTypes(
            view,
            testDynamicSize: testDynamicSize,
            record: record,
            wait: wait,
            precision: precision,
            layout: device.layout,
            deviceName: device.name,
            displayScale: displayScale,
            file: file,
            testName: testName,
            line: line
        )
    }

    private func assertDynamicTypes<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool,
        record: Bool?,
        wait: TimeInterval,
        precision: Double,
        layout: SwiftUISnapshotLayout,
        deviceName: String = "",
        displayScale scaleParam: CGFloat?,
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        let sizes: any Collection<SnapshotContentSize> = if testDynamicSize {
            contentSizes
        } else {
            [.large]
        }

        sizes.forEach { contentSize in
            let strategy = Snapshotting<View, UIImage>.image(
                drawHierarchyInKeyWindow: false,
                layout: layout,
                traits: .init(traitsFrom: [
                    .init(preferredContentSizeCategory: contentSize.uiContentSizeCategory),
                    (scaleParam ?? displayScale).map { .init(displayScale: $0) },
                ].compactMap { $0 })
            )

            assertAny(
                view,
                record: record,
                wait: wait,
                precision: precision,
                strategy: strategy,
                deviceName: deviceName,
                name: contentSize.name,
                file: file,
                testName: testName,
                line: line
            )
        }
    }

    private func assertColorSchemes<View: SwiftUI.View>(
        _ view: View,
        record: Bool?,
        wait: TimeInterval,
        precision: Double,
        layout: SwiftUISnapshotLayout,
        deviceName: String = "",
        displayScale scaleParam: CGFloat?,
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        colorSchemes.forEach { interfaceStyle in
            let strategy = Snapshotting<View, UIImage>.image(
                drawHierarchyInKeyWindow: false,
                layout: layout,
                traits: .init(traitsFrom: [
                    .init(userInterfaceStyle: interfaceStyle.uiUserInterfaceStyle),
                    (scaleParam ?? displayScale).map { .init(displayScale: $0) },
                ].compactMap { $0 })
            )

            assertAny(
                view,
                record: record,
                wait: wait,
                precision: precision,
                strategy: strategy,
                deviceName: deviceName,
                name: interfaceStyle.name,
                file: file,
                testName: testName,
                line: line
            )
        }
    }

    private func assertUIVariants<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool,
        record: Bool?,
        wait: TimeInterval,
        precision: Double,
        displayScale scaleParam: CGFloat?,
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        typealias FixedDynamicView = ModifiedContent<ModifiedContent<View, _EnvironmentKeyWritingModifier<DynamicTypeSize>>, _FixedSizeLayout>

        let sizes: [(DynamicTypeSize, String)] = if testDynamicSize {
            swiftUIContentSizes
        } else {
            [(.large, "sizeL")]
        }

        let strategy = Snapshotting<FixedDynamicView, UIImage>.image(
            drawHierarchyInKeyWindow: false,
            layout: .sizeThatFits,
            traits: (scaleParam ?? displayScale).map { .init(displayScale: $0) } ?? .init()
        )

        sizes.forEach { contentSize, name in
            // Fixed size is needed for view to layout to the whole view
            // swiftlint:disable:next force_cast
            let viewFixedSize = view.dynamicTypeSize(contentSize).fixedSize() as! FixedDynamicView

            assertAny(
                viewFixedSize,
                record: record,
                wait: wait,
                precision: precision,
                strategy: strategy,
                deviceName: "",
                name: name,
                file: file,
                testName: testName,
                line: line
            )
        }
    }

    private var swiftUIContentSizes: [(DynamicTypeSize, String)] {
        contentSizes.map { size in
            switch size {
            case .accessibilityExtraExtraExtraLarge: (.accessibility5, size.name)
            case .accessibilityExtraExtraLarge: (.accessibility4, size.name)
            case .accessibilityExtraLarge: (.accessibility3, size.name)
            case .accessibilityLarge: (.accessibility2, size.name)
            case .accessibilityMedium: (.accessibility1, size.name)
            case .extraExtraExtraLarge: (.xxxLarge, size.name)
            case .extraExtraLarge: (.xxLarge, size.name)
            case .extraLarge: (.xLarge, size.name)
            case .extraSmall: (.small, size.name)
            case .large: (.large, size.name)
            case .medium: (.medium, size.name)
            case .small: (.small, size.name)
            default: (.medium, size.name)
            }
        }
    }
}
