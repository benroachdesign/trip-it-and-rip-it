import SwiftUI

struct TripsView: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Text("Trips")
                .font(AppFont.largeTitle)
                .foregroundStyle(Color.appInk)
            Text("Year-by-year archive lives here")
                .font(AppFont.bodyText)
                .foregroundStyle(Color.appMuted)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.lg)
        .background(Color.appBackground)
        .navigationTitle("Trips")
        .navigationBarTitleDisplayMode(.inline)
    }
}
