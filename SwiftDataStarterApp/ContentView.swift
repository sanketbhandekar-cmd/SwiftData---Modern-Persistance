import SwiftUI
import SwiftData

struct ContentView: View {
    // Task 4: SwiftData ModelContext and @Query for dynamic data operations
    @Environment(\.modelContext) private var modelContext
    @Query private var allUsers: [User]

    @State private var searchText = ""
    @State private var showingAddUserSheet = false

    @State private var newName = ""
    @State private var newUsername = ""
    @State private var newEmail = ""

    var body: some View {
        TabView {
            // Tab 1: Users
            NavigationStack {
                // Task 4: Dynamic Querying & Predicate Filtering via Subview
                UserListView(searchText: searchText)
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
            AllTasksView()
                .tabItem {
                    Label("All Tasks", systemImage: "checklist")
                }
        }
        .onAppear {
            seedInitialDataIfNeeded()
        }
    }

    // Task 4: Seed initial data to database if empty
    private func seedInitialDataIfNeeded() {
        if allUsers.isEmpty {
            for mockUser in User.mockUsers {
                modelContext.insert(mockUser)
            }
        }
    }

    // Task 4: Create operation using ModelContext
    private func addUser() {
        let newID = (allUsers.map { $0.id }.max() ?? 0) + 1
        let newUser = User(id: newID, name: newName, username: newUsername, email: newEmail, tasks: [])
        modelContext.insert(newUser)
        newName = ""
        newUsername = ""
        newEmail = ""
    }
}

// Task 4: Dynamic Querying (@Query) and Type-Safe Filtering (#Predicate)
struct UserListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]

    init(searchText: String) {
        if searchText.isEmpty {
            _users = Query(sort: \User.name)
        } else {
            // Task 4: Type-safe #Predicate filtering by name or username
            _users = Query(
                filter: #Predicate<User> { user in
                    user.name.localizedStandardContains(searchText) ||
                    user.username.localizedStandardContains(searchText)
                },
                sort: \User.name
            )
        }
    }

    var body: some View {
        List {
            ForEach(users) { user in
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
            // Task 4: Delete operation using ModelContext
            .onDelete(perform: deleteUser)
        }
    }

    // Task 4: Delete operation using ModelContext
    private func deleteUser(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(users[index])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, UserTask.self], inMemory: true)
}

