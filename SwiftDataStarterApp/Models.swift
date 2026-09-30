import Foundation
import SwiftData

// Task 1 : Defined SwiftData Entities (@Model & @Attribute)
@Model
final class User {
    @Attribute(.unique)
    var id: Int
    var name: String
    @Attribute(.unique)
    var username: String
    @Attribute(.unique)
    var email: String

    // Task 2: Established 1-to-Many Relationships & Deletion Rules (@Relationship)
    @Relationship(deleteRule: .cascade, inverse: \UserTask.user)
    var tasks: [UserTask] = []

    init(id: Int, name: String, username: String, email: String, tasks: [UserTask] = []) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.tasks = tasks
    }
}

// Task 1 : Defined SwiftData Entities (@Model & @Attribute)
@Model
final class UserTask {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var user: User?
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, user: User? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.user = user
    }
}

extension User {
    static let mockUsers: [User] = [
        User(
            id: 1,
            name: "Alex Rivera",
            username: "arivera",
            email: "alex.rivera@example.com",
            tasks: [
                UserTask(title: "Complete SwiftData schema definition", isCompleted: false),
                UserTask(title: "Set up ModelContainer in App Shell", isCompleted: true)
            ]
        ),
        User(
            id: 2,
            name: "Jordan Lee",
            username: "jlee",
            email: "jordan.lee@example.com",
            tasks: [
                UserTask(title: "Implement #Predicate search filtering", isCompleted: false),
                UserTask(title: "Verify cascade deletion rules", isCompleted: false)
            ]
        )
    ]
}
