import SwiftUI
import UIKit

struct MemberAvatar: View {
    let member: Member
    var size: CGFloat = 44

    private var assetName: String? { member.nickname }

    private var hasImage: Bool {
        guard let name = assetName else { return false }
        return UIImage(named: name) != nil
    }

    var body: some View {
        Group {
            if let name = assetName, hasImage {
                Image(name)
                    .resizable()
                    .scaledToFill()
            } else {
                Text(initial)
                    .font(.system(size: size * 0.42, weight: .semibold, design: .serif))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: size, height: size)
        .background(Color.appAccent)
        .clipShape(Circle())
        .overlay(
            Circle().stroke(Color.appDivider, lineWidth: hasImage ? 0 : 0.5)
        )
    }

    private var initial: String {
        let source = member.nickname ?? member.fullName
        return String(source.prefix(1)).uppercased()
    }
}
