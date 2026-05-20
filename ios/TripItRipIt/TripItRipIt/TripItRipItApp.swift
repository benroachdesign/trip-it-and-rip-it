import SwiftUI

@main
struct TripItRipItApp: App {
    @State private var auth = AuthViewModel()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                AuthGateView()
                    .environment(auth)
                    .task { await auth.bootstrap() }
                if !hasSeenOnboarding {
                    OnboardingView(done: Binding(
                        get: { false },
                        set: { newValue in
                            if newValue {
                                withAnimation(AppMotion.soft) {
                                    hasSeenOnboarding = true
                                }
                            }
                        }
                    ))
                    .transition(.opacity)
                    .zIndex(100)
                }
            }
        }
    }
}
