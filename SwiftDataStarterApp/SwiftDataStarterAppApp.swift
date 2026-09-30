import SwiftUI
import SwiftData

// Task 3: Configure ModelContainer Setup & Context
/*
1. Added import SwiftData at the application entry point.
2. Attached the .modelContainer(for: [User.self, UserTask.self]) modifier to the WindowGroup
 */
@main
struct SwiftDataStarterAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, UserTask.self])
    }
}
