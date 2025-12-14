import SwiftUI

struct DisplayContentView: View {
    @StateObject private var displayViewModel = DisplayViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            if let game = displayViewModel.currentGame {
                HStack(spacing: 0) {
                    // Main deadness board (70% width)
                    DeadnessBoardDisplayView(game: game)
                        .frame(width: geometry.size.width * 0.7)
                    
                    // Game info panel (30% width)
                    GameInfoPanelView(game: game)
                        .frame(width: geometry.size.width * 0.3)
                        .background(Color.gray.opacity(0.2))
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