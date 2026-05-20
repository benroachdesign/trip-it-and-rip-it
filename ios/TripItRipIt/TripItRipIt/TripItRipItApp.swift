import SwiftUI
import UIKit

@main
struct TripItRipItApp: App {
    @State private var auth = AuthViewModel()

    init() {
        // Tab bar uses a fully opaque system background so the icons don't
        // disappear when sitting on top of the Home tab's dark green canvas
        // (default translucent material let the green bleed through and the
        // selected accent-green icon vanished).
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some Scene {
        WindowGroup {
            AuthGateView()
                .environment(auth)
                .task { await auth.bootstrap() }
        }
    }
}
