import Foundation

enum AppEnvironment {
    #if DEBUG
    static let bypassAuth = true
    #else
    static let bypassAuth = false
    #endif
}
