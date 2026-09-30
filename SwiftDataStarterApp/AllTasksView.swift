import SwiftUI
import SwiftData

struct AllTasksView: View {
    // Task 4: SwiftData ModelContext and dynamic @Query replacing in-memory array
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserTask.title) private var tasks: [UserTask]

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    HStack {
                        Button {
                            // Task 4: Update task completion status
                            task.isCompleted.toggle()
                        } label: {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                        }
                        .buttonStyle(.plain)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(task.title)
                                .font(.body)
                            if let owner = task.user {
                                Text("Assigned to: \(owner.name)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                    }
                }
                // Task 4: Delete task from ModelContext
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("All Tasks")
            .overlay {
                if tasks.isEmpty {
                    ContentUnavailableView("No Tasks Found", systemImage: "checklist", description: Text("Tasks created under users will appear here."))
                }
            }
        }
    }

    // Task 4: Delete task from ModelContext
    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tasks[index])
        }
    }
}

#Preview {
    AllTasksView()
        .modelContainer(for: [User.self, UserTask.self], inMemory: true)
}

