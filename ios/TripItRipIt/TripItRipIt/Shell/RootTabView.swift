import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack { TripsView() }
                .tabItem { Label("Trips", systemImage: "calendar") }

            NavigationStack { RosterView() }
                .tabItem { Label("Roster", systemImage: "person.2.fill") }

            NavigationStack { TrophiesView() }
                .tabItem { Label("Trophies", systemImage: "trophy.fill") }
        }
        .tint(.appAccent)
    }
}
