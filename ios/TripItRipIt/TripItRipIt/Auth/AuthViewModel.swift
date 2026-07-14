import AuthenticationServices
import Foundation
import Supabase
import SwiftUI

@MainActor
@Observable
final class AuthViewModel {
    var state: AuthState = .loading
    var lastError: String?

    private let client = SupabaseService.client
    private var authTask: Task<Void, Never>?

    func bootstrap() async {
        if let session = try? await client.auth.session {
            await apply(session: session)
        } else {
            state = .signedOut
        }
        authTask?.cancel()
        authTask = Task { [weak self] in
            guard let self else { return }
            for await change in client.auth.authStateChanges {
                switch change.event {
                case .signedIn, .tokenRefreshed, .userUpdated:
                    if let session = change.session {
                        await self.apply(session: session)
                    }
                case .signedOut:
                    self.state = .signedOut
                default:
                    break
                }
            }
        }
    }

    func handleAppleAuthorization(_ authorization: ASAuthorization, rawNonce: String) async {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let token = String(data: tokenData, encoding: .utf8) else {
            lastError = "Apple did not return an identity token."
            return
        }
        do {
            try await client.auth.signInWithIdToken(
                credentials: .init(provider: .apple, idToken: token, nonce: rawNonce)
            )
        } catch {
            lastError = "Apple sign-in failed: \(error.localizedDescription)"
        }
    }

    func signOut() async {
        try? await client.auth.signOut()
        state = .signedOut
    }

    // Access is gated by TestFlight (only invited installs get the app), so any
    // successful Apple sign-in is allowed straight through. This previously
    // checked an `allowed_emails` table; that redundant second gate was removed.
    private func apply(session: Session) async {
        state = .signedIn(user: session.user)
        lastError = nil
    }
}
