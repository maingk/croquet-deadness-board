import SwiftUI

struct ContentView: View {
    @StateObject private var gameViewModel = GameViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                GameSetupView()
                    .environmentObject(gameViewModel)

                DeadnessGridView()
                    .environmentObject(gameViewModel)

                GameControlsView()
                    .environmentObject(gameViewModel)

                Spacer(minLength: 0)
            }
            .padding(.top, 8)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}