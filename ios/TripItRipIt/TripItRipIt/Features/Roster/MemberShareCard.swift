import SwiftUI
import UIKit

/// Render-only view used by ImageRenderer to produce a shareable image
/// card for a member. Designed for 1:1 export (iMessage / group chat).
struct MemberShareCard: View {
    let member: Member

    private let cardSize: CGFloat = 1200

    var body: some View {
        VStack(spacing: 0) {
            heroBlock
            textSection
        }
        .frame(width: cardSize, height: cardSize)
        .background(Color.appBackground)
    }

    private var heroBlock: some View {
        ZStack {
            LinearGradient(
                colors: [Color.appAccent, Color.appAccent.opacity(0.78)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            avatarLayer
        }
        .frame(width: cardSize, height: cardSize * 0.55)
    }

    @ViewBuilder
    private var avatarLayer: some View {
        let size: CGFloat = 360
        if let name = member.nickname, UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.55), lineWidth: 6))
                .shadow(color: .black.opacity(0.3), radius: 24, y: 8)
        } else {
            Text(String((member.nickname ?? member.fullName).prefix(1)).uppercased())
                .font(.system(size: 160, weight: .bold, design: .serif))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .background(Circle().fill(Color.appInk.opacity(0.45)))
                .overlay(Circle().stroke(Color.white.opacity(0.55), lineWidth: 6))
                .shadow(color: .black.opacity(0.3), radius: 24, y: 8)
        }
    }

    private var textSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .firstTextBaseline, spacing: 18) {
                    Text(member.fullName)
                        .font(.system(size: 72, weight: .bold, design: .serif))
                        .foregroundStyle(Color.appInk)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    if let nick = member.nickname, nick != member.fullName {
                        Text("\u{201C}\(nick)\u{201D}")
                            .font(.system(size: 38, weight: .semibold, design: .serif).italic())
                            .foregroundStyle(Color.appMuted)
                            .lineLimit(1)
                    }
                }
                if let city = member.homeCity {
                    Text(city.uppercased())
                        .font(.system(size: 24, weight: .semibold))
                        .tracking(3)
                        .foregroundStyle(Color.appMuted)
                }
                HStack(spacing: 36) {
                    if let hcp = member.handicapDisplay {
                        sharePill(
                            label: "HANDICAP",
                            value: hcp.replacingOccurrences(of: "HCP ", with: "")
                        )
                    }
                    sharePill(
                        label: "TRIPS",
                        value: String(member.tripsAttendedCount)
                    )
                    if member.isOg {
                        sharePill(label: "STATUS", value: "Founding")
                    } else if member.isGuest {
                        sharePill(label: "STATUS", value: "Guest")
                    }
                }
            }
            Spacer()
            HStack {
                Text("TRIP IT & RIP IT")
                    .font(.system(size: 22, weight: .semibold, design: .serif))
                    .tracking(6)
                    .foregroundStyle(Color.appAccent)
                Spacer()
            }
        }
        .padding(.horizontal, 72)
        .padding(.vertical, 64)
        .frame(width: cardSize, height: cardSize * 0.45, alignment: .topLeading)
    }

    private func sharePill(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Color.appMuted)
            Text(value)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.appInk)
        }
    }
}
