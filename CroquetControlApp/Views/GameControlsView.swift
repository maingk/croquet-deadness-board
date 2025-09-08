import SwiftUI
import SharedModels

struct GameControlsView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Current striker controls
            if let game = gameViewModel.currentGame {
                HStack {
                    Text("Current Striker:")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button("Next Striker") {
                        gameViewModel.nextStriker()
                    }
                    .buttonStyle(.bordered)
                }
                
                // Hoop progression controls
                VStack {
                    Text("Hoop Progression")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(game.players.indices, id: \.self) { index in
                            HoopProgressionCard(
                                player: game.players[index],
                                onHoopRun: {
                                    gameViewModel.runHoop(for: index)
                                },
                                onClearDeadness: {
                                    gameViewModel.clearAllDeadness(for: index)
                                }
                            )
                        }
                    }
                }
                
                // Action buttons
                HStack(spacing: 16) {
                    Button("Undo Last Action") {
                        gameViewModel.undoLastAction()
                    }
                    .buttonStyle(.bordered)
                    .disabled(!gameViewModel.canUndo)
                    
                    Button("Clear All Deadness") {
                        gameViewModel.clearAllDeadness()
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.red)
                    
                    Button("End Game") {
                        gameViewModel.endGame()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct HoopProgressionCard: View {
    let player: Player
    let onHoopRun: () -> Void
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
            
            HStack {
                Text("Hoop \(player.hoopsRun + 1)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button("Run Hoop") {
                    onHoopRun()
                }
                .buttonStyle(.borderless)
                .font(.caption)
                .disabled(player.hoopsRun >= 12) // Rover + peg out
            }
            
            Button("Clear Deadness") {
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