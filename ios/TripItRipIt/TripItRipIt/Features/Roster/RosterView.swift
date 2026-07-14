import Supabase
import SwiftUI

struct RosterView: View {
    @State private var members: [Member] = []
    @State private var loadError: String?

    var body: some View {
        Group {
            if let loadError {
                ContentUnavailableView(
                    "Couldn't load roster",
                    systemImage: "person.2.slash",
                    description: Text(loadError)
                )
            } else if members.isEmpty {
                ProgressView().controlSize(.large)
            } else {
                rosterContent
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Roster")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Member.self) { member in
            MemberProfileView(member: member)
        }
        .task { await load() }
    }

    private var rosterContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                rosterHero
                membersList
            }
            .padding(.bottom, Spacing.xl)
        }
        .refreshable { await load() }
    }

    private var rosterHero: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.appAccent)
                    .accessibilityHidden(true)
                Text("Roster")
                    .font(AppFont.largeTitle)
                    .foregroundStyle(Color.appInk)
            }
            Text("The boys, in attendance order.")
                .font(AppFont.footnote)
                .foregroundStyle(Color.appMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.md)
        .padding(.bottom, Spacing.lg)
    }

    private var membersList: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(members.enumerated()), id: \.element.id) { index, member in
                NavigationLink(value: member) {
                    memberRowContent(member: member)
                }
                .buttonStyle(.plain)
                .hapticOnTap(.soft)
                if index < members.count - 1 {
                    Rectangle()
                        .fill(Color.appDivider)
                        .frame(height: 1)
                        .padding(.leading, Spacing.lg + 44 + Spacing.md)
                }
            }
        }
    }

    private func memberRowContent(member: Member) -> some View {
        HStack(spacing: Spacing.sm) {
            MemberRow(member: member)
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.appMuted.opacity(0.55))
                .accessibilityHidden(true)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.sm)
        .contentShape(Rectangle())
    }

    private func load() async {
        if AppEnvironment.bypassAuth {
            members = Member.mockRoster
            return
        }
        if members.isEmpty, let cached = LocalCache.load([Member].self, forKey: CacheKey.members) {
            members = cached
        }
        do {
            let fresh: [Member] = try await SupabaseService.client
                .from("members")
                .select("id, full_name, nickname, sort_order, is_guest, is_og, home_city, handicap, fun_fact, bio")
                .order("sort_order")
                .execute()
                .value
            members = fresh
            LocalCache.save(fresh, forKey: CacheKey.members)
            loadError = nil
        } catch {
            if members.isEmpty {
                loadError = error.localizedDescription
            }
        }
    }
}

struct Member: Identifiable, Codable, Hashable {
    let id: UUID
    let fullName: String
    let nickname: String?
    let sortOrder: Int
    let isGuest: Bool
    let isOg: Bool
    let homeCity: String?
    let handicap: Double?
    let funFact: String?
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case nickname
        case sortOrder = "sort_order"
        case isGuest = "is_guest"
        case isOg = "is_og"
        case homeCity = "home_city"
        case handicap
        case funFact = "fun_fact"
        case bio
    }
}

extension Member {
    var handicapDisplay: String? {
        guard let handicap else { return nil }
        if handicap.truncatingRemainder(dividingBy: 1) == 0 {
            return "HCP \(Int(handicap))"
        }
        return "HCP \(String(format: "%.1f", handicap))"
    }
}

extension Member {
    static let allMockMembers: [Member] = [
        Member(id: UUID(), fullName: "Ben Roach",       nickname: "Roach",  sortOrder: 10,  isGuest: false, isOg: true,  homeCity: "Chicago",       handicap: 12.7, funFact: nil, bio: nil),
        Member(id: UUID(), fullName: "Ryan Strub",      nickname: "Strub",  sortOrder: 20,  isGuest: false, isOg: true,  homeCity: "Madison",       handicap: 15.1, funFact: nil, bio: nil),
        Member(id: UUID(), fullName: "Austin Mader",    nickname: "Mader",  sortOrder: 30,  isGuest: false, isOg: true,  homeCity: "Dallas",        handicap: 17.0, funFact: nil, bio: nil),
        Member(id: UUID(), fullName: "Braden Carlson",  nickname: "Braden", sortOrder: 40,  isGuest: false, isOg: true,  homeCity: "Chicago",       handicap: 12.4, funFact: nil, bio: nil),
        Member(id: UUID(), fullName: "Matt Webb",       nickname: "Webb",   sortOrder: 50,  isGuest: false, isOg: false, homeCity: "Austin",        handicap: 10.5, funFact: nil, bio: nil),
        Member(id: UUID(), fullName: "Tommer Butman",   nickname: "Tommer", sortOrder: 60,  isGuest: false, isOg: false, homeCity: "Chicago",       handicap: 14.1, funFact: nil, bio: nil),
        Member(id: UUID(), fullName: "Chris Lutz",      nickname: "Lutz",   sortOrder: 70,  isGuest: false, isOg: false, homeCity: "San Francisco", handicap: 11.5, funFact: nil, bio: nil),
        Member(id: UUID(), fullName: "Derek DeCarolis", nickname: "Derek",  sortOrder: 80,  isGuest: false, isOg: false, homeCity: "Minneapolis",   handicap: 13.9, funFact: nil, bio: nil),
        Member(id: UUID(), fullName: "Alex Blizniak",   nickname: "Bliz",   sortOrder: 90,  isGuest: true,  isOg: false, homeCity: "Chicago",  handicap: 11, funFact: nil, bio: nil),
        Member(id: UUID(), fullName: "Kyle Worley",     nickname: "Kyle",   sortOrder: 100, isGuest: true,  isOg: false, homeCity: "Portland", handicap: 4,  funFact: nil, bio: nil),
        Member(id: UUID(), fullName: "Mike Steward",    nickname: "Mike",   sortOrder: 110, isGuest: true,  isOg: false, homeCity: "Austin",   handicap: 7,  funFact: nil, bio: nil)
    ]

    static let mockRoster: [Member] = allMockMembers

    var tripsAttendedCount: Int {
        guard let nickname else { return 0 }
        return Trip.mockDetails.filter { $0.attendeeNicknames.contains(nickname) }.count
    }

    var attendedTripYears: [Int] {
        guard let nickname else { return [] }
        return Trip.mockDetails
            .filter { $0.attendeeNicknames.contains(nickname) }
            .map { $0.trip.year }
            .sorted()
    }

    /// All awards where this member is a recipient — solo or as part of a
    /// team. Sorted newest-first for display in the profile trophy case.
    var memberAwards: [Award] {
        guard let nickname else { return [] }
        return MockAwards.all
            .filter { $0.recipientNicknames.contains(nickname) }
            .sorted { $0.year > $1.year }
    }
}
