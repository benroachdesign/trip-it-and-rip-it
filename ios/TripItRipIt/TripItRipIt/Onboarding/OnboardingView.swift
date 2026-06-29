import SwiftUI

/// First-launch welcome flow. Shown once, then never again
/// (UserDefaults key: "hasSeenOnboarding").
struct OnboardingView: View {
    @Binding var done: Bool
    @State private var page: Int = 0

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $page) {
                    welcomePage.tag(0)
                    tripPage.tag(1)
                    finalPage.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                pageIndicator
                    .padding(.bottom, Spacing.md)

                primaryButton
                    .padding(.horizontal, Spacing.xl)
                    .padding(.bottom, Spacing.xxl)
            }
        }
    }

    private var welcomePage: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            Text("T&R")
                .font(AppFont.display(96, weight: .bold))
                .foregroundStyle(Color.appAccent)
            Rectangle()
                .fill(Color.appDivider)
                .frame(width: 48, height: 1)
            VStack(spacing: 6) {
                Text("Trip it & Rip it!")
                    .font(AppFont.title)
                    .foregroundStyle(Color.appInk)
                Text("A private app for the boys.")
                    .font(AppFont.footnote)
                    .foregroundStyle(Color.appMuted)
            }
            Spacer()
            Spacer()
        }
        .padding(.horizontal, Spacing.xl)
    }

    private var tripPage: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("NEXT UP")
                    .font(AppFont.caption.weight(.semibold))
                    .tracking(2)
                    .foregroundStyle(Color.appMuted)
                Text("Bandon Dunes")
                    .font(AppFont.display(42, weight: .bold))
                    .foregroundStyle(Color.appInk)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 10) {
                    Rectangle()
                        .fill(Color.appMuted.opacity(0.45))
                        .frame(width: 24, height: 1)
                    Text("OREGON · JUL 23–27, 2026")
                        .font(AppFont.caption.weight(.semibold))
                        .tracking(2)
                        .foregroundStyle(Color.appMuted)
                }
                Text("Six years in, eight of us this time. Pacific Dunes, Bandon Dunes, Old Macdonald, Sheep Ranch, Bandon Trails, Bandon Preserve, Shorty's.")
                    .font(AppFont.bodyText)
                    .foregroundStyle(Color.appInk)
                    .padding(.top, Spacing.md)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Spacer()
        }
        .padding(.horizontal, Spacing.xl)
    }

    private var finalPage: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("WHAT YOU'LL FIND")
                    .font(AppFont.caption.weight(.semibold))
                    .tracking(2)
                    .foregroundStyle(Color.appMuted)
                tabIntro(icon: "house.lodge.fill",
                         title: "Home",
                         body: "The right-now view: countdown, today's schedule, your room.")
                tabIntro(icon: "calendar",
                         title: "Trips",
                         body: "Six years of history. Tap into any year for the full breakdown.")
                tabIntro(icon: "person.2.fill",
                         title: "Roster",
                         body: "Profiles for every member. Long-press an avatar for their walk-up song.")
                tabIntro(icon: "trophy.fill",
                         title: "Trophies",
                         body: "Champions and honors, year by year. Course of the Year, Most Lost Balls, et al.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding(.horizontal, Spacing.xl)
    }

    private func tabIntro(icon: String, title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 32, height: 32)
                .background(Color.appAccent.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFont.headline)
                    .foregroundStyle(Color.appInk)
                Text(body)
                    .font(AppFont.footnote)
                    .foregroundStyle(Color.appMuted)
            }
        }
    }

    private var pageIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(i == page ? Color.appAccent : Color.appMuted.opacity(0.35))
                    .frame(width: 6, height: 6)
            }
        }
    }

    private var primaryButton: some View {
        Button {
            Haptics.tap(.soft)
            if page < 2 {
                withAnimation(AppMotion.snappy) { page += 1 }
            } else {
                Haptics.success()
                done = true
            }
        } label: {
            Text(page < 2 ? "Continue" : "Let's go")
                .font(AppFont.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.appAccent)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(page < 2 ? "Continue" : "Finish onboarding")
    }
}
