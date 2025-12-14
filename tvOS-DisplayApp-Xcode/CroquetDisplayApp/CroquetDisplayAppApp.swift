import SwiftUI
import FirebaseCore

@main
struct CroquetDisplayApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            DisplayContentView()
        }
    }
}
