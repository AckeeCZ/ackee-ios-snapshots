import Foundation
import SnapshotTesting
import SwiftUI

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
    let devices: [SnapshotDevice]
    let record: Bool
    let displayScale: CGFloat?
    let contentSizes: any Collection<SnapshotContentSize>
    let colorSchemes: any Collection<SnapshotColorScheme>

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

        // Register the test observer to clean counter between test cases
        CleanCounterBetweenTestCases.registerIfNeeded()
    }

    /// Shared assertion logic for any view type
    func assertAny<Subject, Format>(
        _ subject: Subject,
        record: Bool?,
        wait: TimeInterval,
        precision: Double,
        strategy: Snapshotting<Subject, Format>,
        deviceName: String = "",
        name: String = "",
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        assertSnapshot(
            of: subject,
            as: wait > 0 ? .wait(for: wait, on: strategy) : strategy,
            named: getSnapshotName(file: file, testName: testName, deviceName: deviceName, name: name),
            record: record ?? self.record,
            file: file,
            testName: testName,
            line: line
        )
    }

    private func getSnapshotName(
        file: StaticString,
        testName: String,
        deviceName: String,
        name: String
    ) -> String {
        let filePath = "\(file)"
        let keyBaseParts: [String] = [filePath, testName, deviceName, name].compactMap { $0.isEmpty ? nil : $0 }
        let counterKey = keyBaseParts.joined(separator: "_")
        let snapshotIndex = snapshotCounter.next(for: counterKey)
        let nameComponents = snapshotIndex == 0 ? [deviceName, name] : [deviceName, name, "\(snapshotIndex)"]
        return (nameComponents.compactMap { $0.isEmpty ? nil : $0 }.joined(separator: "_"))
    }
}
