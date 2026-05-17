import Foundation

struct Trip: Identifiable, Decodable, Hashable {
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
            ]
        ),
        MockTripDetail(
            trip: Trip(
                id: UUID(), year: 2025, tripTitle: "Trip it & Rip it!",
                locationCity: "St. George", locationState: "UT",
                startDate: nil, endDate: nil,
                winningTeamId: nil, heroPhotoUrl: nil, blurb: nil
            ),
            featuredCourseName: "Sand Hollow — Championship",
            courseNames: [
                "Sand Hollow — Championship", "Black Desert Resort",
                "Wolf Creek", "Coral Canyon", "Green Spring"
            ]
        ),
        MockTripDetail(
            trip: Trip(
                id: UUID(), year: 2024, tripTitle: "Annual Gentlemen's Golf Club",
                locationCity: "Tucson", locationState: "AZ",
                startDate: nil, endDate: nil,
                winningTeamId: nil, heroPhotoUrl: nil, blurb: nil
            ),
            featuredCourseName: "Ventana Canyon — Mountain",
            courseNames: [
                "Ventana Canyon — Mountain", "Sewailo",
                "Tucson National — Sonoran", "Tucson National — Catalina"
            ]
        ),
        MockTripDetail(
            trip: Trip(
                id: UUID(), year: 2023, tripTitle: "Annual Gentlemen's Golf Club",
                locationCity: "San Diego", locationState: "CA",
                startDate: nil, endDate: nil,
                winningTeamId: nil, heroPhotoUrl: nil, blurb: nil
            ),
            featuredCourseName: "Torrey Pines — South",
            courseNames: ["Torrey Pines — South", "Maderas", "Aviara"]
        ),
        MockTripDetail(
            trip: Trip(
                id: UUID(), year: 2022, tripTitle: "Men's Golf Weekend",
                locationCity: "Palm Desert", locationState: "CA",
                startDate: nil, endDate: nil,
                winningTeamId: nil, heroPhotoUrl: nil, blurb: nil
            ),
            featuredCourseName: "PGA West — Mountain",
            courseNames: [
                "PGA West — Mountain", "Desert Willow — Mountain View",
                "Desert Springs — Palm", "SilverRock Resort"
            ]
        ),
        MockTripDetail(
            trip: Trip(
                id: UUID(), year: 2021, tripTitle: "Men's Golf Weekend",
                locationCity: "Scottsdale", locationState: "AZ",
                startDate: nil, endDate: nil,
                winningTeamId: nil, heroPhotoUrl: nil, blurb: nil
            ),
            featuredCourseName: "TPC Scottsdale — Stadium",
            courseNames: [
                "TPC Scottsdale — Stadium", "Troon North — Pinnacle",
                "We-Ko-Pa — Saguaro", "We-Ko-Pa — Cholla"
            ]
        )
    ]

    static let mockTrips: [Trip] = mockDetails.map(\.trip)

    static func mockCourseNames(for tripId: UUID) -> [String] {
        mockDetails.first(where: { $0.trip.id == tripId })?.courseNames ?? []
    }

    static func mockFeaturedCourse(for tripId: UUID) -> String? {
        mockDetails.first(where: { $0.trip.id == tripId })?.featuredCourseName
    }

    private static func dateFrom(_ string: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.date(from: string) ?? Date()
    }
}
