import SnapshotTesting

/// A configuration struct used for defining device-specific snapshot testing settings.
///
/// This struct contains a `name` to identify the device configuration and a `ViewImageConfig`
/// that describes the settings for the snapshot, such as the device's screen size and scale.
///
/// Use this struct to create different snapshot configurations for various devices and screen sizes
/// when using the `SnapshotTesting` framework.
///
/// Example:
/// ```
/// let config = SnapshotDeviceConfig(name: "iPhone 12", config: .iPhone12)
/// ```
public struct SnapshotDeviceConfig {

    /// The name of the device configuration. This can be used for identifying the configuration
    /// or for logging purposes.
    public let name: String

    /// The configuration for the snapshot image, including settings like device type, screen size,
    /// and scale.
    public let config: ViewImageConfig

    // MARK: - Initializers

    /// Initializes a new `SnapshotDeviceConfig` with the specified name and configuration.
    ///
    /// - Parameters:
    ///   - name: A string representing the name of the device configuration.
    ///   - config: The `ViewImageConfig` instance specifying the snapshot settings for the device.
    ///
    /// Example:
    /// ```
    /// let deviceConfig = SnapshotDeviceConfig(name: "iPhone 12", config: .iPhone12)
    /// ```
    public init(
        name: String,
        config: ViewImageConfig
    ) {
        self.name = name
        self.config = config
    }

    /// The layout configuration for the snapshot. Returns a `SwiftUISnapshotLayout` configured
    /// with the device-specific settings.
    ///
    /// This property converts the `ViewImageConfig` into a `SwiftUISnapshotLayout.device` layout
    /// that can be used for snapshot testing.
    public var layout: SwiftUISnapshotLayout {
        .device(config: config)
    }
}
