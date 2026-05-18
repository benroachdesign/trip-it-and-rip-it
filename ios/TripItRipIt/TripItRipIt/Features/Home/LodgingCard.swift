import SwiftUI

struct LodgingCard: View {
    let member: Member

    private var assignment: LodgingAssignment? {
        LodgingAssignment.bandon2026(for: member.nickname)
    }

    var body: some View {
        guard let assignment else { return AnyView(EmptyView()) }
        return AnyView(
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("YOUR ROOM")
                    .font(AppFont.body(11, weight: .semibold))
                    .tracking(2)
                    .foregroundStyle(Color.homeMuted)
                Text(assignment.roomName)
                    .font(AppFont.display(28, weight: .bold))
                    .foregroundStyle(Color.homeInk)
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.homeMuted)
                    Text("Sharing with \(assignment.roommate.uppercased())")
                        .font(AppFont.body(13, weight: .semibold))
                        .tracking(0.4)
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
        )
    }
}

struct LodgingAssignment {
    let roomName: String
    let roommate: String

    static func bandon2026(for nickname: String?) -> LodgingAssignment? {
        guard let nick = nickname else { return nil }
        switch nick {
        case "Roach":  return LodgingAssignment(roomName: "Lily Pond 1", roommate: "Bliz")
        case "Bliz":   return LodgingAssignment(roomName: "Lily Pond 1", roommate: "Roach")
        case "Mader":  return LodgingAssignment(roomName: "Lily Pond 2", roommate: "Webb")
        case "Webb":   return LodgingAssignment(roomName: "Lily Pond 2", roommate: "Mader")
        case "Braden": return LodgingAssignment(roomName: "Lily Pond 3", roommate: "Tommer")
        case "Tommer": return LodgingAssignment(roomName: "Lily Pond 3", roommate: "Braden")
        case "Strub":  return LodgingAssignment(roomName: "Lily Pond 4", roommate: "Kyle")
        case "Kyle":   return LodgingAssignment(roomName: "Lily Pond 4", roommate: "Strub")
        default:       return nil
        }
    }
}
