import SwiftUI
import UIKit

/// Render-only view used by ImageRenderer to produce a shareable image
/// card for a course. Designed for 1:1 export (iMessage / group chat).
struct CourseShareCard: View {
    let course: Course

    private let cardSize: CGFloat = 1200

    var body: some View {
        VStack(spacing: 0) {
            heroImage
                .frame(width: cardSize, height: cardSize * 0.55)
                .clipped()
            textSection
                .frame(width: cardSize, height: cardSize * 0.45)
        }
        .frame(width: cardSize, height: cardSize)
        .background(Color.appBackground)
    }

    @ViewBuilder
    private var heroImage: some View {
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

    private var placeholderHero: some View {
        LinearGradient(
            colors: [Color.appAccent, Color.appAccent.opacity(0.7)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }

    private var textSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 18) {
                Text(course.name)
                    .font(.system(size: 76, weight: .bold, design: .serif))
                    .foregroundStyle(Color.appInk)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                if let location = course.locationDisplay {
                    Text(location.uppercased())
                        .font(.system(size: 26, weight: .semibold))
                        .tracking(3)
                        .foregroundStyle(Color.appMuted)
                }
                HStack(spacing: 24) {
                    if let architect = course.architect {
                        sharePill(label: "ARCHITECT", value: architect)
                    }
                    if let year = course.yearBuilt {
                        sharePill(label: "OPENED", value: String(year))
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
