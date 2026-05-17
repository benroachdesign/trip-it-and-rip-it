import Foundation
import Supabase

enum AuthState: Equatable {
    case loading
    case signedOut
    case notAllowed(email: String)
    case signedIn(user: User)

    static func == (lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.signedOut, .signedOut):
            return true
        case let (.notAllowed(l), .notAllowed(r)):
            return l == r
        case let (.signedIn(l), .signedIn(r)):
            return l.id == r.id
        default:
            return false
        }
    }
}
