import SwiftUI

struct NotAllowedView: View {
    @Environment(AuthViewModel.self) private var auth
    let email: String

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                content
                Spacer()
                retryButton
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xxl)
            .padding(.top, Spacing.xl)
        }
    }

    private var content: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "lock.shield")
                .font(.system(size: 44, weight: .regular))
                .foregroundStyle(Color.appAccent)
                .accessibilityHidden(true)

            Rectangle()
                .fill(Color.appDivider)
                .frame(width: 48, height: 1)

            VStack(spacing: Spacing.sm) {
                Text("Not on the list")
                    .font(AppFont.title)
                    .foregroundStyle(Color.appInk)

                VStack(spacing: 4) {
                    Text(email)
                        .font(AppFont.body(14, weight: .semibold))
                        .foregroundStyle(Color.appInk)
                        .monospaced()
                    Text("isn't invited yet.")
                        .font(AppFont.footnote)
                        .foregroundStyle(Color.appMuted)
                }
                .multilineTextAlignment(.center)

                Text("Reach out to Roach if you should be.")
                    .font(AppFont.footnote)
                    .foregroundStyle(Color.appMuted)
                    .multilineTextAlignment(.center)
                    .padding(.top, Spacing.xs)
            }
        }
    }

    private var retryButton: some View {
        Button {
            Haptics.tap(.medium)
            Task { await auth.signOut() }
        } label: {
            Text("Try another account")
                .font(AppFont.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.appAccent)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
