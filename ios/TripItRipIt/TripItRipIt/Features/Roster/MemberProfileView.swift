import SwiftUI

struct MemberProfileView: View {
    let member: Member

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                hero
                statsRow
                bioSection
                tripsSection
            }
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.appBackground)
        .navigationTitle(member.fullName)
        .navigationBarTitleDisplayMode(.inline)
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
        VStack(alignment: .leading, spacing: Spacing.md) {
            sectionLabel("Bio")
            if let bio = member.bio, !bio.isEmpty {
                Text(bio)
                    .font(AppFont.body(15))
                    .foregroundStyle(Color.appInk)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.lg)
                    .background(Color.appSurface)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.lg)
                            .stroke(Color.appDivider, lineWidth: 1)
                    )
                    .padding(.horizontal, Spacing.lg)
            } else {
                Text("Bio coming soon.")
                    .font(AppFont.footnote)
                    .foregroundStyle(Color.appMuted)
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

    @ViewBuilder
    private var tripsSection: some View {
        let years = member.attendedTripYears
        if !years.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.md) {
                sectionLabel("Trips attended")
                HStack(spacing: Spacing.sm) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year))
                            .font(AppFont.numeric(15, weight: .semibold))
                            .foregroundStyle(Color.appAccent)
                            .padding(.horizontal, Spacing.md)
                            .padding(.vertical, Spacing.xs)
                            .background(Color.appAccent.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, Spacing.lg)
            }
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
