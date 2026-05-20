import SwiftUI

struct TrophiesView: View {
    private var sortedTrips: [Trip] {
        Trip.mockTrips.sorted { $0.year > $1.year }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                hero
                ForEach(sortedTrips) { trip in
                    YearShelf(trip: trip)
                }
            }
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.appBackground)
        .navigationTitle("Trophies")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.appAccent)
                    .accessibilityHidden(true)
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
        .padding(.bottom, Spacing.xl)
    }
}

private struct YearShelf: View {
    let trip: Trip

    private var awards: [Award] {
        MockAwards.awards(forYear: trip.year)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            header
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.lg)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.appDivider)
                .frame(height: 1)
        }
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: Spacing.md) {
            Text(String(trip.year))
                .font(AppFont.display(48, weight: .bold))
                .foregroundStyle(Color.appAccent)
                .monospacedDigit()
            Text(trip.locationDisplay.uppercased())
                .font(AppFont.caption.weight(.semibold))
                .tracking(1.5)
                .foregroundStyle(Color.appMuted)
            Spacer()
        }
    }

    @ViewBuilder
    private var content: some View {
        if awards.isEmpty {
            emptyState
        } else {
            VStack(spacing: Spacing.sm) {
                ForEach(awards) { award in
                    TrophyItem(award: award)
                }
            }
        }
    }

    private var emptyState: some View {
        let state = MockAwards.state(for: trip)
        return HStack(spacing: Spacing.sm) {
            Image(systemName: emptyIcon(for: state))
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.appMuted.opacity(0.6))
            Text(emptyLabel(for: state))
                .font(AppFont.footnote)
                .foregroundStyle(Color.appMuted)
            Spacer()
        }
        .padding(.top, Spacing.xs)
    }

    private func emptyIcon(for state: AwardYearState) -> String {
        switch state {
        case .future: return "hourglass"
        case .pendingData: return "ellipsis.circle"
        case .noTournament: return "circle.dashed"
        case .populated: return "circle"
        }
    }

    private func emptyLabel(for state: AwardYearState) -> String {
        switch state {
        case .future(let days):
            return days.map { "\($0) days until trophies" } ?? "Trophies pending"
        case .pendingData:
            return "Awards being compiled"
        case .noTournament:
            return "No awards recorded"
        case .populated:
            return ""
        }
    }
}

private struct TrophyItem: View {
    let award: Award

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            iconView
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(award.title)
                        .font(AppFont.body(16, weight: .semibold))
                        .foregroundStyle(Color.appInk)
                    if award.isTeamAward {
                        Text("TEAM")
                            .font(AppFont.body(9, weight: .bold))
                            .tracking(0.6)
                            .foregroundStyle(Color.appAccent)
                            .padding(.horizontal, 5).padding(.vertical, 1.5)
                            .background(Color.appAccent.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
                Text(award.recipientLabel)
                    .font(AppFont.footnote.weight(.medium))
                    .foregroundStyle(Color.appInk)
                if award.isTeamAward && !award.recipientNicknames.isEmpty {
                    Text(award.recipientNicknames.joined(separator: " · "))
                        .font(AppFont.caption)
                        .foregroundStyle(Color.appMuted)
                }
                if let description = award.description {
                    Text(description)
                        .font(AppFont.caption)
                        .foregroundStyle(Color.appMuted)
                }
            }
            Spacer(minLength: 0)
        }
    }

    private var iconView: some View {
        Image(systemName: icon)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(iconColor)
            .frame(width: 40, height: 40)
            .background(iconColor.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var icon: String {
        switch award.category {
        case .championship: return "trophy.fill"
        case .scoring:      return "target"
        case .mishap:       return "exclamationmark.bubble.fill"
        case .behavior:     return "sparkles"
        case .tradition:    return "flag.checkered"
        case .other:        return "rosette"
        }
    }

    private var iconColor: Color {
        switch award.category {
        case .championship: return Color(red: 0.72, green: 0.55, blue: 0.18)  // brass/gold
        default:            return Color.appAccent
        }
    }
}
