import SwiftUI
import UIKit

struct TripDetailView: View {
    let trip: Trip

    private var heroCourse: Course? {
        Trip.mockHeroCourse(for: trip.id)
    }

    private var attendees: [Member] {
        Trip.mockAttendees(for: trip.id)
    }

    private var detail: MockTripDetail? {
        Trip.mockDetail(for: trip.id)
    }

    private var scheduleEvents: [TripEvent] {
        MockTripEvents.events(forYear: trip.year)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                heroSection
                attendeesSection
                if !scheduleEvents.isEmpty {
                    scheduleSection
                }
                coursesSection
                lodgingSection
            }
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.appBackground)
        .navigationTitle(String(trip.year))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            ZStack(alignment: .bottomLeading) {
                heroBackground
                    .frame(height: 240)
                    .clipped()
                    .filmGrain()
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .clear, location: 0.4),
                        .init(color: .black.opacity(0.75), location: 1)
                    ],
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: 240)
                .allowsHitTesting(false)

                VStack(alignment: .leading, spacing: 8) {
                    Text(String(trip.year))
                        .font(AppFont.display(80, weight: .bold))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                        .shadow(color: .black.opacity(0.35), radius: 8, y: 2)
                    HStack(spacing: 10) {
                        Rectangle()
                            .fill(Color.white.opacity(0.55))
                            .frame(width: 32, height: 1)
                        Text(trip.locationDisplay.uppercased())
                            .font(AppFont.caption.weight(.semibold))
                            .tracking(2)
                            .foregroundStyle(.white.opacity(0.92))
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.lg)
            }

            VStack(alignment: .leading, spacing: 2) {
                if let dateRange = trip.dateRangeDisplay {
                    Text(dateRange)
                        .font(AppFont.headline)
                        .foregroundStyle(Color.appInk)
                }
                if let title = trip.tripTitle {
                    Text(title)
                        .font(AppFont.footnote)
                        .foregroundStyle(Color.appMuted)
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
    }

    @ViewBuilder
    private var heroBackground: some View {
        if let assetName = heroCourse?.photoAssetName, UIImage(named: assetName) != nil {
            Image(assetName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
        } else if let urlString = heroCourse?.heroPhotoUrl ?? trip.heroPhotoUrl,
                  let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    placeholderHero
                }
            }
            .frame(maxWidth: .infinity)
        } else {
            placeholderHero
        }
    }

    private var placeholderHero: some View {
        LinearGradient(
            colors: [Color.appAccent, Color.appAccent.opacity(0.7)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        .overlay {
            if let featured = detail?.featuredCourseName {
                Text(featured)
                    .font(AppFont.display(28, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.lg)
            }
        }
    }

    private var attendeesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionLabel(text: "Who came")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.md) {
                    ForEach(attendees) { member in
                        NavigationLink(value: member) {
                            AttendeeAvatar(member: member)
                        }
                        .buttonStyle(.plain)
                        .hapticOnTap(.soft)
                    }
                }
                .padding(.horizontal, Spacing.lg)
            }
        }
    }

    private var coursesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionLabel(text: "Courses played")
            VStack(spacing: 1) {
                ForEach(detail?.courseNames ?? [], id: \.self) { name in
                    if let course = Course.find(byName: name) {
                        NavigationLink(value: course) {
                            CourseRow(name: name)
                        }
                        .buttonStyle(.plain)
                    } else {
                        CourseRow(name: name)
                    }
                }
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

    private var scheduleSection: some View {
        let groups = Dictionary(grouping: scheduleEvents, by: { $0.date })
        let days = groups.keys.sorted()
        return VStack(alignment: .leading, spacing: Spacing.md) {
            SectionLabel(text: "Schedule")
            VStack(spacing: 0) {
                ForEach(Array(days.enumerated()), id: \.offset) { dayIndex, day in
                    if dayIndex > 0 {
                        Divider().background(Color.appDivider)
                    }
                    DayBlock(
                        day: day,
                        events: (groups[day] ?? []).sorted { $0.sortableMinute < $1.sortableMinute },
                        isFirst: dayIndex == 0
                    )
                }
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

    @ViewBuilder
    private var lodgingSection: some View {
        if let detail, let address = detail.lodgingAddress {
            VStack(alignment: .leading, spacing: Spacing.md) {
                SectionLabel(text: "Lodging")
                lodgingCard(label: detail.lodgingLabel, address: address)
                    .padding(.horizontal, Spacing.lg)
            }
        }
    }

    @ViewBuilder
    private func lodgingCard(label: String?, address: String) -> some View {
        let card = HStack(alignment: .top, spacing: Spacing.md) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                if let label {
                    Text(label)
                        .font(AppFont.headline)
                        .foregroundStyle(Color.appInk)
                }
                Text(address)
                    .font(AppFont.footnote)
                    .foregroundStyle(Color.appMuted)
                    .multilineTextAlignment(.leading)
            }
            Spacer(minLength: 0)
            Image(systemName: "arrow.up.right.square")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.appMuted)
                .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Color.appDivider, lineWidth: 1)
        )

        if let url = MapsLink.url(for: address) {
            Link(destination: url) { card }
                .buttonStyle(.plain)
                .hapticOnTap(.soft)
                .accessibilityHint("Opens in Maps")
        } else {
            card
        }
    }
}

private struct SectionLabel: View {
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Text(text.uppercased())
                .font(AppFont.caption.weight(.semibold))
                .tracking(1.5)
                .foregroundStyle(Color.appMuted)
            Rectangle()
                .fill(Color.appDivider)
                .frame(height: 1)
        }
        .padding(.horizontal, Spacing.lg)
    }
}

private struct AttendeeAvatar: View {
    let member: Member

    var body: some View {
        VStack(spacing: Spacing.xs) {
            MemberAvatar(member: member, size: 56)
                .overlay(alignment: .topTrailing) {
                    badge
                        .alignmentGuide(.top) { d in d[.top] + 6 }
                        .alignmentGuide(.trailing) { d in d[.trailing] - 4 }
                }
                .padding(.top, 6)
                .padding(.trailing, 6)
            Text(member.nickname ?? member.fullName)
                .font(AppFont.caption)
                .foregroundStyle(Color.appInk)
        }
        .frame(width: 80)
    }

    @ViewBuilder
    private var badge: some View {
        if member.isOg {
            Text("OG")
                .font(AppFont.body(9, weight: .bold))
                .tracking(0.5)
                .foregroundStyle(.white)
                .padding(.horizontal, 5).padding(.vertical, 1.5)
                .background(Color.appAccent)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.appBackground, lineWidth: 2))
        } else if member.isGuest {
            Text("G")
                .font(AppFont.body(9, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 18, height: 18)
                .background(Color.appMuted)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.appBackground, lineWidth: 2))
        }
    }
}

private struct DayBlock: View {
    let day: Date
    let events: [TripEvent]
    let isFirst: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(dayHeaderText)
                .font(AppFont.body(11, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Color.appAccent)
                .padding(.horizontal, Spacing.md)
                .padding(.top, isFirst ? Spacing.md : Spacing.md + 2)
                .padding(.bottom, Spacing.xs)
            ForEach(events) { event in
                EventRow(event: event)
            }
        }
    }

    private var dayHeaderText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE · MMM d"
        return formatter.string(from: day).uppercased()
    }
}

private struct EventRow: View {
    let event: TripEvent

    private var linkedCourse: Course? {
        guard event.eventType == .golf else { return nil }
        return Course.find(byName: event.title)
    }

    private var externalUrl: URL? {
        guard let urlString = event.externalUrl else { return nil }
        return URL(string: urlString)
    }

    /// Subtitle to display under the title. For golf events with a known
    /// scorecard, this becomes "18 Holes · Par 71"; otherwise falls through
    /// to whatever was set on the event itself (e.g. "Dinner").
    private var resolvedSubtitle: String? {
        if let card = linkedCourse?.content?.scorecard {
            return "\(card.holes) Holes  ·  Par \(card.par)"
        }
        return event.subtitle
    }

    var body: some View {
        if let course = linkedCourse {
            NavigationLink(value: course) {
                rowContent(trailing: .chevron)
            }
            .buttonStyle(.plain)
        } else if let url = externalUrl {
            Link(destination: url) {
                rowContent(trailing: .external)
            }
            .buttonStyle(.plain)
        } else {
            rowContent(trailing: .none)
        }
    }

    private enum TrailingAffordance {
        case chevron, external, none
    }

    private func rowContent(trailing: TrailingAffordance) -> some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            Text(event.timeText ?? "—")
                .font(AppFont.numeric(13, weight: .semibold))
                .foregroundStyle(Color.appInk)
                .frame(width: 92, alignment: .trailing)

            Image(systemName: iconName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(iconColor)
                .frame(width: 16)
                .padding(.top, 4)

            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(AppFont.body(15, weight: .semibold))
                    .foregroundStyle(Color.appInk)
                if let subtitle = resolvedSubtitle {
                    Text(subtitle)
                        .font(AppFont.footnote)
                        .foregroundStyle(Color.appMuted)
                }
            }
            Spacer(minLength: 0)
            switch trailing {
            case .chevron:
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.appMuted.opacity(0.55))
                    .padding(.top, 4)
            case .external:
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.appMuted.opacity(0.55))
                    .padding(.top, 4)
            case .none:
                EmptyView()
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm + 2)
        .contentShape(Rectangle())
    }

    private var iconName: String {
        switch event.eventType {
        case .golf:      return "flag.fill"
        case .meal:      return "fork.knife"
        case .transport: return "airplane"
        case .other:     return "circle.fill"
        }
    }

    private var iconColor: Color {
        switch event.eventType {
        case .golf:      return Color.appAccent
        case .meal:      return Color.appMuted
        case .transport: return Color.appMuted
        case .other:     return Color.appMuted
        }
    }
}

private struct CourseRow: View {
    let name: String

    private var linkedCourse: Course? { Course.find(byName: name) }

    var body: some View {
        HStack(spacing: Spacing.md) {
            thumbnail
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(AppFont.bodyText.weight(.semibold))
                    .foregroundStyle(Color.appInk)
                    .lineLimit(2)
                if let course = linkedCourse, let location = course.locationDisplay {
                    Text(location)
                        .font(AppFont.caption)
                        .foregroundStyle(Color.appMuted)
                }
            }
            Spacer(minLength: 0)
            if linkedCourse != nil {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.appMuted.opacity(0.55))
                    .accessibilityHidden(true)
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.appSurface)
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let course = linkedCourse,
           let assetName = course.photoAssetName,
           UIImage(named: assetName) != nil {
            Image(assetName)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            Image(systemName: "flag.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.white)
                .frame(width: 44, height: 44)
                .background(Color.appAccent)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
