import SwiftUI

struct TrophiesView: View {
    private var tournamentTrips: [Trip] {
        Trip.mockTrips.filter { $0.year >= 2025 }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                hero
                VStack(spacing: Spacing.lg) {
                    ForEach(tournamentTrips) { trip in
                        TrophyYearCard(trip: trip)
                    }
                }
                .padding(.horizontal, Spacing.lg)
            }
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.appBackground)
        .navigationTitle("Trophies")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Trip.self) { trip in
            TripDetailView(trip: trip)
        }
        .navigationDestination(for: Course.self) { course in
            CourseDetailView(course: course)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.appAccent)
                Text("Trophy Room")
                    .font(AppFont.largeTitle)
                    .foregroundStyle(Color.appInk)
            }
            Text("Champions and honors, year by year.")
                .font(AppFont.footnote)
                .foregroundStyle(Color.appMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.md)
    }
}

private struct TrophyYearCard: View {
    let trip: Trip

    private var state: AwardYearState {
        MockAwards.state(for: trip)
    }

    var body: some View {
        NavigationLink(value: trip) {
            VStack(alignment: .leading, spacing: Spacing.md) {
                header
                stateContent
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

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(String(trip.year))
                .font(AppFont.display(48, weight: .bold))
                .foregroundStyle(Color.appAccent)
                .monospacedDigit()
            VStack(alignment: .leading, spacing: 2) {
                Text(trip.locationDisplay.uppercased())
                    .font(AppFont.caption.weight(.semibold))
                    .tracking(1.5)
                    .foregroundStyle(Color.appMuted)
                if let title = trip.tripTitle {
                    Text(title)
                        .font(AppFont.footnote)
                        .foregroundStyle(Color.appMuted)
                }
            }
            Spacer()
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch state {
        case .populated(let awards):
            VStack(spacing: 1) {
                ForEach(awards) { award in
                    AwardRow(award: award)
                }
            }
            .background(Color.appBackground)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        case .pendingData:
            EmptyStateLine(
                icon: "hourglass",
                label: "Awards being compiled",
                detail: "Champions, low rounds, and the usual mishaps will be posted soon."
            )
        case .future(let daysUntilStart):
            EmptyStateLine(
                icon: "calendar",
                label: daysUntilStart.map { "\($0) days until the trophies get fought for" } ?? "Trophies will be crowned this year",
                detail: "Check back after the trip wraps."
            )
        case .noTournament:
            EmptyStateLine(
                icon: "circle.dashed",
                label: "No tournament that year",
                detail: nil
            )
        }
    }
}

private struct AwardRow: View {
    let award: Award

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 22)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text(award.title)
                    .font(AppFont.body(15, weight: .semibold))
                    .foregroundStyle(Color.appInk)
                Text(award.recipientLabel)
                    .font(AppFont.footnote)
                    .foregroundStyle(Color.appMuted)
                if let description = award.description {
                    Text(description)
                        .font(AppFont.caption)
                        .foregroundStyle(Color.appMuted)
                        .padding(.top, 2)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(Spacing.md)
        .background(Color.appSurface)
    }

    private var icon: String {
        switch award.category {
        case .championship: return "trophy.fill"
        case .scoring:      return "target"
        case .mishap:       return "exclamationmark.triangle.fill"
        case .behavior:     return "sparkles"
        case .tradition:    return "flag.checkered.2.crossed"
        case .other:        return "rosette"
        }
    }
}

private struct EmptyStateLine: View {
    let icon: String
    let label: String
    let detail: String?

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.appMuted)
                .frame(width: 22)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(AppFont.body(15, weight: .semibold))
                    .foregroundStyle(Color.appInk)
                if let detail {
                    Text(detail)
                        .font(AppFont.footnote)
                        .foregroundStyle(Color.appMuted)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(Spacing.md)
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
    }
}
