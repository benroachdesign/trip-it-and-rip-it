import SwiftUI

struct NotAllowedView: View {
    @Environment(AuthViewModel.self) private var auth
    let email: String

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "lock.shield")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
            VStack(spacing: 8) {
                Text("Not on the list")
                    .font(.title2.weight(.semibold))
                Text("`\(email)` isn't invited yet. Reach out to Roach if you should be.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            Button("Try another account") {
                Task { await auth.signOut() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 48)
    }
}
