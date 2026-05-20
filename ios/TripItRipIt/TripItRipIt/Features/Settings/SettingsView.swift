import Auth
import SwiftUI

struct SettingsView: View {
    @Environment(AuthViewModel.self) private var auth
    @Environment(\.dismiss) private var dismiss

    @AppStorage("timeTravel.anchorVirtual") private var ttAnchor: Double = 0
    @State private var customDate: Date = Date()
    @State private var showCustomPicker = false

    private let privacyURL = URL(string: "https://benroachdesign.github.io/trip-it-and-rip-it-privacy/")!

    private var versionString: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "—"
        let build = info?["CFBundleVersion"] as? String ?? "—"
        return "Version \(version) (\(build))"
    }

    private var signedInEmail: String? {
        if case .signedIn(let user) = auth.state {
            return user.email
        }
        return nil
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    EmptyView()
                } header: {
                    settingsMasthead
                        .textCase(nil)
                        .padding(.horizontal, -16)
                        .padding(.top, 0)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                #if DEBUG
                timeTravelSection
                #endif

                Section {
                    Link(destination: privacyURL) {
                        HStack {
                            Label("Privacy policy", systemImage: "hand.raised")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundStyle(Color.appMuted)
                                .accessibilityHidden(true)
                        }
                    }
                } header: {
                    Text("About")
                } footer: {
                    creditsFooter
                }

                Section {
                    LabeledContent("App version", value: versionString)
                }

                Section {
                    if let email = signedInEmail {
                        LabeledContent("Signed in as", value: email)
                    }
                    Button(role: .destructive) {
                        Haptics.tap(.medium)
                        Task {
                            await auth.signOut()
                            dismiss()
                        }
                    } label: {
                        Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                } header: {
                    Text("Account")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var settingsMasthead: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("T&R")
                .font(AppFont.display(56, weight: .bold))
                .foregroundStyle(Color.appAccent)
            HStack(spacing: 10) {
                Rectangle()
                    .fill(Color.appMuted.opacity(0.45))
                    .frame(width: 24, height: 1)
                Text("SETTINGS")
                    .font(AppFont.caption.weight(.semibold))
                    .tracking(2)
                    .foregroundStyle(Color.appMuted)
            }
        }
        .padding(.bottom, Spacing.md)
        .padding(.top, Spacing.sm)
    }

    private var virtualNowDisplay: String {
        let f = DateFormatter()
        f.dateFormat = "EEE MMM d · h:mm a"
        return f.string(from: TimeTravel.now)
    }

    @ViewBuilder
    private var timeTravelSection: some View {
        Section {
            HStack {
                Image(systemName: TimeTravel.isActive ? "clock.fill" : "clock")
                    .foregroundStyle(TimeTravel.isActive ? Color.appAccent : Color.appMuted)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(TimeTravel.isActive ? "Pretending it's" : "Real time")
                        .font(.caption)
                        .foregroundStyle(Color.appMuted)
                    Text(virtualNowDisplay)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color.appInk)
                }
            }

            ForEach(TimeTravelPreset.bandon2026) { preset in
                Button {
                    Haptics.tap(.soft)
                    TimeTravel.setOverride(to: preset.date)
                    ttAnchor = preset.date.timeIntervalSince1970
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(preset.label)
                            .foregroundStyle(Color.appInk)
                        Text(preset.detail)
                            .font(.caption)
                            .foregroundStyle(Color.appMuted)
                    }
                }
            }

            DisclosureGroup("Custom date & time", isExpanded: $showCustomPicker) {
                DatePicker(
                    "Pick a moment",
                    selection: $customDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                Button("Use this time") {
                    Haptics.tap(.soft)
                    TimeTravel.setOverride(to: customDate)
                    ttAnchor = customDate.timeIntervalSince1970
                }
            }

            if TimeTravel.isActive {
                Button(role: .destructive) {
                    Haptics.tap(.medium)
                    TimeTravel.clearOverride()
                    ttAnchor = 0
                } label: {
                    Label("Reset to real time", systemImage: "arrow.counterclockwise")
                }
            }
        } header: {
            Text("Time travel (debug)")
        } footer: {
            Text("Pretend it's another moment to preview during-trip UI. Time still ticks forward from the chosen anchor.")
        }
    }

    private var creditsFooter: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Trip it & Rip it!")
                .font(AppFont.body(13, weight: .semibold))
                .foregroundStyle(Color.appInk)
            Text("Built for the boys.")
                .font(AppFont.caption)
                .foregroundStyle(Color.appMuted)
        }
        .padding(.top, Spacing.sm)
    }
}
