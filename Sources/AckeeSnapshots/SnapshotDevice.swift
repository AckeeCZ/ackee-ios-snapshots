import SnapshotTesting
import UIKit

/// Represents various devices used for snapshot testing.
public enum SnapshotDevice {
    case iPhone8, iPhone8Plus
    case iPhoneX, iPhoneXsMax
    case iPhone12, iPhone12Pro, iPhone12ProMax
    case iPhone13Mini, iPhone13, iPhone13Pro, iPhone13ProMax
    case iPadMini
    case iPadPro10_5, iPadPro11, iPadPro12_9
    case custom(SnapshotDeviceConfig)
}

public extension SnapshotDevice {
    /// Returns the `ViewImageConfig` associated with the device.
    var config: ViewImageConfig {
        switch self {
        case .iPhone8: .iPhone8
        case .iPhone8Plus: .iPhone8Plus
        case .iPhoneX: .iPhoneX
        case .iPhoneXsMax: .iPhoneXsMax
        case .iPhone12: .iPhone12
        case .iPhone12Pro: .iPhone12Pro
        case .iPhone12ProMax: .iPhone12ProMax
        case .iPhone13Mini: .iPhone13Mini
        case .iPhone13: .iPhone13
        case .iPhone13Pro: .iPhone13Pro
        case .iPhone13ProMax: .iPhone13ProMax
        case .iPadMini: .iPadMini
        case .iPadPro10_5: .iPadPro10_5
        case .iPadPro11: .iPadPro11
        case .iPadPro12_9: .iPadPro12_9
        case .custom(let config): config.config
        }
    }

    /// Returns the name of the device as a string.
    var name: String {
        switch self {
        case .iPhone8: "iP8"
        case .iPhone8Plus: "iP8Plus"
        case .iPhoneX: "iPX"
        case .iPhoneXsMax: "iPXsMax"
        case .iPhone12: "iP12"
        case .iPhone12Pro: "iP12Pro"
        case .iPhone12ProMax: "iP12ProMax"
        case .iPhone13Mini: "iP13Mini"
        case .iPhone13: "iP13"
        case .iPhone13Pro: "iP13Pro"
        case .iPhone13ProMax: "iP13ProMax"
        case .iPadMini: "iPadMini"
        case .iPadPro10_5: "iPadPro10_5"
        case .iPadPro11: "iPadPro11"
        case .iPadPro12_9: "iPadPro12_9"
        case .custom(let config): config.name
        }
    }

    /// Provides a SwiftUI snapshot layout based on the device's configuration.
    var layout: SwiftUISnapshotLayout { .device(config: config) }

    /// Creates a custom `SnapshotDevice` instance with a long device configuration.
    ///
    /// - Parameters:
    ///   - heightMultiplier: A multiplier to adjust the height of the device. If `nil`, the default height is used.
    ///   - device: The base device to use for the configuration. Defaults to `.iPhone13ProMax`.
    /// - Returns: A `SnapshotDevice` with a custom configuration.
    static func snapshotLongDevice(
        _ heightMultiplier: Double?,
        device: SnapshotDevice = .iPhone13ProMax
    ) -> Self {
        let defaultDevice: ViewImageConfig = device.config
        guard
            let heightMultiplier,
            let width = defaultDevice.size?.width,
            let height = defaultDevice.size?.height
        else { return SnapshotDevice.iPhone13ProMax }

        return .custom(
            .init(
                name: device.name + "Long",
                config: .init(
                    safeArea: defaultDevice.safeArea,
                    size: .init(width: width, height: height * heightMultiplier),
                    traits: defaultDevice.traits
                )
            )
        )
    }
}
