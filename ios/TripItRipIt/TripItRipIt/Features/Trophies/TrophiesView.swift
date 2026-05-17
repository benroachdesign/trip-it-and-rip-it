import SwiftUI

struct TrophiesView: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Text("Trophy Room")
                .font(AppFont.largeTitle)
                .foregroundStyle(Color.appInk)
            Text("Team and individual awards by year")
                .font(AppFont.bodyText)
                .foregroundStyle(Color.appMuted)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.lg)
        .background(Color.appBackground)
        .navigationTitle("Trophies")
        .navigationBarTitleDisplayMode(.inline)
    }
}
