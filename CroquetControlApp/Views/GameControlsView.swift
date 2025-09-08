import SwiftUI
import SharedModels

struct GameControlsView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if let game = gameViewModel.currentGame {
                
                // Player deadness controls
                VStack {
                    Text("Clear Deadness by Player")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(game.players.indices, id: \.self) { index in
                            PlayerDeadnessCard(
                                player: game.players[index],
                                onClearDeadness: {
                                    gameViewModel.clearAllDeadness(for: index)
                                }
                            )
                        }
                    }
                }
                
                // Global action buttons
                VStack(spacing: 12) {
                    Button("Clear All Deadness") {
                        gameViewModel.clearAllDeadness()
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    
                    HStack(spacing: 16) {
                        Button("Undo Last Change") {
                            gameViewModel.undoLastAction()
                        }
                        .buttonStyle(.bordered)
                        .disabled(!gameViewModel.canUndo)
                        
                        Button("End Session") {
                            gameViewModel.endGame()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct PlayerDeadnessCard: View {
    let player: Player
    let onClearDeadness: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Circle()
                    .fill(player.ballColor.color)
                    .frame(width: 24, height: 24)
                
                Text(player.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            
            Button("Clear All Deadness") {
                onClearDeadness()
            }
            .buttonStyle(.borderless)
            .font(.caption)
            .foregroundStyle(.orange)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    GameControlsView()
        .environmentObject(GameViewModel())
}