import SwiftUI

struct AllTasksView: View {
    @State var users: [User]

    var allTasks: [(task: UserTask, ownerName: String)] {
        var list: [(task: UserTask, ownerName: String)] = []
        for user in users {
            for task in user.tasks {
                list.append((task: task, ownerName: user.name))
            }
        }
        return list
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(allTasks, id: \.task.id) { item in
                    HStack {
                        Image(systemName: item.task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.task.isCompleted ? .green : .gray)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.task.title)
                                .font(.body)
                            Text("Assigned to: \(item.ownerName)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("All Tasks")
            .overlay {
                if allTasks.isEmpty {
                    ContentUnavailableView("No Tasks Found", systemImage: "checklist", description: Text("Tasks created under users will appear here."))
                }
            }
        }
    }
}

#Preview {
    AllTasksView(users: User.mockUsers)
}
