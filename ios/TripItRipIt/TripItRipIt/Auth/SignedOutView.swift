import AuthenticationServices
import SwiftUI

struct SignedOutView: View {
    @Environment(AuthViewModel.self) private var auth
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentNonce = ""

    private let privacyURL = URL(string: "https://benroachdesign.github.io/trip-it-and-rip-it-privacy/")!

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                masthead
                Spacer()
                signInBlock
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xxl)
            .padding(.top, Spacing.xl)
        }
    }

    private var masthead: some View {
        VStack(spacing: Spacing.md) {
            Text("T&R")
                .font(AppFont.display(80, weight: .bold))
                .foregroundStyle(Color.appAccent)
                .accessibilityHidden(true)

            Rectangle()
                .fill(Color.appDivider)
                .frame(width: 48, height: 1)

            VStack(spacing: 6) {
                Text("Trip it & Rip it!")
                    .font(AppFont.title)
                    .foregroundStyle(Color.appInk)
                Text("A private app for the boys.")
                    .font(AppFont.footnote)
                    .foregroundStyle(Color.appMuted)
            }
        }
    }

    private var signInBlock: some View {
        VStack(spacing: Spacing.md) {
            SignInWithAppleButton(.signIn) { request in
                let nonce = Nonce.random()
                currentNonce = nonce
                request.requestedScopes = [.email, .fullName]
                request.nonce = Nonce.sha256(nonce)
            } onCompletion: { result in
                Task {
                    switch result {
                    case .success(let authorization):
                        await auth.handleAppleAuthorization(authorization, rawNonce: currentNonce)
                    case .failure:
                        break
                    }
                }
            }
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(height: 52)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            if let error = auth.lastError {
                Text(error)
                    .font(AppFont.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Link(destination: privacyURL) {
                Text("Privacy")
                    .font(AppFont.caption.weight(.semibold))
                    .tracking(1.2)
                    .foregroundStyle(Color.appMuted)
            }
            .padding(.top, Spacing.sm)
            .accessibilityHint("Opens the privacy policy in your browser")
        }
    }
}
