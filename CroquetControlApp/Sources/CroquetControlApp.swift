import SwiftUI
import FirebaseCore

@main
struct CroquetControlApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}