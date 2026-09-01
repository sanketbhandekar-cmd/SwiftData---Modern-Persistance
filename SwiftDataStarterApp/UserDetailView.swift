import SwiftUI

struct UserDetailView: View {
    @State var user: User
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
                        let newTask = UserTask(title: newTaskTitle)
                        user.tasks.append(newTask)
                        newTaskTitle = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                ForEach(user.tasks) { task in
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                        Text(task.title)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        UserDetailView(user: User.mockUsers[0])
    }
}
