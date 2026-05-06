import UIKit

/// An enumeration representing the accessibility contrast for snapshot testing.
///
/// This enum defines three possible contrast values:
/// - `.normal`: The default contrast used by the system.
/// - `.high`: Increased contrast, matching the "Increase Contrast" accessibility setting.
/// - `.unspecified`: An unspecified contrast, where the contrast is not explicitly defined.
///
/// Use this enum to specify the accessibility contrast when configuring snapshots for
/// testing how the UI renders with the "Increase Contrast" accessibility setting enabled.
public enum SnapshotContrast {
    case normal
    case high
    case unspecified
}

public extension SnapshotContrast {
    /// Maps the `SnapshotContrast` to its corresponding `UIAccessibilityContrast`.
    ///
    /// The `UIAccessibilityContrast` is used to define the accessibility contrast of the
    /// user interface. This property is useful for applying the appropriate contrast in
    /// a snapshot testing context.
    ///
    /// - Returns: The `UIAccessibilityContrast` that corresponds to the contrast value.
    var uiAccessibilityContrast: UIAccessibilityContrast {
        switch self {
        case .normal: return .normal
        case .high: return .high
        case .unspecified: return .unspecified
        }
    }

    /// Returns the name of the contrast as a `String`.
    ///
    /// This property provides a textual representation of the contrast, which can be
    /// useful for logging, debugging, or for use in file names or identifiers related to
    /// snapshots.
    ///
    /// - Returns: A `String` representing the name of the contrast.
    var name: String {
        switch self {
        case .normal: return "normal"
        case .high: return "high"
        case .unspecified: return "unspecified"
        }
    }
}
