import SwiftUI
import UIKit

enum Haptics {
    static func tap(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

extension View {
    func hapticOnTap(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
        simultaneousGesture(
            TapGesture().onEnded { Haptics.tap(style) }
        )
    }
}

enum AppMotion {
    static let snappy = Animation.spring(response: 0.32, dampingFraction: 0.85)
    static let soft   = Animation.spring(response: 0.48, dampingFraction: 0.82)
    static let slow   = Animation.spring(response: 0.85, dampingFraction: 0.9)

    static let quickFade = Animation.easeOut(duration: 0.2)
}

struct AppShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    static let cardLow = AppShadow(
        color: Color.black.opacity(0.06),
        radius: 8, x: 0, y: 2
    )

    static let cardHigh = AppShadow(
        color: Color.black.opacity(0.12),
        radius: 18, x: 0, y: 6
    )
}

extension View {
    func appShadow(_ shadow: AppShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
