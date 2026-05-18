import Foundation

enum TripEventType: String {
    case golf
    case meal
    case transport
    case other
}

struct TripEvent: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let timeText: String?
    let sortableMinute: Int
    let title: String
    let subtitle: String?
    let eventType: TripEventType
    let externalUrl: String?

    /// Wall-clock start of the event, derived from its day + minute-of-day.
    var startsAt: Date {
        Calendar.current.date(byAdding: .minute, value: sortableMinute, to: date) ?? date
    }
}

enum MockTripEvents {
    static func events(forYear year: Int) -> [TripEvent] {
        switch year {
        case 2026: return bandon2026
        case 2025: return stGeorge2025
        default:   return []
        }
    }

    private static let bandon2026: [TripEvent] = [
        // Thu 7/23
        make("2026-07-23", "5:15 / 5:30 PM", min(17, 15), "Bandon Preserve", nil, .golf),
        make("2026-07-23", "8:30 PM",        min(20, 30), "The Gallery & Puffin Bar", "Dinner", .meal,
             url: "https://bandondunesgolf.com/dining/restaurants/the-gallery-puffin-bar/"),
        // Fri 7/24
        make("2026-07-24", "10:10 / 10:20 AM", min(10, 10), "Pacific Dunes", nil, .golf),
        make("2026-07-24", "4:30 / 4:45 PM",   min(16, 30), "Shorty's",      nil, .golf),
        make("2026-07-24", "8:00 PM",          min(20, 0),  "Pacific Grill", "Dinner", .meal,
             url: "https://bandondunesgolf.com/dining/restaurants/pacific-grill/"),
        // Sat 7/25
        make("2026-07-25", "7:50 / 8:00 AM", min(7, 50),  "Bandon Dunes",   nil, .golf),
        make("2026-07-25", "2:10 / 2:20 PM", min(14, 10), "Old Macdonald",  nil, .golf),
        make("2026-07-25", "8:00 PM",        min(20, 0),  "Ghost Tree",     "Dinner", .meal,
             url: "https://bandondunesgolf.com/dining/restaurants/ghost-tree-grill/"),
        // Sun 7/26
        make("2026-07-26", "7:00 / 7:10 AM", min(7, 0),   "Sheep Ranch",   nil, .golf),
        make("2026-07-26", "1:50 / 2:00 PM", min(13, 50), "Bandon Trails", nil, .golf),
        make("2026-07-26", "7:30 PM",        min(19, 30), "Trails End",    "Dinner", .meal,
             url: "https://bandondunesgolf.com/dining/restaurants/trails-end/"),
        // Mon 7/27
        make("2026-07-27", nil, 0, "Depart", "Connoisseurs → Eugene Airport", .transport)
    ]

    private static let stGeorge2025: [TripEvent] = [
        // Thu 9/25
        make("2025-09-25", "2:51 / 3:02 PM", min(14, 51), "Sand Hollow Resort — Championship Course", nil, .golf),
        // Fri 9/26
        make("2025-09-26", "10:40 / 10:50 AM", min(10, 40), "Green Spring", nil, .golf),
        make("2025-09-26", "6:15 PM",          min(18, 15), "Painted Pony", "Dinner", .meal),
        // Sat 9/27
        make("2025-09-27", "10:10 / 10:20 AM", min(10, 10), "Wolf Creek Golf Club",     nil, .golf),
        make("2025-09-27", "Lunch",            min(12, 0),  "Greg Norman's Grille",     "At Wolf Creek", .meal),
        // Sun 9/28
        make("2025-09-28", "8:10 / 8:20 AM", min(8, 10),  "Coral Canyon",        nil, .golf),
        make("2025-09-28", "2:12 / 2:24 PM", min(14, 12), "Black Desert Resort", nil, .golf),
        // Mon 9/29
        make("2025-09-29", nil, 0, "Depart", "Drive to Las Vegas", .transport)
    ]

    private static func min(_ hours: Int, _ mins: Int) -> Int { hours * 60 + mins }

    private static func make(
        _ dateString: String,
        _ time: String?,
        _ sortMin: Int,
        _ title: String,
        _ subtitle: String?,
        _ type: TripEventType,
        url: String? = nil
    ) -> TripEvent {
        TripEvent(
            date: parseDate(dateString),
            timeText: time,
            sortableMinute: sortMin,
            title: title,
            subtitle: subtitle,
            eventType: type,
            externalUrl: url
        )
    }

    private static func parseDate(_ s: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.date(from: s) ?? Date()
    }
}
