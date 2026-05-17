import SwiftUI

@main
struct TripItRipItApp: App {
    @State private var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            AuthGateView()
                .environment(auth)
                .task { await auth.bootstrap() }
        }
    }
}
