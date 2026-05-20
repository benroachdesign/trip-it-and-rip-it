import SwiftUI
import UIKit

struct CourseDetailView: View {
    let course: Course

    private var yearsPlayed: [Int] {
        Trip.mockDetails
            .filter { $0.courseNames.contains(course.name) }
            .map { $0.trip.year }
            .sorted()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                heroSection
                metaSection
                signatureHolesSection
                scorecardSection
                thingsToKnowSection
                playedInSection
            }
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.appBackground)
        .navigationTitle(course.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                shareButton
            }
        }
    }

    @ViewBuilder
    private var shareButton: some View {
        if let image = renderedShareImage() {
            ShareLink(
                item: image,
                preview: SharePreview(course.name, image: image)
            ) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 14, weight: .semibold))
            }
            .accessibilityLabel("Share course")
            .hapticOnTap(.soft)
        }
    }

    @MainActor
    private func renderedShareImage() -> Image? {
        let renderer = ImageRenderer(content: CourseShareCard(course: course))
        renderer.scale = 2.0
        guard let ui = renderer.uiImage else { return nil }
        return Image(uiImage: ui)
    }

    private var heroSection: some View {
        ZStack {
            if let assetName = course.photoAssetName, UIImage(named: assetName) != nil {
                Image(assetName)
                    .resizable()
                    .scaledToFill()
            } else if let urlString = course.heroPhotoUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
                        placeholderHero
                    }
                }
            } else {
                placeholderHero
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .clipped()
        .filmGrain()
    }

    private var placeholderHero: some View {
        ZStack {
            LinearGradient(
                colors: [Color.appAccent, Color.appAccent.opacity(0.7)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Image(systemName: "flag.fill")
                .font(.system(size: 80))
                .foregroundStyle(.white.opacity(0.18))
        }
    }

    private var metaSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(course.name)
                .font(AppFont.title)
                .foregroundStyle(Color.appInk)
            if let location = course.locationDisplay {
                locationLink(location: location)
            }
            HStack(spacing: Spacing.lg) {
                if let architect = course.architect {
                    metaPill(label: "Architect", value: architect)
                }
                if let year = course.yearBuilt {
                    metaPill(label: "Opened", value: String(year))
                }
            }
            .padding(.top, Spacing.xs)
        }
        .padding(.horizontal, Spacing.lg)
    }

    @ViewBuilder
    private func locationLink(location: String) -> some View {
        let label = HStack(spacing: 6) {
            Text(location.uppercased())
                .font(AppFont.caption.weight(.semibold))
                .tracking(1.5)
            Image(systemName: "arrow.up.right")
                .font(.system(size: 9, weight: .semibold))
                .accessibilityHidden(true)
        }
        .foregroundStyle(Color.appMuted)

        let query = "\(course.name) \(location)"
        if let url = MapsLink.url(for: query) {
            Link(destination: url) { label }
                .buttonStyle(.plain)
                .hapticOnTap(.soft)
                .accessibilityHint("Opens in Maps")
        } else {
            label
        }
    }

    private func metaPill(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(AppFont.body(10, weight: .semibold))
                .tracking(1.2)
                .foregroundStyle(Color.appMuted)
            Text(value)
                .font(AppFont.body(14, weight: .semibold))
                .foregroundStyle(Color.appInk)
        }
    }

    @ViewBuilder
    private var signatureHolesSection: some View {
        if let holes = course.content?.signatureHoles, !holes.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.md) {
                SectionLabel(text: "Signature holes")
                VStack(spacing: 1) {
                    ForEach(holes) { hole in
                        SignatureHoleRow(hole: hole)
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
    }

    @ViewBuilder
    private var scorecardSection: some View {
        if let card = course.content?.scorecard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                SectionLabel(text: "Scorecard")
                HStack(spacing: 0) {
                    scorecardStat(label: "Par", value: String(card.par))
                    Divider().frame(height: 40).background(Color.appDivider)
                    scorecardStat(label: "Yardage", value: formattedYardage(card.totalYardage))
                    Divider().frame(height: 40).background(Color.appDivider)
                    scorecardStat(label: "Tees", value: card.tee)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
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
    private var thingsToKnowSection: some View {
        if let bullets = course.content?.thingsToKnow, !bullets.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.md) {
                SectionLabel(text: "Things to know")
                VStack(alignment: .leading, spacing: Spacing.md) {
                    ForEach(Array(bullets.enumerated()), id: \.offset) { _, bullet in
                        HStack(alignment: .top, spacing: Spacing.md) {
                            Circle()
                                .fill(Color.appAccent)
                                .frame(width: 5, height: 5)
                                .padding(.top, 9)
                            Text(bullet)
                                .font(AppFont.body(15))
                                .foregroundStyle(Color.appInk)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
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

    private func scorecardStat(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(AppFont.numeric(20, weight: .semibold))
                .foregroundStyle(Color.appInk)
            Text(label.uppercased())
                .font(AppFont.body(10, weight: .semibold))
                .tracking(1.2)
                .foregroundStyle(Color.appMuted)
        }
        .frame(maxWidth: .infinity)
    }

    private func formattedYardage(_ y: Int) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: y)) ?? String(y)
    }

    @ViewBuilder
    private var playedInSection: some View {
        if !yearsPlayed.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.md) {
                SectionLabel(text: "Played in")
                HStack(spacing: Spacing.sm) {
                    ForEach(yearsPlayed, id: \.self) { year in
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

}

private struct SignatureHoleRow: View {
    let hole: SignatureHole

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            VStack(spacing: 2) {
                Text("HOLE")
                    .font(AppFont.body(9, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(Color.appMuted)
                Text("\(hole.number)")
                    .font(AppFont.display(28, weight: .bold))
                    .foregroundStyle(Color.appAccent)
                    .monospacedDigit()
            }
            .frame(width: 56)
            VStack(alignment: .leading, spacing: 4) {
                if let title = hole.title {
                    Text(title)
                        .font(AppFont.body(15, weight: .semibold))
                        .foregroundStyle(Color.appInk)
                }
                Text(hole.note)
                    .font(AppFont.footnote)
                    .foregroundStyle(Color.appInk)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.md)
        .background(Color.appSurface)
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
