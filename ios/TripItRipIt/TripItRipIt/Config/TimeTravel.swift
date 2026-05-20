import Foundation

/// Runtime "time travel" for testing the during-trip UX without rebuilding.
/// When active, `TimeTravel.now` returns a virtual date that ticks forward
/// from a chosen anchor — so countdowns still tick live.
enum TimeTravel {
    private static let kAnchorReal = "timeTravel.anchorReal"
    private static let kAnchorVirtual = "timeTravel.anchorVirtual"

    static var isActive: Bool {
        UserDefaults.standard.object(forKey: kAnchorVirtual) != nil
    }

    static func setOverride(to virtual: Date) {
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: kAnchorReal)
        UserDefaults.standard.set(virtual.timeIntervalSince1970, forKey: kAnchorVirtual)
    }

    static func clearOverride() {
        UserDefaults.standard.removeObject(forKey: kAnchorReal)
        UserDefaults.standard.removeObject(forKey: kAnchorVirtual)
    }

    static var now: Date {
        guard
            let realTI = UserDefaults.standard.object(forKey: kAnchorReal) as? Double,
            let virtTI = UserDefaults.standard.object(forKey: kAnchorVirtual) as? Double
        else {
            return Date()
        }
        let offset = virtTI - realTI
        return Date().addingTimeInterval(offset)
    }

    static var virtualAnchor: Date? {
        guard let virtTI = UserDefaults.standard.object(forKey: kAnchorVirtual) as? Double else {
            return nil
        }
        return Date(timeIntervalSince1970: virtTI)
    }
}

struct TimeTravelPreset: Identifiable, Hashable {
    let id: String
    let label: String
    let detail: String
    let date: Date

    static let bandon2026: [TimeTravelPreset] = [
        TimeTravelPreset(
            id: "day1-morning",
            label: "Day 1 · Thu Jul 23",
            detail: "9:00 AM — morning of arrival",
            date: makeDate(2026, 7, 23, 9, 0)
        ),
        TimeTravelPreset(
            id: "day2-afternoon",
            label: "Day 2 · Fri Jul 24",
            detail: "1:00 PM — between rounds",
            date: makeDate(2026, 7, 24, 13, 0)
        ),
        TimeTravelPreset(
            id: "day3-firsttee",
            label: "Day 3 · Sat Jul 25",
            detail: "7:00 AM — first tee",
            date: makeDate(2026, 7, 25, 7, 0)
        ),
        TimeTravelPreset(
            id: "day4-evening",
            label: "Day 4 · Sun Jul 26",
            detail: "10:00 PM — after Trails End",
            date: makeDate(2026, 7, 26, 22, 0)
        ),
        TimeTravelPreset(
            id: "departure-morning",
            label: "Day 5 · Mon Jul 27",
            detail: "8:00 AM — departure morning",
            date: makeDate(2026, 7, 27, 8, 0)
        ),
        TimeTravelPreset(
            id: "post-trip",
            label: "Tue Jul 28",
            detail: "Trip wrapped — recap state",
            date: makeDate(2026, 7, 28, 12, 0)
        )
    ]

    private static func makeDate(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.timeZone = TimeZone(identifier: "America/Los_Angeles")
        return Calendar.current.date(from: components) ?? Date()
    }
}
