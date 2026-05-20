import SwiftUI
import UIKit

/// Compact, tappable row for Home schedule/preview cards. Mirrors the
/// linking behavior of TripDetailView.EventRow but with a smaller visual
/// treatment suited to Home's dense layout.
struct HomeEventRow: View {
    let event: TripEvent

    private var linkedCourse: Course? {
        guard event.eventType == .golf else { return nil }
        return Course.find(byName: event.title)
    }

    private var externalUrl: URL? {
        guard let urlString = event.externalUrl else { return nil }
        return URL(string: urlString)
    }

    var body: some View {
        if let course = linkedCourse {
            NavigationLink(value: course) {
                content(trailing: .chevron)
            }
            .buttonStyle(.plain)
            .hapticOnTap(.soft)
        } else if let url = externalUrl {
            Link(destination: url) {
                content(trailing: .external)
            }
            .buttonStyle(.plain)
            .hapticOnTap(.soft)
        } else {
            content(trailing: .none)
        }
    }

    private enum Trailing { case chevron, external, none }

    private func content(trailing: Trailing) -> some View {
        HStack(alignment: .center, spacing: Spacing.md) {
            Text(event.timeText ?? "—")
                .font(AppFont.numeric(12, weight: .semibold))
                .foregroundStyle(Color.homeMuted)
                .frame(width: 92, alignment: .trailing)
            thumbnail
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(AppFont.body(15, weight: .semibold))
                    .foregroundStyle(Color.homeInk)
                    .lineLimit(2)
                if let subtitle = event.subtitle {
                    Text(subtitle)
                        .font(AppFont.caption)
                        .foregroundStyle(Color.homeMuted)
                }
            }
            Spacer(minLength: 0)
            trailingView(trailing)
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.homeSurface)
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let course = linkedCourse,
           let assetName = course.photoAssetName,
           UIImage(named: assetName) != nil {
            Image(assetName)
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        } else {
            Image(systemName: iconName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(iconForeground)
                .frame(width: 36, height: 36)
                .background(iconBackground)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }

    @ViewBuilder
    private func trailingView(_ trailing: Trailing) -> some View {
        switch trailing {
        case .chevron:
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.homeMuted.opacity(0.6))
                .accessibilityHidden(true)
        case .external:
            Image(systemName: "arrow.up.right.square")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.homeMuted.opacity(0.6))
                .accessibilityHidden(true)
        case .none:
            EmptyView()
        }
    }

    private var iconName: String {
        switch event.eventType {
        case .golf: return "flag.fill"
        case .meal: return "fork.knife"
        case .transport: return "airplane"
        case .other: return "circle.fill"
        }
    }

    private var iconForeground: Color {
        switch event.eventType {
        case .golf: return Color.homeBackground
        default: return Color.homeAccent
        }
    }

    private var iconBackground: Color {
        switch event.eventType {
        case .golf: return Color.homeAccent
        default: return Color.white.opacity(0.08)
        }
    }
}
