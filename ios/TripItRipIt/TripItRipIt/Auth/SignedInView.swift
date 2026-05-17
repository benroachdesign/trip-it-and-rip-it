import Supabase
import SwiftUI

struct SignedInView: View {
    @Environment(AuthViewModel.self) private var auth
    @State private var members: [Member] = []
    @State private var loadError: String?

    var body: some View {
        NavigationStack {
            List {
                Section("Members") {
                    if let loadError {
                        Text(loadError).foregroundStyle(.red)
                    } else if members.isEmpty {
                        Text("Loading…").foregroundStyle(.secondary)
                    } else {
                        ForEach(members) { member in
                            HStack {
                                Text(member.fullName)
                                Spacer()
                                if let nickname = member.nickname {
                                    Text(nickname).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Trip it & Rip it!")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sign out") {
                        Task { await auth.signOut() }
                    }
                }
            }
            .task {
                await load()
            }
        }
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
