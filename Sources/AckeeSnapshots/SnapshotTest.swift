import SnapshotTesting
import SwiftUI
import XCTest

/// Represents default setup of taken snapshots
///
/// ## Usage
///
/// Create your global instance in your shared testing module (lets call it _AppTesting_):
///
/// ```swift
/// public let assertSnapshot = SnapshotTest(
///     devices: [
///         .iPhone8,
///         .iPhone13ProMax,
///         .iPadPro11,
///         .iPadPro12_9
///     ],
///     record: false,
///     displayScale: 1,
///     contentSizes: [.extraExtraExtraLarge, .large, .small],
///     colorSchemes: [.light, .dark]
/// )
/// ```
/// Then you can import your testing module and assert your snapshots:
/// ```swift
/// import AppTesting
/// import XCTest
///
/// func test_appearance() {
///     assertSnapshot.devices(SubjectView())
/// }
/// ```
///
/// Properties of this object are not published so its interface is as clean as possible
public struct SnapshotTest {
    private let devices: [SnapshotDevice]
    private let record: Bool
    private let displayScale: CGFloat?
    private let contentSizes: any Collection<SnapshotContentSize>
    private let colorSchemes: any Collection<SnapshotColorScheme>

    // MARK: - Initializers
    
    /// Create new snapshot test configuration
    /// - Parameters:
    ///   - devices: Default devices for snapshot tests
    ///   - record: Default record value
    ///   - contentSizes: Default content sizes
    ///   - colorSchemes: Default color schemes
    public init(
        devices: [SnapshotDevice],
        record: Bool,
        displayScale: CGFloat?,
        contentSizes: any Collection<SnapshotContentSize>,
        colorSchemes: any Collection<SnapshotColorScheme>
    ) {
        self.devices = devices
        self.record = record
        self.displayScale = displayScale
        self.contentSizes = contentSizes
        self.colorSchemes = colorSchemes
    }

    /// Snapshot specific layout
    public func layout<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool = true,
        layout: SwiftUISnapshotLayout,
        record: Bool? = nil,
        wait: TimeInterval = 0,
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
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Snapshot design component
    public func component<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool = true,
        record: Bool? = nil,
        wait: TimeInterval = 0,
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
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Snapshot from all devices
    public func devices<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool = true,
        record: Bool? = nil,
        wait: TimeInterval = 0,
        scrollViewMultiplier: Double? = nil,
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
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Snapshot from one device
    public func device<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool = true,
        device: SnapshotDevice,
        record: Bool? = nil,
        wait: TimeInterval = 0,
        scrollViewMultiplier: Double? = nil,
        line: UInt = #line,
        file: StaticString = #file,
        testName: String = #function,
        precision: Double = 1.0,
        nameAddition: String? = nil
    ) {
        assertDevice(
            view,
            testDynamicSize: testDynamicSize,
            device: device,
            record: record,
            wait: wait,
            precision: precision,
            file: file,
            testName: testName,
            line: line
        )
    }

    // MARK: - Private helpers

    private func assert<View: SwiftUI.View>(
        _ view: View,
        record: Bool?,
        wait: TimeInterval,
        precision: Double,
        strategy: Snapshotting<View, UIImage>,
        deviceName: String = "",
        name: String = "",
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        assertSnapshot(
            of: view,
            as: wait > 0 ? .wait(for: wait, on: strategy): strategy,
            named: [deviceName, name].joined(separator: "_"),
            record: record ?? self.record,
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
                    displayScale.map { .init(displayScale: $0) },
                ].compactMap { $0 })
            )

            assert(
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
                    displayScale.map { .init(displayScale: $0) },
                ].compactMap { $0 })
            )

            assert(
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

    private func assertDevices<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool,
        record: Bool?,
        scrollViewMultiplier: Double?,
        wait: TimeInterval,
        precision: Double,
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        let devices: [SnapshotDevice] = if let scrollViewMultiplier {
            devices + [SnapshotDevice.snapshotLongDevice(scrollViewMultiplier)]
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
            file: file,
            testName: testName,
            line: line
        )
    }

    private func assertUIVariants<View: SwiftUI.View>(
        _ view: View,
        testDynamicSize: Bool,
        record: Bool?,
        wait: TimeInterval,
        precision: Double,
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
            traits: displayScale.map { .init(displayScale: $0) } ?? .init()
        )

        sizes.forEach { contentSize, name in
            // Fixed size is needed for view to layout to the whole view
            // swiftlint:disable:next force_cast
            let viewFixedSize = view.dynamicTypeSize(contentSize).fixedSize() as! FixedDynamicView

            assert(
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
