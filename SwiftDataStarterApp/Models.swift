import Foundation

struct User: Identifiable, Hashable {
    let id: Int
    var name: String
    var username: String
    var email: String
    var tasks: [UserTask] = []
}

struct UserTask: Identifiable, Hashable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
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
