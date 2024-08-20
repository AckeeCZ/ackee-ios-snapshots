import UIKit

/// Represents the various content size categories for snapshots.
public enum SnapshotContentSize {
    /// Represents an unspecified content size category.
    case unspecified

    /// Represents the extra small content size category.
    case extraSmall

    /// Represents the small content size category.
    case small

    /// Represents the medium content size category.
    case medium

    /// Represents the large content size category.
    case large

    /// Represents the extra large content size category.
    case extraLarge

    /// Represents the extra extra large content size category.
    case extraExtraLarge

    /// Represents the extra extra extra large content size category.
    case extraExtraExtraLarge

    /// Represents the medium accessibility content size category.
    case accessibilityMedium

    /// Represents the large accessibility content size category.
    case accessibilityLarge

    /// Represents the extra large accessibility content size category.
    case accessibilityExtraLarge

    /// Represents the extra extra large accessibility content size category.
    case accessibilityExtraExtraLarge

    /// Represents the extra extra extra large accessibility content size category.
    case accessibilityExtraExtraExtraLarge
}

public extension SnapshotContentSize {
    /// Converts `SnapshotContentSize` to its corresponding `UIContentSizeCategory`.
    ///
    /// - Returns: The `UIContentSizeCategory` that corresponds to the `SnapshotContentSize` case.
    var uiContentSizeCategory: UIContentSizeCategory {
        switch self {
        case .unspecified: return .unspecified
        case .extraSmall: return .extraSmall
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        case .extraLarge: return .extraLarge
        case .extraExtraLarge: return .extraExtraLarge
        case .extraExtraExtraLarge: return .extraExtraExtraLarge
        case .accessibilityMedium: return .accessibilityMedium
        case .accessibilityLarge: return .accessibilityLarge
        case .accessibilityExtraLarge: return .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge: return .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge: return .accessibilityExtraExtraExtraLarge
        }
    }

    /// Provides a human-readable name for each `SnapshotContentSize` case.
    ///
    /// - Returns: A string representing a user-friendly name for the `SnapshotContentSize` case.
    var name: String {
        switch self {
        case .unspecified: return "unspecified"
        case .extraSmall: return "sizeXS"
        case .small: return "sizeS"
        case .medium: return "sizeM"
        case .large: return "sizeL"
        case .extraLarge: return "sizeXL"
        case .extraExtraLarge: return "sizeXXL"
        case .extraExtraExtraLarge: return "sizeXXXL"
        case .accessibilityMedium: return "a11ySizeM"
        case .accessibilityLarge: return "a11ySizeL"
        case .accessibilityExtraLarge: return "a11ySizeXL"
        case .accessibilityExtraExtraLarge: return "a11ySizeXXL"
        case .accessibilityExtraExtraExtraLarge: return "a11ySizeXXXL"
        }
    }

}
