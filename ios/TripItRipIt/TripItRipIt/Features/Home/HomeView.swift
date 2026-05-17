import SwiftUI

struct HomeView: View {
    @Environment(AuthViewModel.self) private var auth

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Text("Home")
                .font(AppFont.largeTitle)
                .foregroundStyle(Color.appInk)
            Text("Right-now view comes here")
                .font(AppFont.bodyText)
                .foregroundStyle(Color.appMuted)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.lg)
        .background(Color.appBackground)
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Sign out") { Task { await auth.signOut() } }
            }
        }
    }
}
