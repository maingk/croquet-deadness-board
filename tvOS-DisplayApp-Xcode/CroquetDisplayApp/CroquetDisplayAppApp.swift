import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct CroquetDisplayApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            DisplayContentView()
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
