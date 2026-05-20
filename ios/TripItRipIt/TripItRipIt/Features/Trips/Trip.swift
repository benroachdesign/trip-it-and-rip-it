import Foundation

struct Trip: Identifiable, Codable, Hashable {
    let id: UUID
    let year: Int
    let tripTitle: String?
    let locationCity: String
    let locationState: String?
    let startDate: Date?
    let endDate: Date?
    let winningTeamId: UUID?
    let heroPhotoUrl: String?
    let blurb: String?

    enum CodingKeys: String, CodingKey {
        case id, year
        case tripTitle = "trip_title"
        case locationCity = "location_city"
        case locationState = "location_state"
        case startDate = "start_date"
        case endDate = "end_date"
        case winningTeamId = "winning_team_id"
        case heroPhotoUrl = "hero_photo_url"
        case blurb
    }
}

extension Trip {
    var locationDisplay: String {
        if let state = locationState {
            return "\(locationCity), \(state)"
        }
        return locationCity
    }

    var dateRangeDisplay: String? {
        guard let start = startDate, let end = endDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: start)) – \(formatter.string(from: end))"
    }
}

struct MockTripDetail {
    let trip: Trip
    let featuredCourseName: String
    let courseNames: [String]
    let attendeeNicknames: [String]
    let lodgingLabel: String?
    let lodgingAddress: String?
}

extension Trip {
    static let mockDetails: [MockTripDetail] = [
        MockTripDetail(
            trip: Trip(
                id: UUID(), year: 2026, tripTitle: "Trip it & Rip it!",
                locationCity: "Bandon", locationState: "OR",
                startDate: dateFrom("2026-07-23"), endDate: dateFrom("2026-07-27"),
                winningTeamId: nil, heroPhotoUrl: nil, blurb: nil
            ),
            featuredCourseName: "Pacific Dunes",
            courseNames: [
                "Pacific Dunes", "Bandon Dunes", "Old Macdonald",
                "Sheep Ranch", "Bandon Trails", "Bandon Preserve", "Shorty's"
            ],
            attendeeNicknames: ["Roach", "Strub", "Mader", "Braden", "Webb", "Tommer", "Bliz", "Kyle"],
            lodgingLabel: "4 Lily Pond rooms at Bandon Dunes Resort",
            lodgingAddress: "57744 Round Lake Drive, Bandon, OR 97411"
        ),
        MockTripDetail(
            trip: Trip(
                id: UUID(), year: 2025, tripTitle: "Trip it & Rip it!",
                locationCity: "St. George", locationState: "UT",
                startDate: dateFrom("2025-09-25"), endDate: dateFrom("2025-09-29"),
                winningTeamId: nil, heroPhotoUrl: nil, blurb: nil
            ),
            featuredCourseName: "Black Desert Resort",
            courseNames: [
                "Black Desert Resort", "Wolf Creek Golf Club",
                "Sand Hollow Resort — Championship Course", "Coral Canyon", "Green Spring"
            ],
            attendeeNicknames: ["Roach", "Mader", "Braden", "Webb", "Tommer", "Lutz", "Derek", "Mike"],
            lodgingLabel: "VRBO",
            lodgingAddress: "5173 W 2150 S, Hurricane, UT 84737"
        ),
        MockTripDetail(
            trip: Trip(
                id: UUID(), year: 2024, tripTitle: "Annual Gentlemen's Golf Club",
                locationCity: "Tucson", locationState: "AZ",
                startDate: dateFrom("2024-11-15"), endDate: dateFrom("2024-11-17"),
                winningTeamId: nil, heroPhotoUrl: nil, blurb: nil
            ),
            featuredCourseName: "Ventana Canyon — Mountain Course",
            courseNames: [
                "Ventana Canyon — Mountain Course", "Sewailo Golf Club",
                "Tucson National at Omni Resort — Sonoran Course",
                "Tucson National at Omni Resort — Catalina Course"
            ],
            attendeeNicknames: ["Roach", "Strub", "Mader", "Braden", "Webb", "Tommer", "Lutz", "Derek"],
            lodgingLabel: nil,
            lodgingAddress: nil
        ),
        MockTripDetail(
            trip: Trip(
                id: UUID(), year: 2023, tripTitle: "Annual Gentlemen's Golf Club",
                locationCity: "San Diego", locationState: "CA",
                startDate: dateFrom("2023-11-02"), endDate: dateFrom("2023-11-06"),
                winningTeamId: nil, heroPhotoUrl: nil, blurb: nil
            ),
            featuredCourseName: "Torrey Pines Golf Course — South",
            courseNames: [
                "Torrey Pines Golf Course — South",
                "Maderas Golf Club", "Aviara Golf Club"
            ],
            attendeeNicknames: ["Roach", "Strub", "Mader", "Braden", "Webb", "Tommer", "Lutz", "Derek"],
            lodgingLabel: "Vintage Castle in the Sky",
            lodgingAddress: "7390 Mar Avenue, La Jolla, CA 92037"
        ),
        MockTripDetail(
            trip: Trip(
                id: UUID(), year: 2022, tripTitle: "Men's Golf Weekend",
                locationCity: "Palm Desert", locationState: "CA",
                startDate: dateFrom("2022-12-08"), endDate: dateFrom("2022-12-12"),
                winningTeamId: nil, heroPhotoUrl: nil, blurb: nil
            ),
            featuredCourseName: "PGA West — Mountain Course",
            courseNames: [
                "PGA West — Mountain Course",
                "Desert Willow — Mountain View Course",
                "Desert Springs — Palm Course",
                "SilverRock Resort"
            ],
            attendeeNicknames: ["Roach", "Strub", "Mader", "Braden"],
            lodgingLabel: "Rancho Mirage Private Oasis",
            lodgingAddress: "71387 Sahara Road, Rancho Mirage, CA 92270"
        ),
        MockTripDetail(
            trip: Trip(
                id: UUID(), year: 2021, tripTitle: "Men's Golf Weekend",
                locationCity: "Scottsdale", locationState: "AZ",
                startDate: nil, endDate: nil,
                winningTeamId: nil, heroPhotoUrl: nil, blurb: nil
            ),
            featuredCourseName: "TPC Scottsdale — Stadium Course",
            courseNames: [
                "TPC Scottsdale — Stadium Course",
                "Troon North — Pinnacle Course",
                "We-Ko-Pa — Saguaro Course",
                "We-Ko-Pa — Cholla Course"
            ],
            attendeeNicknames: ["Roach", "Strub", "Mader", "Braden"],
            lodgingLabel: "Airbnb",
            lodgingAddress: "3331 N 63rd St, Scottsdale, AZ 85251"
        )
    ]

    static let mockTrips: [Trip] = mockDetails.map(\.trip)

    static func mockCourseNames(for tripId: UUID) -> [String] {
        mockDetails.first(where: { $0.trip.id == tripId })?.courseNames ?? []
    }

    static func mockFeaturedCourse(for tripId: UUID) -> String? {
        mockDetails.first(where: { $0.trip.id == tripId })?.featuredCourseName
    }

    static func mockDetail(for tripId: UUID) -> MockTripDetail? {
        mockDetails.first(where: { $0.trip.id == tripId })
    }

    static func mockAttendees(for tripId: UUID) -> [Member] {
        let nicknames = mockDetail(for: tripId)?.attendeeNicknames ?? []
        return nicknames.compactMap { nick in
            Member.allMockMembers.first(where: { $0.nickname == nick })
        }
    }

    /// Resolves the Course whose photo should be used as the year-card hero.
    /// Prefers the featured course if it has a photo, otherwise the first course
    /// played that year that has any photo (bundled asset or remote URL).
    static func mockHeroCourse(for tripId: UUID) -> Course? {
        guard let detail = mockDetail(for: tripId) else { return nil }
        if let featured = Course.find(byName: detail.featuredCourseName), featured.hasAnyPhoto {
            return featured
        }
        return detail.courseNames
            .compactMap { Course.find(byName: $0) }
            .first { $0.hasAnyPhoto }
    }

    private static func dateFrom(_ string: String) -> Date {
        let parts = string.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { return Date() }
        var components = DateComponents()
        components.year = parts[0]
        components.month = parts[1]
        components.day = parts[2]
        return Calendar.current.date(from: components) ?? Date()
    }
}
