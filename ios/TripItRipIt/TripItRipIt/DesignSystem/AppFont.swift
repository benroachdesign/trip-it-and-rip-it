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
    static let headline      = body(17, weight: .semibold)
    static let bodyText      = body(17)
    static let footnote      = body(13)
    static let caption       = body(12)
}
