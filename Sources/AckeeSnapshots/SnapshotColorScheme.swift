import UIKit

/// An enumeration representing the color scheme for snapshot testing.
///
/// This enum defines three possible color schemes:
/// - `.light`: A light color scheme, typically used for light-themed user interfaces.
/// - `.dark`: A dark color scheme, used for dark-themed user interfaces.
/// - `.unspecified`: An unspecified color scheme, where the color scheme is not explicitly defined.
///
/// Use this enum to specify the color scheme when configuring snapshots for testing different
/// appearance modes.
public enum SnapshotColorScheme {
    case light
    case dark
    case unspecified
}

public extension SnapshotColorScheme {
    /// Maps the `SnapshotColorScheme` to its corresponding `UIUserInterfaceStyle`.
    ///
    /// The `UIUserInterfaceStyle` is used to define the appearance of the user interface
    /// based on the color scheme. This property is useful for applying the appropriate
    /// interface style in a snapshot testing context.
    ///
    /// - Returns: The `UIUserInterfaceStyle` that corresponds to the color scheme.
    var uiUserInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .unspecified: return .unspecified
        }
    }

    /// Returns the name of the color scheme as a `String`.
    ///
    /// This property provides a textual representation of the color scheme, which can be
    /// useful for logging, debugging, or for use in file names or identifiers related to
    /// snapshots.
    ///
    /// - Returns: A `String` representing the name of the color scheme.
    var name: String {
        switch self {
        case .light: return "light"
        case .dark: return "dark"
        case .unspecified: return "unspecified"
        }
    }
}
