import SwiftUI

enum AppFont {
    static func display(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    static func body(_ size: CGFloat = 17, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }

    static func numeric(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .default).monospacedDigit()
    }

    static let yearHero      = display(96, weight: .bold)
    static let largeTitle    = display(34, weight: .bold)
    static let title         = display(28, weight: .semibold)
    static let sectionHeader = display(20, weight: .semibold)

    // Body-text tokens use system text styles so they respect Dynamic Type.
    // Display sizes above stay fixed so the editorial hero typography
    // doesn't get blown out by accessibility-5.
    static let headline      = Font.system(.headline, design: .default).weight(.semibold)
    static let bodyText      = Font.system(.body, design: .default)
    static let footnote      = Font.system(.footnote, design: .default)
    static let caption       = Font.system(.caption, design: .default)
}
