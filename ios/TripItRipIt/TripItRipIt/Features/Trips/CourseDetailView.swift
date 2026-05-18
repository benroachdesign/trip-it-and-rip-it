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
        .frame(height: 220)
        .clipped()
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
                Text(location.uppercased())
                    .font(AppFont.caption.weight(.semibold))
                    .tracking(1.5)
                    .foregroundStyle(Color.appMuted)
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

    private var signatureHolesSection: some View {
        sectionPlaceholder(title: "Signature holes", body: "Photo and notes for 1-3 signature holes will live here.")
    }

    private var scorecardSection: some View {
        sectionPlaceholder(title: "Scorecard", body: "Par, yardages by tee box.")
    }

    private var thingsToKnowSection: some View {
        sectionPlaceholder(title: "Things to know", body: "Caddie norms, terrain, prevailing wind, walking notes.")
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

    private func sectionPlaceholder(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionLabel(text: title)
            Text(body)
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
