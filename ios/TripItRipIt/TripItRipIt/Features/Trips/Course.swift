import Foundation

struct Course: Identifiable, Decodable, Hashable {
    let id: UUID
    let name: String
    let locationCity: String?
    let locationState: String?
    let architect: String?
    let yearBuilt: Int?
    let heroPhotoUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, name, architect
        case locationCity = "location_city"
        case locationState = "location_state"
        case yearBuilt = "year_built"
        case heroPhotoUrl = "hero_photo_url"
    }
}

extension Course {
    var locationDisplay: String? {
        switch (locationCity, locationState) {
        case let (city?, state?): return "\(city), \(state)"
        case let (city?, nil):    return city
        case (nil, _):            return nil
        }
    }

    /// Lookup for bundled asset-catalog photos. Falls back to `heroPhotoUrl`
    /// (remote) when this returns nil. See Assets.xcassets for image set names.
    static let bundledAssetByCourseName: [String: String] = [
        "Pacific Dunes":                                       "PacificDunes",
        "Old Macdonald":                                       "OldMacdonald",
        "Sheep Ranch":                                         "SheepRanch",
        "Shorty's":                                            "Shortys",
        "PGA West — Mountain Course":                          "PGAWestMountain",
        "Desert Springs — Palm Course":                        "DesertSprings",
        "Desert Willow — Mountain View Course":                "DesertWillow",
        "SilverRock Resort":                                   "SilverRock",
        "Aviara Golf Club":                                    "Aviara",
        "Maderas Golf Club":                                   "Maderas",
        "Torrey Pines Golf Course — South":                    "TorreyPinesSouth",
        "TPC Scottsdale — Stadium Course":                     "TPCStadium",
        "Troon North — Pinnacle Course":                       "TroonNorthPinnacle",
        "We-Ko-Pa — Cholla Course":                            "WeKoPaCholla",
        "We-Ko-Pa — Saguaro Course":                           "WeKoPaSaguaro",
        "Black Desert Resort":                                 "BlackDesert",
        "Coral Canyon":                                        "CoralCanyon",
        "Green Spring":                                        "GreenSpring",
        "Sand Hollow Resort — Championship Course":            "SandHollow",
        "Wolf Creek Golf Club":                                "WolfCreek",
        "Tucson National at Omni Resort — Catalina Course":    "TucsonNationalCatalina",
        "Tucson National at Omni Resort — Sonoran Course":     "TucsonNationalSonoran",
        "Sewailo Golf Club":                                   "Sewailo",
        "Ventana Canyon — Mountain Course":                    "VentanaCanyonMountain"
    ]

    var photoAssetName: String? {
        Course.bundledAssetByCourseName[name]
    }

    var hasAnyPhoto: Bool {
        photoAssetName != nil || heroPhotoUrl != nil
    }

    static let allMockCourses: [Course] = [
        mock("TPC Scottsdale — Stadium Course", "Scottsdale", "AZ", "Tom Weiskopf & Jay Morrish", 1986),
        mock("Troon North — Pinnacle Course",   "Scottsdale", "AZ", "Tom Weiskopf", 1996),
        mock("We-Ko-Pa — Saguaro Course",        "Fort McDowell", "AZ", "Bill Coore & Ben Crenshaw", 2006),
        mock("We-Ko-Pa — Cholla Course",         "Fort McDowell", "AZ", "Scott Miller", 2001),
        mock("PGA West — Mountain Course",       "La Quinta",   "CA", "Pete Dye", 1981),
        mock("Desert Willow — Mountain View Course", "Palm Desert", "CA", "Hurdzan & Fry", 1997),
        mock("Desert Springs — Palm Course",     "Palm Desert", "CA", "Ted Robinson", 1987),
        mock("SilverRock Resort",                "La Quinta",   "CA", "Arnold Palmer", 2005),
        mock("Maderas Golf Club",                "Poway",       "CA", "Johnny Miller", 1999),
        mock("Torrey Pines Golf Course — South", "La Jolla",    "CA", "William Bell", 1957),
        mock("Aviara Golf Club",                 "Carlsbad",    "CA", "Arnold Palmer", 1991),
        mock("Sewailo Golf Club",                "Tucson",      "AZ", "Notah Begay III", 2013),
        mock("Ventana Canyon — Mountain Course", "Tucson",      "AZ", "Tom Fazio", 1984),
        mock("Tucson National at Omni Resort — Sonoran Course",  "Tucson", "AZ", "Robert Bruce Harris", 1962),
        mock("Tucson National at Omni Resort — Catalina Course", "Tucson", "AZ", "Robert Bruce Harris", 1962),
        mock("Sand Hollow Resort — Championship Course", "Hurricane",  "UT", "John Fought", 2008),
        mock("Green Spring",                     "Washington",  "UT", nil, nil),
        mock("Wolf Creek Golf Club",             "Mesquite",    "NV", "Dennis Rider", 2000),
        mock("Coral Canyon",                     "Washington",  "UT", "Keith Foster", 2001),
        mock("Black Desert Resort",              "Ivins",       "UT", "Tom Weiskopf", 2023),
        mock("Bandon Preserve",                  "Bandon",      "OR", "Bill Coore & Ben Crenshaw", 2012,
             photo: "https://upload.wikimedia.org/wikipedia/commons/b/ba/Bandon_Preserve.jpg"),
        mock("Pacific Dunes",                    "Bandon",      "OR", "Tom Doak", 2001),
        mock("Shorty's",                         "Bandon",      "OR", "Bill Coore & Ben Crenshaw", 2020),
        mock("Bandon Dunes",                     "Bandon",      "OR", "David McLay Kidd", 1999,
             photo: "https://upload.wikimedia.org/wikipedia/commons/2/29/Bandon_Dunes_-_4th_hole.jpg"),
        mock("Old Macdonald",                    "Bandon",      "OR", "Tom Doak & Jim Urbina", 2010),
        mock("Sheep Ranch",                      "Bandon",      "OR", "Bill Coore & Ben Crenshaw", 2020),
        mock("Bandon Trails",                    "Bandon",      "OR", "Bill Coore & Ben Crenshaw", 2005,
             photo: "https://upload.wikimedia.org/wikipedia/commons/4/48/Bandon_Trails_approaching_the_18th_fairway.jpg")
    ]

    static func find(byName name: String) -> Course? {
        allMockCourses.first { $0.name == name }
    }

    private static func mock(
        _ name: String,
        _ city: String,
        _ state: String,
        _ architect: String?,
        _ yearBuilt: Int?,
        photo: String? = nil
    ) -> Course {
        Course(
            id: UUID(),
            name: name,
            locationCity: city,
            locationState: state,
            architect: architect,
            yearBuilt: yearBuilt,
            heroPhotoUrl: photo
        )
    }
}
