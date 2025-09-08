import SwiftUI
import SharedModels

struct GameSetupView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @State private var showingSetup = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Current Game")
                    .font(.headline)
                
                Spacer()
                
                Button("Setup New Game") {
                    showingSetup = true
                }
                .buttonStyle(.borderedProminent)
            }
            
            if let game = gameViewModel.currentGame {
                HStack(spacing: 16) {
                    ForEach(game.players.indices, id: \.self) { index in
                        PlayerCard(player: game.players[index])
                    }
                }
            } else {
                Text("No active game")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .sheet(isPresented: $showingSetup) {
            GameSetupSheet()
                .environmentObject(gameViewModel)
        }
    }
}

struct PlayerCard: View {
    let player: Player
    
    var body: some View {
        VStack {
            Circle()
                .fill(player.ballColor.color)
                .frame(width: 40, height: 40)
            
            Text(player.name)
                .font(.caption)
                .lineLimit(1)
            
            Text(player.ballColor.rawValue)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    GameSetupView()
        .environmentObject(GameViewModel())
}