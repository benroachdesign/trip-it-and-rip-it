import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house.lodge.fill") }
                .toolbarBackground(Color.appInk, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)

            NavigationStack { TripsView() }
                .tabItem { Label("Trips", systemImage: "calendar") }
                .toolbarBackground(Color.appInk, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)

            NavigationStack { RosterView() }
                .tabItem { Label("Roster", systemImage: "person.2.fill") }
                .toolbarBackground(Color.appInk, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)

            NavigationStack { TrophiesView() }
                .tabItem { Label("Trophies", systemImage: "trophy.fill") }
                .toolbarBackground(Color.appInk, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
        }
        .tint(.white)
    }
}
