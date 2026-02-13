import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct CroquetControlApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        try await Auth.auth().signInAnonymously()
                    } catch {
                        print("Anonymous auth failed: \(error.localizedDescription)")
                    }
                }
        }
    }
}
