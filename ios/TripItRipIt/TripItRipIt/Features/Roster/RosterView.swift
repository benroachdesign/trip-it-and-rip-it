import Supabase
import SwiftUI

struct RosterView: View {
    @State private var members: [Member] = []
    @State private var loadError: String?

    var body: some View {
        Group {
            if let loadError {
                ContentUnavailableView(
                    "Couldn't load roster",
                    systemImage: "person.2.slash",
                    description: Text(loadError)
                )
            } else if members.isEmpty {
                ProgressView().controlSize(.large)
            } else {
                List(members) { member in
                    HStack(spacing: Spacing.md) {
                        Text(member.nickname ?? String(member.fullName.prefix(1)))
                            .font(AppFont.display(20, weight: .semibold))
                            .foregroundStyle(Color.appAccent)
                            .frame(width: 44, height: 44)
                            .background(Color.appSurface)
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 2) {
                            Text(member.fullName)
                                .font(AppFont.headline)
                                .foregroundStyle(Color.appInk)
                            if let nickname = member.nickname {
                                Text(nickname)
                                    .font(AppFont.footnote)
                                    .foregroundStyle(Color.appMuted)
                            }
                        }
                    }
                    .padding(.vertical, Spacing.xs)
                }
                .listStyle(.plain)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Roster")
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    private func load() async {
        do {
            members = try await SupabaseService.client
                .from("members")
                .select("id, full_name, nickname, sort_order")
                .order("sort_order")
                .execute()
                .value
        } catch {
            loadError = error.localizedDescription
        }
    }
}

struct Member: Identifiable, Decodable {
    let id: UUID
    let fullName: String
    let nickname: String?
    let sortOrder: Int

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case nickname
        case sortOrder = "sort_order"
    }
}
