import SwiftUI
import UIKit

@main
struct TripItRipItApp: App {
    @State private var auth = AuthViewModel()

    init() {
        // Make the tab bar opaque so its icons stay crisp against the dark
        // green Home background. Default behaviour is translucent and the
        // icons disappear against the deep fairway color.
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
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
