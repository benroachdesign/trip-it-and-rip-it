import SwiftUI

struct RootTabView: View {
    enum Tab: Hashable { case home, trips, roster, trophies }

    @State private var selection: Tab = .home

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack { HomeView() }
                .tag(Tab.home)
                .tabItem { Label("Home", systemImage: "house.lodge.fill") }
                .toolbarBackground(Color.appInk, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)

            NavigationStack { TripsView() }
                .tag(Tab.trips)
                .tabItem { Label("Trips", systemImage: "calendar") }
                .toolbarBackground(Color.appBackground, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.light, for: .tabBar)

            NavigationStack { RosterView() }
                .tag(Tab.roster)
                .tabItem { Label("Roster", systemImage: "person.2.fill") }
                .toolbarBackground(Color.appBackground, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.light, for: .tabBar)

            NavigationStack { TrophiesView() }
                .tag(Tab.trophies)
                .tabItem { Label("Trophies", systemImage: "trophy.fill") }
                .toolbarBackground(Color.appBackground, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.light, for: .tabBar)
        }
        .tint(selection == .home ? .white : Color.appInk)
    }
}
