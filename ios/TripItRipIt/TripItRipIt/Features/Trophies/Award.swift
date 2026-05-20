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
    // 2026 fills in after the trip. Older years can have any award (not just championships).
    static let all: [Award] = [
        Award(
            year: 2025,
            title: "Champions",
            category: .championship,
            recipientLabel: "Rippers",
            recipientNicknames: ["Roach", "Tommer", "Braden", "Derek"],
            description: "Final: Rippers 19.5, Trippers 10",
            isTeamAward: true
        ),
        Award(
            year: 2025,
            title: "Most Lost Balls",
            category: .mishap,
            recipientLabel: "Mader",
            recipientNicknames: ["Mader"],
            description: nil,
            isTeamAward: false
        ),
        Award(
            year: 2023,
            title: "Most SpongeBob Ice Pops",
            category: .behavior,
            recipientLabel: "Webb",
            recipientNicknames: ["Webb"],
            description: nil,
            isTeamAward: false
        ),
        Award(
            year: 2024,
            title: "Champions",
            category: .championship,
            recipientLabel: "Newbs",
            recipientNicknames: ["Webb", "Lutz", "Derek", "Tommer"],
            description: nil,
            isTeamAward: true
        ),
        Award(
            year: 2024,
            title: "70s Score",
            category: .scoring,
            recipientLabel: "Roach",
            recipientNicknames: ["Roach"],
            description: "Shot a 79",
            isTeamAward: false
        ),
        Award(
            year: 2023,
            title: "Champions",
            category: .championship,
            recipientLabel: "OGs",
            recipientNicknames: ["Roach", "Strub", "Braden", "Mader"],
            description: nil,
            isTeamAward: true
        ),
        Award(
            year: 2023,
            title: "Worst Course",
            category: .other,
            recipientLabel: "Torrey Pines South",
            recipientNicknames: [],
            description: nil,
            isTeamAward: false
        ),
        Award(
            year: 2022,
            title: "Most Casinos Run in a Single Trip",
            category: .behavior,
            recipientLabel: "The OGs",
            recipientNicknames: ["Roach", "Strub", "Mader", "Braden"],
            description: "Aguas Calientes ×5",
            isTeamAward: true
        ),
        Award(
            year: 2021,
            title: "Successfully Dealt With the Cops",
            category: .tradition,
            recipientLabel: "Mader",
            recipientNicknames: ["Mader"],
            description: nil,
            isTeamAward: false
        ),
        Award(
            year: 2025,
            title: "Course of the Year",
            category: .other,
            recipientLabel: "Wolf Creek Golf Club",
            recipientNicknames: [],
            description: nil,
            isTeamAward: false
        ),
        Award(
            year: 2024,
            title: "Course of the Year",
            category: .other,
            recipientLabel: "Ventana Canyon — Mountain Course",
            recipientNicknames: [],
            description: nil,
            isTeamAward: false
        ),
        Award(
            year: 2023,
            title: "Course of the Year",
            category: .other,
            recipientLabel: "Aviara Golf Club",
            recipientNicknames: [],
            description: nil,
            isTeamAward: false
        ),
        Award(
            year: 2022,
            title: "Course of the Year",
            category: .other,
            recipientLabel: "PGA West — Mountain Course",
            recipientNicknames: [],
            description: nil,
            isTeamAward: false
        ),
        Award(
            year: 2021,
            title: "Course of the Year",
            category: .other,
            recipientLabel: "Troon North — Pinnacle Course",
            recipientNicknames: [],
            description: nil,
            isTeamAward: false
        )
    ]

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
