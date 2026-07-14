import SwiftUI
import UIKit

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
        .navigationDestination(for: Member.self) { member in
            MemberProfileView(member: member)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Haptics.tap(.soft)
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(Color.homeInk.opacity(0.65))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Settings")
            }
            .sharedBackgroundVisibility(.hidden)
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
                .monospacedDigit()
            Spacer()
        }
    }

    private func wrappedSection(trip: Trip) -> some View {
        let awards = MockAwards.awards(forYear: trip.year)
        let champions = awards.first { $0.category == .championship }
        let courseOfYear = awards.first { $0.title == "Course of the Year" }

        return NavigationLink(value: trip) {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                wrappedMasthead(trip: trip)
                if champions != nil || courseOfYear != nil {
                    VStack(spacing: Spacing.sm) {
                        if let champions {
                            wrappedRow(
                                caption: "CHAMPIONS",
                                title: champions.recipientLabel,
                                subtitle: champions.recipientNicknames.joined(separator: " · "),
                                icon: "trophy.fill",
                                isBrass: true
                            )
                        }
                        if let courseOfYear {
                            wrappedRow(
                                caption: "COURSE OF THE YEAR",
                                title: courseOfYear.recipientLabel,
                                subtitle: nil,
                                icon: "rosette",
                                isBrass: false
                            )
                        }
                    }
                }
                Text("See the full recap →")
                    .font(AppFont.body(14, weight: .semibold))
                    .foregroundStyle(Color.homeAccent)
            }
            .padding(Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.homeSurface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(Color.homeAccent.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .hapticOnTap(.soft)
    }

    private func wrappedMasthead(trip: Trip) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("TRIP WRAPPED")
                .font(AppFont.body(11, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Color.homeMuted)
            Text(String(trip.year))
                .font(AppFont.display(72, weight: .bold))
                .foregroundStyle(Color.homeAccent)
                .monospacedDigit()
            HStack(spacing: 10) {
                Rectangle()
                    .fill(Color.homeMuted.opacity(0.5))
                    .frame(width: 24, height: 1)
                Text(trip.locationDisplay.uppercased())
                    .font(AppFont.caption.weight(.semibold))
                    .tracking(2)
                    .foregroundStyle(Color.homeMuted)
            }
        }
    }

    private func wrappedRow(
        caption: String,
        title: String,
        subtitle: String?,
        icon: String,
        isBrass: Bool
    ) -> some View {
        let tint: Color = isBrass
            ? Color(red: 0.847, green: 0.776, blue: 0.553)  // brass / homeAccent equiv
            : Color.homeInk

        return HStack(alignment: .top, spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 36, height: 36)
                .background(tint.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(caption)
                    .font(AppFont.body(10, weight: .semibold))
                    .tracking(1.5)
                    .foregroundStyle(Color.homeMuted)
                Text(title)
                    .font(AppFont.body(16, weight: .semibold))
                    .foregroundStyle(Color.homeInk)
                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(AppFont.caption)
                        .foregroundStyle(Color.homeMuted)
                }
            }
            Spacer(minLength: 0)
        }
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
        VStack(alignment: .leading, spacing: 0) {
            Text("FIRST UP")
                .font(AppFont.body(11, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Color.homeMuted)
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.md)
                .padding(.bottom, Spacing.md)
            VStack(spacing: 1) {
                ForEach(Array(events), id: \.id) { event in
                    HomeEventRow(event: event)
                }
            }
            viewFullScheduleLink
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.homeSurface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Color.homeDivider, lineWidth: 1)
        )
    }

    // Footer link into the full trip page (which carries the complete schedule).
    private var viewFullScheduleLink: some View {
        NavigationLink(value: trip) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.homeDivider)
                    .frame(height: 1)
                HStack(spacing: 6) {
                    Text("VIEW FULL SCHEDULE")
                        .font(AppFont.body(11, weight: .semibold))
                        .tracking(1.5)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .accessibilityHidden(true)
                }
                .foregroundStyle(Color.homeAccent)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.md - 2)
                .contentShape(Rectangle())
            }
        }
        .buttonStyle(.plain)
        .hapticOnTap(.soft)
        .accessibilityLabel("View full schedule")
        .accessibilityHint("Opens the 2026 Bandon trip page")
    }
}

private struct NextUpHero: View {
    let event: TripEvent
    let now: Date

    private var linkedCourse: Course? {
        guard event.eventType == .golf else { return nil }
        return Course.find(byName: event.title)
    }

    private var externalUrl: URL? {
        guard let urlString = event.externalUrl else { return nil }
        return URL(string: urlString)
    }

    var body: some View {
        if let course = linkedCourse {
            NavigationLink(value: course) {
                cardBody(trailing: .chevron)
            }
            .buttonStyle(.plain)
            .hapticOnTap(.soft)
        } else if let url = externalUrl {
            Link(destination: url) {
                cardBody(trailing: .external)
            }
            .buttonStyle(.plain)
            .hapticOnTap(.soft)
        } else {
            cardBody(trailing: .none)
        }
    }

    private enum Trailing { case chevron, external, none }

    private func cardBody(trailing: Trailing) -> some View {
        HStack(alignment: .top, spacing: Spacing.md) {
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
                        .accessibilityHidden(true)
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
            Spacer(minLength: 0)
            VStack(alignment: .trailing, spacing: Spacing.sm) {
                heroThumbnail
                trailingAffordance(trailing)
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

    @ViewBuilder
    private var heroThumbnail: some View {
        if let course = linkedCourse,
           let assetName = course.photoAssetName,
           UIImage(named: assetName) != nil {
            Image(assetName)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func trailingAffordance(_ trailing: Trailing) -> some View {
        switch trailing {
        case .chevron:
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.homeMuted.opacity(0.6))
                .accessibilityHidden(true)
        case .external:
            Image(systemName: "arrow.up.right.square")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.homeMuted.opacity(0.6))
                .accessibilityHidden(true)
        case .none:
            EmptyView()
        }
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
                    HomeEventRow(event: event)
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
                    HomeEventRow(event: event)
                }
            }
            .background(Color.homeSurface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        }
    }
}
