import SwiftUI

/// Long-press preview for a member's walk-up song. Surfaces a hidden
/// detail from the trading card data without cluttering the main UI.
struct WalkUpSongPreview: View {
    let member: Member
    let song: String

    private var title: String? { components.first.map(String.init) }
    private var artist: String? {
        guard components.count > 1 else { return nil }
        return String(components[1])
    }

    private var components: [Substring] {
        song.split(separator: " — ", maxSplits: 1)
    }

    var body: some View {
        VStack(spacing: Spacing.lg) {
            MemberAvatar(member: member, size: 96)

            VStack(spacing: Spacing.xs) {
                Text("WALK-UP SONG")
                    .font(AppFont.caption.weight(.semibold))
                    .tracking(2)
                    .foregroundStyle(Color.appMuted)
                if let title {
                    Text(title)
                        .font(AppFont.title)
                        .foregroundStyle(Color.appInk)
                        .multilineTextAlignment(.center)
                }
                if let artist {
                    Text(artist.uppercased())
                        .font(AppFont.caption.weight(.semibold))
                        .tracking(1.5)
                        .foregroundStyle(Color.appMuted)
                } else if title == nil {
                    Text(song)
                        .font(AppFont.headline)
                        .foregroundStyle(Color.appInk)
                        .multilineTextAlignment(.center)
                }
            }

            Image(systemName: "music.note")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.appAccent)
        }
        .padding(Spacing.xl)
        .frame(width: 280)
        .background(Color.appSurface)
    }
}

enum AppleMusicLink {
    /// Best-effort search URL for the user's preferred Apple Music storefront.
    static func search(for query: String) -> URL? {
        var components = URLComponents(string: "https://music.apple.com/us/search")
        components?.queryItems = [URLQueryItem(name: "term", value: query)]
        return components?.url
    }
}
