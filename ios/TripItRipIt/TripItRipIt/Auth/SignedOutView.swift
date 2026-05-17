import AuthenticationServices
import SwiftUI

struct SignedOutView: View {
    @Environment(AuthViewModel.self) private var auth
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentNonce = ""

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            VStack(spacing: 8) {
                Text("Trip it & Rip it!")
                    .font(.system(size: 34, weight: .bold))
                Text("Sign in to continue")
                    .foregroundStyle(.secondary)
            }
            Spacer()
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
            .frame(height: 50)
            if let error = auth.lastError {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 48)
    }
}
