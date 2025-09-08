import SwiftUI

struct ContentView: View {
    @StateObject private var gameViewModel = GameViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                GameSetupView()
                    .environmentObject(gameViewModel)
                
                DeadnessGridView()
                    .environmentObject(gameViewModel)
                
                GameControlsView()
                    .environmentObject(gameViewModel)
            }
            .navigationTitle("Croquet Control")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}