import SwiftUI
import SharedModels

struct DisplayContentView: View {
    @StateObject private var displayViewModel = DisplayViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            if let game = displayViewModel.currentGame {
                HStack(spacing: 0) {
                    // Main deadness board (80% width - bigger focus on matrix)
                    DeadnessBoardDisplayView(game: game)
                        .frame(width: geometry.size.width * 0.8)
                    
                    // Game info panel (20% width - minimal info only)
                    GameInfoPanelView(game: game)
                        .frame(width: geometry.size.width * 0.2)
                        .background(Color(.systemGray6))
                }
            } else {
                WaitingForGameView()
            }
        }
        .background(.black)
        .ignoresSafeArea()
        .onAppear {
            displayViewModel.startListening()
        }
        .onDisappear {
            displayViewModel.stopListening()
        }
    }
}

#Preview {
    DisplayContentView()
}