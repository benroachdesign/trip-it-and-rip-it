import SwiftUI

struct HomeView: View {
    @Environment(AuthViewModel.self) private var auth

    private let now = Date()

    private var greetingNickname: String {
        Member.allMockMembers.first(where: { $0.nickname == "Roach" })?.nickname ?? "friend"
    }

    private var nextTrip: Trip? {
        let today = Calendar.current.startOfDay(for: now)
        let upcoming = Trip.mockTrips.filter { trip in
            let end: Date = trip.endDate ?? trip.startDate ?? .distantPast
            return end >= today
        }
        return upcoming.min { lhs, rhs in
            let lhsStart: Date = lhs.startDate ?? .distantFuture
            let rhsStart: Date = rhs.startDate ?? .distantFuture
            return lhsStart < rhsStart
        }
    }

    private var lastTrip: Trip? {
        let past = Trip.mockTrips.filter { trip in
            let end: Date = trip.endDate ?? .distantPast
            return end < now
        }
        return past.max { lhs, rhs in
            let lhsEnd: Date = lhs.endDate ?? .distantPast
            let rhsEnd: Date = rhs.endDate ?? .distantPast
            return lhsEnd < rhsEnd
        }
    }

    private var tripState: TripState {
        guard let trip = nextTrip, let start = trip.startDate, let end = trip.endDate else {
            return .none
        }
        let today = Calendar.current.startOfDay(for: now)
        if today < Calendar.current.startOfDay(for: start) {
            let days = Calendar.current.dateComponents([.day], from: today, to: start).day ?? 0
            return .upcoming(trip: trip, daysUntil: max(0, days))
        } else if today > Calendar.current.startOfDay(for: end) {
            return .wrapped(trip: trip)
        } else {
            return .during(trip: trip)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                greeting
                Group {
                    switch tripState {
                    case .upcoming(let trip, let days):
                        upcomingSection(trip: trip, days: days)
                    case .during(let trip):
                        duringSection(trip: trip)
                    case .wrapped(let trip):
                        wrappedSection(trip: trip)
                    case .none:
                        EmptyView()
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.appBackground)
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Trip.self) { trip in
            TripDetailView(trip: trip)
        }
        .navigationDestination(for: Course.self) { course in
            CourseDetailView(course: course)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Sign out") { Task { await auth.signOut() } }
            }
        }
    }

    private var greeting: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Good \(timeOfDay)")
                .font(AppFont.footnote)
                .foregroundStyle(Color.appMuted)
            Text(greetingNickname)
                .font(AppFont.display(34, weight: .bold))
                .foregroundStyle(Color.appInk)
        }
        .padding(.top, Spacing.lg)
    }

    private var timeOfDay: String {
        let hour = Calendar.current.component(.hour, from: now)
        switch hour {
        case 4..<12: return "morning"
        case 12..<17: return "afternoon"
        default: return "evening"
        }
    }

    private func upcomingSection(trip: Trip, days: Int) -> some View {
        NavigationLink(value: trip) {
            VStack(alignment: .leading, spacing: Spacing.md) {
                VStack(alignment: .leading, spacing: -8) {
                    Text(String(days))
                        .font(AppFont.display(140, weight: .bold))
                        .foregroundStyle(Color.appAccent)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Text("DAYS UNTIL \(trip.locationCity.uppercased())")
                        .font(AppFont.body(12, weight: .semibold))
                        .tracking(2)
                        .foregroundStyle(Color.appMuted)
                }
                if let range = trip.dateRangeDisplay {
                    Text(range)
                        .font(AppFont.headline)
                        .foregroundStyle(Color.appInk)
                }
                Divider().background(Color.appDivider).padding(.vertical, Spacing.xs)
                upcomingPreview(trip: trip)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.lg)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(Color.appDivider, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func upcomingPreview(trip: Trip) -> some View {
        let events = MockTripEvents.events(forYear: trip.year).prefix(3)
        return VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("FIRST UP")
                .font(AppFont.body(10, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Color.appMuted)
            ForEach(Array(events), id: \.id) { event in
                HStack(alignment: .top, spacing: Spacing.md) {
                    Text(event.timeText ?? "—")
                        .font(AppFont.numeric(13, weight: .semibold))
                        .foregroundStyle(Color.appInk)
                        .frame(width: 96, alignment: .trailing)
                    Text(event.title)
                        .font(AppFont.body(15))
                        .foregroundStyle(Color.appInk)
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func duringSection(trip: Trip) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Right now")
                .font(AppFont.sectionHeader)
                .foregroundStyle(Color.appInk)
            Text("Next event and today's schedule will appear here during the trip.")
                .font(AppFont.bodyText)
                .foregroundStyle(Color.appMuted)
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Color.appDivider, lineWidth: 1)
        )
    }

    private func wrappedSection(trip: Trip) -> some View {
        NavigationLink(value: trip) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Trip wrapped")
                    .font(AppFont.sectionHeader)
                    .foregroundStyle(Color.appInk)
                Text("\(trip.locationDisplay) · \(String(trip.year))")
                    .font(AppFont.footnote)
                    .foregroundStyle(Color.appMuted)
                Text("See the recap →")
                    .font(AppFont.body(15, weight: .semibold))
                    .foregroundStyle(Color.appAccent)
                    .padding(.top, Spacing.xs)
            }
            .padding(Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(Color.appDivider, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private enum TripState {
    case none
    case upcoming(trip: Trip, daysUntil: Int)
    case during(trip: Trip)
    case wrapped(trip: Trip)
}
