import SwiftUI

struct AuthGateView: View {
    @Environment(AuthViewModel.self) private var auth

    var body: some View {
        if AppEnvironment.bypassAuth {
            RootTabView()
        } else {
            switch auth.state {
            case .loading:
                ProgressView()
                    .controlSize(.large)
            case .signedOut:
                SignedOutView()
            case .notAllowed(let email):
                NotAllowedView(email: email)
            case .signedIn:
                RootTabView()
            }
        }
    }
}
