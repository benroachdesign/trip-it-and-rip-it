import SwiftUI

/// "Alternate stat line" easter egg. Reveals lighthearted, mostly-made-up
/// group totals you can't get from the regular Trip Detail view.
/// Triggered by tapping the year five times.
struct TripLoreView: View {
    let trip: Trip

    @Environment(\.dismiss) private var dismiss

    private var loreLines: [LoreLine] {
        [
            LoreLine(label: "Boxes of balls lost (est.)",
                     value: "∞"),
            LoreLine(label: "Casinos run in a single trip",
                     value: "5"),
            LoreLine(label: "SpongeBob popsicles consumed",
                     value: "∞"),
            LoreLine(label: "Birdies actually witnessed",
                     value: "Disputed"),
            LoreLine(label: "Times we said \u{201C}okay last hole\u{201D}",
                     value: "Per round"),
            LoreLine(label: "Bag liabilities reported",
                     value: "11 of 11"),
            LoreLine(label: "Group photos that made it home",
                     value: "1 (maybe)"),
            LoreLine(label: "Friendships forged",
                     value: "Enduring")
        ]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    masthead
                    statTable
                    footer
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.lg)
            }
            .background(Color.appBackground)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var masthead: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("ALTERNATE STAT LINE")
                .font(AppFont.caption.weight(.semibold))
                .tracking(2)
                .foregroundStyle(Color.appAccent)
            Text(String(trip.year))
                .font(AppFont.display(72, weight: .bold))
                .foregroundStyle(Color.appInk)
                .monospacedDigit()
            HStack(spacing: 10) {
                Rectangle()
                    .fill(Color.appMuted.opacity(0.45))
                    .frame(width: 24, height: 1)
                Text(trip.locationDisplay.uppercased())
                    .font(AppFont.caption.weight(.semibold))
                    .tracking(2)
                    .foregroundStyle(Color.appMuted)
            }
        }
    }

    private var statTable: some View {
        VStack(spacing: 0) {
            ForEach(Array(loreLines.enumerated()), id: \.element.label) { index, line in
                HStack(alignment: .firstTextBaseline) {
                    Text(line.label.uppercased())
                        .font(AppFont.caption.weight(.semibold))
                        .tracking(1.2)
                        .foregroundStyle(Color.appMuted)
                    Spacer()
                    Text(line.value)
                        .font(AppFont.body(15, weight: .semibold))
                        .foregroundStyle(Color.appInk)
                }
                .padding(.vertical, Spacing.md)
                if index < loreLines.count - 1 {
                    Rectangle()
                        .fill(Color.appDivider)
                        .frame(height: 1)
                }
            }
        }
        .padding(.horizontal, Spacing.lg)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Color.appDivider, lineWidth: 1)
        )
    }

    private var footer: some View {
        Text("Numbers may be inflated for narrative effect.")
            .font(AppFont.caption.italic())
            .foregroundStyle(Color.appMuted)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private struct LoreLine {
        let label: String
        let value: String
    }
}
