import SwiftUI

struct MemberBadge: View {
    let label: String
    let tint: Color

    var body: some View {
        Text(label)
            .font(AppFont.body(10, weight: .semibold))
            .tracking(0.6)
            .foregroundStyle(tint)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(tint.opacity(0.12))
            .clipShape(Capsule())
    }
}
