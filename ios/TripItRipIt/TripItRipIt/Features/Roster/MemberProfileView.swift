import SwiftUI

struct MemberProfileView: View {
    let member: Member

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                hero
                statsRow
                bioSection
                trophyCaseSection
                tripsSection
            }
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.appBackground)
        .navigationTitle(member.fullName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Trip.self) { trip in
            TripDetailView(trip: trip)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                shareButton
            }
        }
    }

    @ViewBuilder
    private var shareButton: some View {
        if let image = renderedShareImage() {
            ShareLink(
                item: image,
                preview: SharePreview(member.fullName, image: image)
            ) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 14, weight: .semibold))
            }
            .accessibilityLabel("Share profile")
            .hapticOnTap(.soft)
        }
    }

    @MainActor
    private func renderedShareImage() -> Image? {
        let renderer = ImageRenderer(content: MemberShareCard(member: member))
        renderer.scale = 2.0
        guard let ui = renderer.uiImage else { return nil }
        return Image(uiImage: ui)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            MemberAvatar(member: member, size: 120)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: Spacing.sm) {
                    Text(member.fullName)
                        .font(AppFont.title)
                        .foregroundStyle(Color.appInk)
                    if member.isOg {
                        MemberBadge(label: "OG", tint: .appAccent)
                    }
                    if member.isGuest {
                        MemberBadge(label: "GUEST", tint: .appMuted)
                    }
                }
                if let city = member.homeCity {
                    Text(city.uppercased())
                        .font(AppFont.caption.weight(.semibold))
                        .tracking(1.5)
                        .foregroundStyle(Color.appMuted)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.lg)
    }

    private var statsRow: some View {
        HStack(spacing: Spacing.lg) {
            stat(label: "Trips", value: String(member.tripsAttendedCount))
            if let hcp = member.handicapDisplay {
                stat(label: "Handicap", value: hcp.replacingOccurrences(of: "HCP ", with: ""))
            }
            if member.isOg {
                stat(label: "Status", value: "Founding")
            }
            if let funFact = member.funFact, !funFact.isEmpty {
                stat(label: "Fun fact", value: funFact)
            }
        }
        .padding(.horizontal, Spacing.lg)
    }

    private func stat(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(AppFont.body(10, weight: .semibold))
                .tracking(1.2)
                .foregroundStyle(Color.appMuted)
            Text(value)
                .font(AppFont.body(15, weight: .semibold))
                .foregroundStyle(Color.appInk)
        }
    }

    @ViewBuilder
    private var bioSection: some View {
        if let card = member.card {
            VStack(alignment: .leading, spacing: Spacing.md) {
                sectionLabel("Trading card")
                VStack(spacing: 0) {
                    cardRow(label: "Catchphrase",       value: "\u{201C}\(card.catchphrase)\u{201D}")
                    cardRow(label: "Signature shot",    value: card.signatureShot)
                    cardRow(label: "Most likely to",    value: card.mostLikelyTo)
                    cardRow(label: "Drink of choice",   value: card.drinkOfChoice)
                    cardRow(label: "Walk-up song",      value: card.walkUpSong)
                    cardRow(label: "Bag liability",     value: card.bagLiability, isLast: true)
                }
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .stroke(Color.appDivider, lineWidth: 1)
                )
                .padding(.horizontal, Spacing.lg)
            }
        }
    }

    private func cardRow(label: String, value: String, isLast: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: Spacing.md) {
                Text(label.uppercased())
                    .font(AppFont.body(10, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(Color.appMuted)
                    .frame(width: 110, alignment: .leading)
                Text(value)
                    .font(AppFont.body(15))
                    .foregroundStyle(Color.appInk)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.md)
            if !isLast {
                Divider().background(Color.appDivider)
            }
        }
    }

    @ViewBuilder
    private var trophyCaseSection: some View {
        let awards = member.memberAwards
        if !awards.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.md) {
                sectionLabel("Trophy case")
                VStack(spacing: Spacing.sm) {
                    ForEach(awards) { award in
                        trophyRow(award: award)
                    }
                }
                .padding(.horizontal, Spacing.lg)
            }
        }
    }

    private func trophyRow(award: Award) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: trophyIcon(for: award))
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(trophyIconColor(for: award))
                .frame(width: 36, height: 36)
                .background(trophyIconColor(for: award).opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(award.title)
                        .font(AppFont.body(15, weight: .semibold))
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
                Text(String(award.year))
                    .font(AppFont.caption)
                    .foregroundStyle(Color.appMuted)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md)
                .stroke(Color.appDivider, lineWidth: 1)
        )
    }

    private func trophyIcon(for award: Award) -> String {
        switch award.category {
        case .championship: return "trophy.fill"
        case .scoring:      return "target"
        case .mishap:       return "exclamationmark.bubble.fill"
        case .behavior:     return "sparkles"
        case .tradition:    return "flag.checkered"
        case .other:        return "rosette"
        }
    }

    private func trophyIconColor(for award: Award) -> Color {
        switch award.category {
        case .championship: return Color(red: 0.72, green: 0.55, blue: 0.18)
        default:            return Color.appAccent
        }
    }

    @ViewBuilder
    private var tripsSection: some View {
        let years = member.attendedTripYears
        if !years.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.md) {
                sectionLabel("Trips attended")
                HStack(spacing: Spacing.sm) {
                    ForEach(years, id: \.self) { year in
                        tripYearBadge(year: year)
                    }
                }
                .padding(.horizontal, Spacing.lg)
            }
        }
    }

    @ViewBuilder
    private func tripYearBadge(year: Int) -> some View {
        let label = Text(String(year))
            .font(AppFont.numeric(15, weight: .semibold))
            .foregroundStyle(Color.appAccent)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.xs)
            .background(Color.appAccent.opacity(0.12))
            .clipShape(Capsule())

        if let trip = Trip.mockTrips.first(where: { $0.year == year }) {
            NavigationLink(value: trip) { label }
                .buttonStyle(.plain)
                .hapticOnTap(.soft)
                .accessibilityLabel("Trip \(year)")
        } else {
            label
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(AppFont.caption.weight(.semibold))
            .tracking(1.5)
            .foregroundStyle(Color.appMuted)
            .padding(.horizontal, Spacing.lg)
    }
}
