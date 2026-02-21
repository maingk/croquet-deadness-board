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
                        .background(Color(red: 0.90, green: 0.93, blue: 0.88))
                }
            } else {
                WaitingForGameView()
            }
        }
        .background(
            ZStack {
                Color(red: 0.95, green: 0.97, blue: 0.93)
                Image("ClubLogo")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.12)
            }
        )
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
