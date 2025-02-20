import SnapshotTesting
import UIKit

/// Represents various devices used for snapshot testing.
public enum SnapshotDevice {
    public static let iPhone8 = SnapshotDevice.iPhone8(.portrait)
    public static let iPhone8Plus = SnapshotDevice.iPhone8Plus(.portrait)
    public static let iPhoneX = SnapshotDevice.iPhoneX(.portrait)
    public static let iPhoneXsMax = SnapshotDevice.iPhoneXsMax(.portrait)
    public static let iPhone12 = SnapshotDevice.iPhone12(.portrait)
    public static let iPhone12Pro = SnapshotDevice.iPhone12Pro(.portrait)
    public static let iPhone12ProMax = SnapshotDevice.iPhone12ProMax(.portrait)
    public static let iPhone13Mini = SnapshotDevice.iPhone13Mini(.portrait)
    public static let iPhone13 = SnapshotDevice.iPhone13(.portrait)
    public static let iPhone13Pro = SnapshotDevice.iPhone13Pro(.portrait)
    public static let iPhone13ProMax = SnapshotDevice.iPhone13ProMax(.portrait)
    public static let iPadMini = SnapshotDevice.iPadMini(.landscape)
    public static let iPadPro10_5 = SnapshotDevice.iPadPro10_5(.landscape)
    public static let iPadPro11 = SnapshotDevice.iPadPro11(.landscape)
    public static let iPadPro12_9 = SnapshotDevice.iPadPro12_9(.landscape)
    
    case iPhone8(_ orientation: ViewImageConfig.Orientation)
    case iPhone8Plus(_ orientation: ViewImageConfig.Orientation)
    case iPhoneX(_ orientation: ViewImageConfig.Orientation)
    case iPhoneXsMax(_ orientation: ViewImageConfig.Orientation)
    case iPhone12(_ orientation: ViewImageConfig.Orientation)
    case iPhone12Pro(_ orientation: ViewImageConfig.Orientation)
    case iPhone12ProMax(_ orientation: ViewImageConfig.Orientation)
    case iPhone13Mini(_ orientation: ViewImageConfig.Orientation)
    case iPhone13(_ orientation: ViewImageConfig.Orientation)
    case iPhone13Pro(_ orientation: ViewImageConfig.Orientation)
    case iPhone13ProMax(_ orientation: ViewImageConfig.Orientation)
    case iPadMini(_ orientation: ViewImageConfig.Orientation)
    case iPadPro10_5(_ orientation: ViewImageConfig.Orientation)
    case iPadPro11(_ orientation: ViewImageConfig.Orientation)
    case iPadPro12_9(_ orientation: ViewImageConfig.Orientation)
    case custom(SnapshotDeviceConfig)
}

public extension SnapshotDevice {
    /// Returns the `ViewImageConfig` associated with the device.
    var config: ViewImageConfig {
        switch self {
        case let .iPhone8(orientation): .iPhone8(orientation)
        case let .iPhone8Plus(orientation): .iPhone8Plus(orientation)
        case let .iPhoneX(orientation): .iPhoneX(orientation)
        case let .iPhoneXsMax(orientation): .iPhoneXsMax(orientation)
        case let .iPhone12(orientation): .iPhone12(orientation)
        case let .iPhone12Pro(orientation): .iPhone12Pro(orientation)
        case let .iPhone12ProMax(orientation): .iPhone12ProMax(orientation)
        case let .iPhone13Mini(orientation): .iPhone13Mini(orientation)
        case let .iPhone13(orientation): .iPhone13(orientation)
        case let .iPhone13Pro(orientation): .iPhone13Pro(orientation)
        case let .iPhone13ProMax(orientation): .iPhone13ProMax(orientation)
        case let .iPadMini(orientation): .iPadMini(orientation)
        case let .iPadPro10_5(orientation): .iPadPro10_5(orientation)
        case let .iPadPro11(orientation): .iPadPro11(orientation)
        case let .iPadPro12_9(orientation): .iPadPro12_9(orientation)
        case let .custom(config): config.config
        }
    }

    /// Returns the name of the device as a string.
    var name: String {
        var baseName = switch self {
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
        
        return baseName.applyOrientationSuffix(orientation)
    }
    
    /// Returns the associated orientation
    private var orientation: ViewImageConfig.Orientation? {
        switch self {
        case let .iPhone8(orientation),
             let .iPhone8Plus(orientation),
             let .iPhoneX(orientation),
             let .iPhoneXsMax(orientation),
             let .iPhone12(orientation),
             let .iPhone12Pro(orientation),
             let .iPhone12ProMax(orientation),
             let .iPhone13Mini(orientation),
             let .iPhone13(orientation),
             let .iPhone13Pro(orientation),
             let .iPhone13ProMax(orientation),
             let .iPadMini(orientation),
             let .iPadPro10_5(orientation),
             let .iPadPro11(orientation),
             let .iPadPro12_9(orientation):
            return orientation

        case .custom(let config):
            return nil
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

fileprivate extension String {
    func applyOrientationSuffix(_ orientation: ViewImageConfig.Orientation?) -> Self {
        guard let orientation else { return self }
        
        let orientationString = switch orientation {
        case .landscape:
            "Landscape"
        case .portrait:
            "Portrait"
        }
        
        return "\(self)\(orientationString)"
    }
}
