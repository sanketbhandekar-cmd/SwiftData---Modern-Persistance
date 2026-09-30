import SwiftUI
import SwiftData

struct UserDetailView: View {
    // Task 4: SwiftData ModelContext and @Bindable object binding
    @Environment(\.modelContext) private var modelContext
    @Bindable var user: User
    @State private var newTaskTitle = ""

    var body: some View {
        List {
            Section("User Profile") {
                LabeledContent("Name", value: user.name)
                LabeledContent("Username", value: "@\(user.username)")
                LabeledContent("Email", value: user.email)
            }

            Section("Assigned Tasks (\(user.tasks.count))") {
                HStack {
                    TextField("New task title...", text: $newTaskTitle)
                    Button("Add") {
                        guard !newTaskTitle.isEmpty else { return }
                        // Task 4: Create and persist new task associated with user
                        let newTask = UserTask(title: newTaskTitle, user: user)
                        user.tasks.append(newTask)
                        newTaskTitle = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                ForEach(user.tasks) { task in
                    Button {
                        // Task 4: Update task completion state
                        task.isCompleted.toggle()
                    } label: {
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                            Text(task.title)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                }
                // Task 4: Delete task from ModelContext
                .onDelete(perform: deleteTask)
            }
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // Task 4: Delete task from ModelContext
    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = user.tasks[index]
            modelContext.delete(task)
        }
    }
}

#Preview {
    NavigationStack {
        UserDetailView(user: User.mockUsers[0])
    }
    .modelContainer(for: [User.self, UserTask.self], inMemory: true)
}

