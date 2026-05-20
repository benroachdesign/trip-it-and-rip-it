import SwiftUI

struct HomeView: View {
    @Environment(AuthViewModel.self) private var auth
    @State private var showSettings = false
    @State private var showTripStartTakeover = false

    // Triggers a re-render whenever the time-travel override changes.
    @AppStorage("timeTravel.anchorVirtual") private var ttAnchor: Double = 0

    private var now: Date { AppEnvironment.now }

    /// Treated as the "currently signed-in user" for mock/dev. Roach for now;
    /// will come from the auth session when sign-in is wired up live.
    private var currentMember: Member? {
        Member.allMockMembers.first { $0.nickname == "Roach" }
    }

    private var greetingFirstName: String {
        guard let fullName = currentMember?.fullName else { return "friend" }
        return fullName.split(separator: " ").first.map(String.init) ?? fullName
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
        // Read ttAnchor so SwiftUI tracks the dependency and re-renders
        // when the time-travel preset changes from another view.
        _ = ttAnchor

        return ZStack {
            Color.homeBackground.ignoresSafeArea()
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

            if showTripStartTakeover {
                TripStartTakeover {
                    withAnimation(AppMotion.soft) {
                        showTripStartTakeover = false
                    }
                }
                .zIndex(10)
            }
        }
        .onAppear { evaluateTripStartTakeover() }
        .onChange(of: ttAnchor) { evaluateTripStartTakeover() }
        .toolbarBackground(Color.homeBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
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
                Button {
                    Haptics.tap(.soft)
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.homeInk)
                }
                .accessibilityLabel("Settings")
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    private var greeting: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Good \(timeOfDay)")
                .font(AppFont.footnote)
                .foregroundStyle(Color.homeMuted)
            Text(greetingFirstName)
                .font(AppFont.display(34, weight: .bold))
                .foregroundStyle(Color.homeInk)
        }
        .padding(.top, Spacing.lg)
    }

    private func evaluateTripStartTakeover() {
        guard case .during(let trip) = tripState else { return }
        if TripStartTakeoverFlag.hasBeenShown(forYear: trip.year) { return }
        TripStartTakeoverFlag.markShown(forYear: trip.year)
        withAnimation(AppMotion.soft) {
            showTripStartTakeover = true
        }
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
        VStack(spacing: Spacing.lg) {
            CountdownCard(trip: trip, days: days)
            FirstUpCard(trip: trip)
            BandonMapCard()
            if let member = currentMember,
               LodgingAssignment.bandon2026(for: member.nickname) != nil {
                LodgingCard(member: member)
            }
        }
    }

    private func duringSection(trip: Trip) -> some View {
        let allEvents = MockTripEvents.events(forYear: trip.year)
        let nextEvent = allEvents.first { $0.startsAt > now }
        let remainingToday = allEvents.filter {
            Calendar.current.isDate($0.date, inSameDayAs: now) && $0.startsAt > now
        }
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
        let nextDayEvents = allEvents.filter {
            Calendar.current.isDate($0.date, inSameDayAs: tomorrow)
        }

        return VStack(alignment: .leading, spacing: Spacing.lg) {
            dayBadge(trip: trip)
            if let next = nextEvent {
                NextUpHero(event: next, now: now)
            }
            if !remainingToday.isEmpty {
                TodaySchedule(events: remainingToday, now: now)
            }
            if !nextDayEvents.isEmpty {
                TomorrowPreview(events: nextDayEvents)
            }
        }
    }

    private func dayBadge(trip: Trip) -> some View {
        let start = Calendar.current.startOfDay(for: trip.startDate ?? now)
        let today = Calendar.current.startOfDay(for: now)
        let dayNumber = (Calendar.current.dateComponents([.day], from: start, to: today).day ?? 0) + 1
        let totalDays: Int = {
            guard let startD = trip.startDate, let endD = trip.endDate else { return 0 }
            return (Calendar.current.dateComponents([.day], from: startD, to: endD).day ?? 0) + 1
        }()

        return HStack {
            Text("DAY \(max(1, dayNumber)) OF \(totalDays) · \(trip.locationCity.uppercased())")
                .font(AppFont.body(11, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Color.homeMuted)
            Spacer()
        }
    }

    private func wrappedSection(trip: Trip) -> some View {
        NavigationLink(value: trip) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Trip wrapped")
                    .font(AppFont.sectionHeader)
                    .foregroundStyle(Color.homeInk)
                Text("\(trip.locationDisplay) · \(String(trip.year))")
                    .font(AppFont.footnote)
                    .foregroundStyle(Color.homeMuted)
                Text("See the recap →")
                    .font(AppFont.body(15, weight: .semibold))
                    .foregroundStyle(Color.homeAccent)
                    .padding(.top, Spacing.xs)
            }
            .padding(Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.homeSurface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(Color.homeDivider, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .hapticOnTap(.soft)
    }
}

private enum TripState {
    case none
    case upcoming(trip: Trip, daysUntil: Int)
    case during(trip: Trip)
    case wrapped(trip: Trip)
}

private struct CountdownCard: View {
    let trip: Trip
    let days: Int

    var body: some View {
        NavigationLink(value: trip) {
            VStack(alignment: .leading, spacing: Spacing.md) {
                VStack(alignment: .leading, spacing: -8) {
                    Text(String(days))
                        .font(AppFont.display(140, weight: .bold))
                        .foregroundStyle(Color.homeAccent)
                        .monospacedDigit()
                        .contentTransition(.numericText(value: Double(days)))
                        .animation(AppMotion.soft, value: days)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Text("DAYS UNTIL \(trip.locationCity.uppercased())")
                        .font(AppFont.body(12, weight: .semibold))
                        .tracking(2)
                        .foregroundStyle(Color.homeMuted)
                }
                if let range = trip.dateRangeDisplay {
                    Text(range)
                        .font(AppFont.headline)
                        .foregroundStyle(Color.homeInk)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.lg)
            .background(Color.homeSurface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(Color.homeDivider, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .hapticOnTap(.soft)
    }
}

private struct FirstUpCard: View {
    let trip: Trip

    var body: some View {
        let events = MockTripEvents.events(forYear: trip.year).prefix(3)
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("FIRST UP")
                .font(AppFont.body(11, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Color.homeMuted)
            VStack(alignment: .leading, spacing: Spacing.sm) {
                ForEach(Array(events), id: \.id) { event in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.timeText ?? "—")
                            .font(AppFont.numeric(12, weight: .semibold))
                            .foregroundStyle(Color.homeMuted)
                        Text(event.title)
                            .font(AppFont.body(15, weight: .semibold))
                            .foregroundStyle(Color.homeInk)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.homeSurface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Color.homeDivider, lineWidth: 1)
        )
    }
}

private struct NextUpHero: View {
    let event: TripEvent
    let now: Date

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("NEXT UP IN \(countdownText)")
                .font(AppFont.body(11, weight: .semibold))
                .tracking(1.8)
                .foregroundStyle(Color.homeAccent)
            Text(event.title)
                .font(AppFont.display(36, weight: .bold))
                .foregroundStyle(Color.homeInk)
                .lineLimit(2)
            HStack(spacing: Spacing.sm) {
                Image(systemName: iconName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.homeMuted)
                Text(headerLine)
                    .font(AppFont.numeric(14, weight: .semibold))
                    .foregroundStyle(Color.homeMuted)
            }
            if let subtitle = event.subtitle {
                Text(subtitle)
                    .font(AppFont.footnote)
                    .foregroundStyle(Color.homeMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.homeSurface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Color.homeAccent.opacity(0.4), lineWidth: 1)
        )
    }

    private var countdownText: String {
        let interval = event.startsAt.timeIntervalSince(now)
        if interval < 60 { return "MINUTES" }
        let hours = Int(interval) / 3600
        let mins = (Int(interval) % 3600) / 60
        if hours == 0 { return "\(mins)M" }
        if mins == 0 { return "\(hours)H" }
        return "\(hours)H \(mins)M"
    }

    private var headerLine: String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        let day = dayFormatter.string(from: event.date)
        if let time = event.timeText {
            return "\(time) · \(day)"
        }
        return day
    }

    private var iconName: String {
        switch event.eventType {
        case .golf: return "flag.fill"
        case .meal: return "fork.knife"
        case .transport: return "airplane"
        case .other: return "circle.fill"
        }
    }
}

private struct TodaySchedule: View {
    let events: [TripEvent]
    let now: Date

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("REST OF TODAY")
                .font(AppFont.body(10, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Color.homeMuted)
            VStack(spacing: 1) {
                ForEach(events) { event in
                    SmallEventRow(event: event, now: now)
                }
            }
            .background(Color.homeSurface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        }
    }
}

private struct TomorrowPreview: View {
    let events: [TripEvent]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("TOMORROW")
                .font(AppFont.body(10, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Color.homeMuted)
            VStack(spacing: 1) {
                ForEach(events) { event in
                    SmallEventRow(event: event, now: nil)
                }
            }
            .background(Color.homeSurface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        }
    }
}

private struct SmallEventRow: View {
    let event: TripEvent
    let now: Date?

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            Text(event.timeText ?? "—")
                .font(AppFont.numeric(12, weight: .semibold))
                .foregroundStyle(Color.homeMuted)
                .frame(width: 96, alignment: .trailing)
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(AppFont.body(15, weight: .semibold))
                    .foregroundStyle(Color.homeInk)
                if let subtitle = event.subtitle {
                    Text(subtitle)
                        .font(AppFont.caption)
                        .foregroundStyle(Color.homeMuted)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.homeSurface)
    }
}
