import SwiftUI

struct ContentView: View {
    @State private var users: [User] = User.mockUsers
    @State private var searchText = ""
    @State private var showingAddUserSheet = false

    @State private var newName = ""
    @State private var newUsername = ""
    @State private var newEmail = ""

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            let query = searchText.lowercased()
            return users.filter {
                $0.name.lowercased().contains(query) || $0.username.lowercased().contains(query)
            }
        }
    }

    var body: some View {
        TabView {
            // Tab 1: Users
            NavigationStack {
                List {
                    ForEach(filteredUsers) { user in
                        NavigationLink {
                            UserDetailView(user: user)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.headline)
                                HStack {
                                    Text("@\(user.username)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Text("\(user.tasks.count) tasks")
                                        .font(.caption)
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteUser)
                }
                .navigationTitle("Users")
                .searchable(text: $searchText, prompt: "Search users...")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddUserSheet = true
                        } label: {
                            Image(systemName: "person.badge.plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddUserSheet) {
                    NavigationStack {
                        Form {
                            Section("User Info") {
                                TextField("Full Name", text: $newName)
                                TextField("Username", text: $newUsername)
                                TextField("Email Address", text: $newEmail)
                                    .keyboardType(.emailAddress)
                            }
                        }
                        .navigationTitle("Add New User")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    showingAddUserSheet = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Save") {
                                    addUser()
                                    showingAddUserSheet = false
                                }
                                .disabled(newName.isEmpty || newUsername.isEmpty)
                            }
                        }
                    }
                }
            }
            .tabItem {
                Label("Users", systemImage: "person.3.fill")
            }

            // Tab 2: All Tasks
            AllTasksView(users: users)
                .tabItem {
                    Label("All Tasks", systemImage: "checklist")
                }
        }
    }

    private func addUser() {
        let newID = (users.map { $0.id }.max() ?? 0) + 1
        let newUser = User(id: newID, name: newName, username: newUsername, email: newEmail, tasks: [])
        users.append(newUser)
        newName = ""
        newUsername = ""
        newEmail = ""
    }

    private func deleteUser(at offsets: IndexSet) {
        users.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
