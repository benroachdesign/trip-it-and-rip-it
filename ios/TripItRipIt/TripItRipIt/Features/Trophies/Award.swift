import Foundation

struct Award: Identifiable, Hashable {
    let id = UUID()
    let year: Int
    let title: String
    let category: AwardCategory
    let recipientLabel: String
    let recipientNicknames: [String]
    let description: String?
    let isTeamAward: Bool
}

enum AwardCategory: String, CaseIterable {
    case championship
    case scoring
    case mishap
    case behavior
    case tradition
    case other

    var displayLabel: String {
        switch self {
        case .championship: return "Championship"
        case .scoring:      return "Scoring"
        case .mishap:       return "Mishap"
        case .behavior:     return "Behavior"
        case .tradition:    return "Tradition"
        case .other:        return "Other"
        }
    }
}

enum MockAwards {
    // Populate as the user supplies award data per year.
    // 2025 will be filled in when Ben sends the St. George recap; 2026 after the trip.
    static let all: [Award] = []

    static func awards(forYear year: Int) -> [Award] {
        all.filter { $0.year == year }
    }
}

enum AwardYearState {
    case noTournament
    case pendingData
    case populated([Award])
    case future(daysUntilStart: Int?)
}

extension MockAwards {
    static func state(for trip: Trip, today: Date = Date()) -> AwardYearState {
        let yearAwards = awards(forYear: trip.year)
        if !yearAwards.isEmpty {
            return .populated(yearAwards)
        }

        let cal = Calendar.current
        if let start = trip.startDate, cal.startOfDay(for: start) > cal.startOfDay(for: today) {
            let days = cal.dateComponents([.day], from: cal.startOfDay(for: today), to: cal.startOfDay(for: start)).day
            return .future(daysUntilStart: days)
        }

        // 2025 onward had the Ryder Cup format; pre-2025 had no formal tournament.
        return trip.year >= 2025 ? .pendingData : .noTournament
    }
}
