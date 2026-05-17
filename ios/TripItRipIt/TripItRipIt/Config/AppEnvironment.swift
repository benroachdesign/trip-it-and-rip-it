import Foundation

enum AppEnvironment {
    #if DEBUG
    static let bypassAuth = true
    #else
    static let bypassAuth = false
    #endif

    /// In DEBUG, set this to a date during the trip to preview the during-trip
    /// "Right Now" UI. Set to `nil` to use the real current date.
    ///
    /// Useful values for the 2026 Bandon trip (Jul 23–27):
    ///   Thu Jul 23, 9:00 AM   — morning of arrival, before first round
    ///   Fri Jul 24, 1:00 PM   — Day 2 afternoon between rounds
    ///   Sat Jul 25, 7:00 AM   — Day 3 first tee
    ///   Sun Jul 26, 10:00 PM  — Day 4 evening after Trails End dinner
    #if DEBUG
    static let overrideDate: Date? = nil
    #else
    static let overrideDate: Date? = nil
    #endif

    static var now: Date {
        overrideDate ?? Date()
    }
}
