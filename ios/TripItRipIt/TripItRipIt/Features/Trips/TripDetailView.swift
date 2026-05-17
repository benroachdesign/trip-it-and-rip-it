import SwiftUI

struct TripDetailView: View {
    let trip: Trip

    private var attendees: [Member] {
        Trip.mockAttendees(for: trip.id)
    }

    private var detail: MockTripDetail? {
        Trip.mockDetail(for: trip.id)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                heroSection
                attendeesSection
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
                LinearGradient(
                    colors: [Color.appAccent, Color.appAccent.opacity(0.7)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .frame(height: 220)
                .overlay {
                    if let featured = detail?.featuredCourseName {
                        Text(featured)
                            .font(AppFont.display(28, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.55))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.lg)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(String(trip.year))
                        .font(AppFont.display(80, weight: .bold))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                        .shadow(color: .black.opacity(0.3), radius: 8, y: 2)
                    Text(trip.locationDisplay.uppercased())
                        .font(AppFont.caption.weight(.semibold))
                        .tracking(2)
                        .foregroundStyle(.white.opacity(0.9))
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

    private var attendeesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionLabel(text: "Who came")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.md) {
                    ForEach(attendees) { member in
                        AttendeeAvatar(member: member)
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
                    CourseRow(name: name)
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
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    if let label = detail.lodgingLabel {
                        Text(label)
                            .font(AppFont.headline)
                            .foregroundStyle(Color.appInk)
                    }
                    Text(address)
                        .font(AppFont.footnote)
                        .foregroundStyle(Color.appMuted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.lg)
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
}

private struct SectionLabel: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(AppFont.caption.weight(.semibold))
            .tracking(1.5)
            .foregroundStyle(Color.appMuted)
            .padding(.horizontal, Spacing.lg)
    }
}

private struct AttendeeAvatar: View {
    let member: Member

    var body: some View {
        VStack(spacing: Spacing.xs) {
            ZStack(alignment: .topTrailing) {
                Text(member.nickname?.prefix(1).uppercased() ?? "?")
                    .font(AppFont.display(22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.appAccent)
                    .clipShape(Circle())
                if member.isOg {
                    Text("OG")
                        .font(AppFont.body(9, weight: .bold))
                        .tracking(0.5)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5).padding(.vertical, 1.5)
                        .background(Color.appAccent)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.appBackground, lineWidth: 2))
                        .offset(x: 4, y: -4)
                } else if member.isGuest {
                    Text("G")
                        .font(AppFont.body(9, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 16, height: 16)
                        .background(Color.appMuted)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.appBackground, lineWidth: 2))
                        .offset(x: 4, y: -4)
                }
            }
            Text(member.nickname ?? member.fullName)
                .font(AppFont.caption)
                .foregroundStyle(Color.appInk)
        }
        .frame(width: 72)
    }
}

private struct CourseRow: View {
    let name: String

    var body: some View {
        HStack {
            Image(systemName: "flag.fill")
                .font(.system(size: 14))
                .foregroundStyle(Color.appAccent.opacity(0.7))
                .frame(width: 24)
            Text(name)
                .font(AppFont.bodyText)
                .foregroundStyle(Color.appInk)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.appMuted.opacity(0.5))
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.md)
        .background(Color.appSurface)
    }
}
