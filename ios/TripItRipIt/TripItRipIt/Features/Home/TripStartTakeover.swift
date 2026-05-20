import SwiftUI

struct TripStartTakeover: View {
    let onDismiss: () -> Void

    @State private var showFirstLine = false
    @State private var showSecondLine = false

    var body: some View {
        ZStack {
            Color.homeBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: -16) {
                Text("TRIP IT.")
                    .font(AppFont.display(72, weight: .bold))
                    .foregroundStyle(Color.homeInk)
                    .opacity(showFirstLine ? 1 : 0)
                    .offset(y: showFirstLine ? 0 : 12)

                Text("RIP IT.")
                    .font(AppFont.display(72, weight: .bold))
                    .foregroundStyle(Color.homeAccent)
                    .opacity(showSecondLine ? 1 : 0)
                    .offset(y: showSecondLine ? 0 : 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.lg)

            VStack {
                Spacer()
                Text("Tap to begin")
                    .font(AppFont.body(11, weight: .semibold))
                    .tracking(2)
                    .foregroundStyle(Color.homeMuted)
                    .opacity(showSecondLine ? 0.7 : 0)
                    .padding(.bottom, Spacing.xxl)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            Haptics.tap(.soft)
            onDismiss()
        }
        .onAppear {
            withAnimation(AppMotion.slow) { showFirstLine = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(AppMotion.slow) { showSecondLine = true }
                Haptics.success()
            }
        }
        .transition(.opacity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Trip it, rip it. Tap anywhere to continue.")
    }
}

enum TripStartTakeoverFlag {
    private static let prefix = "tripStartTakeoverShown."

    static func key(forYear year: Int) -> String { "\(prefix)\(year)" }

    static func hasBeenShown(forYear year: Int) -> Bool {
        UserDefaults.standard.bool(forKey: key(forYear: year))
    }

    static func markShown(forYear year: Int) {
        UserDefaults.standard.set(true, forKey: key(forYear: year))
    }
}
