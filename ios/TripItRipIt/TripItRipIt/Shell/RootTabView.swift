import SwiftUI
import UIKit

struct RootTabView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.appInk)
        appearance.shadowColor = .clear

        let inactive = UIColor(white: 1, alpha: 0.55)
        let active = UIColor.white

        appearance.stackedLayoutAppearance.normal.iconColor = inactive
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: inactive]
        appearance.stackedLayoutAppearance.selected.iconColor = active
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: active]

        appearance.inlineLayoutAppearance.normal.iconColor = inactive
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: inactive]
        appearance.inlineLayoutAppearance.selected.iconColor = active
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: active]

        appearance.compactInlineLayoutAppearance.normal.iconColor = inactive
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: inactive]
        appearance.compactInlineLayoutAppearance.selected.iconColor = active
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: active]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house.lodge.fill") }

            NavigationStack { TripsView() }
                .tabItem { Label("Trips", systemImage: "calendar") }

            NavigationStack { RosterView() }
                .tabItem { Label("Roster", systemImage: "person.2.fill") }

            NavigationStack { TrophiesView() }
                .tabItem { Label("Trophies", systemImage: "trophy.fill") }
        }
        .tint(.white)
    }
}
