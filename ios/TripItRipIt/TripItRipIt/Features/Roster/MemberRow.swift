import SwiftUI

struct MemberRow: View {
    let member: Member

    private var metadataPieces: [String] {
        var pieces: [String] = []
        if let city = member.homeCity { pieces.append(city) }
        if let hcp = member.handicapDisplay { pieces.append(hcp) }
        let trips = member.tripsAttendedCount
        if trips > 0 { pieces.append("\(trips) trip\(trips == 1 ? "" : "s")") }
        return pieces
    }

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            Text(member.nickname ?? String(member.fullName.prefix(1)))
                .font(AppFont.display(20, weight: .semibold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 44, height: 44)
                .background(Color.appSurface)
                .clipShape(Circle())
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: Spacing.sm) {
                    Text(member.fullName)
                        .font(AppFont.headline)
                        .foregroundStyle(Color.appInk)
                    if member.isOg {
                        MemberBadge(label: "OG", tint: .appAccent)
                    }
                    if member.isGuest {
                        MemberBadge(label: "GUEST", tint: .appMuted)
                    }
                }
                if !metadataPieces.isEmpty {
                    Text(metadataPieces.joined(separator: " · "))
                        .font(AppFont.footnote)
                        .foregroundStyle(Color.appMuted)
                }
                if let funFact = member.funFact, !funFact.isEmpty {
                    Text("\u{201C}\(funFact)\u{201D}")
                        .font(AppFont.body(13, weight: .regular).italic())
                        .foregroundStyle(Color.appMuted)
                        .padding(.top, 2)
                }
            }
        }
        .padding(.vertical, Spacing.xs)
        .contentShape(Rectangle())
    }
}
