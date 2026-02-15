import SwiftUI

struct GameControlsView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            // Current striker controls
            if let game = gameViewModel.currentGame {
                HStack {
                    Text("Current Striker:")
                        .font(.headline)

                    Circle()
                        .fill(game.players[game.currentStriker].ballColor.color)
                        .frame(width: 24, height: 24)

                    Text(game.players[game.currentStriker].name)
                        .font(.headline)
                        .fontWeight(.bold)

                    Spacer()

                    Button("Next Striker") {
                        gameViewModel.nextStriker()
                    }
                    .buttonStyle(.bordered)
                }

                // Hoop progression controls
                VStack(spacing: 8) {
                    Text("Hoop Progression")
                        .font(.headline)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                        ForEach(game.players.indices, id: \.self) { index in
                            HoopProgressionCard(
                                player: game.players[index],
                                onHoopRun: {
                                    gameViewModel.runHoop(for: index)
                                }
                            )
                        }
                    }
                }

                // Action buttons
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
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
                    }

                    Button("End Game") {
                        gameViewModel.endGame()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct HoopProgressionCard: View {
    let player: Player
    let onHoopRun: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Player name with color indicator
            HStack(spacing: 6) {
                Circle()
                    .fill(player.ballColor.color)
                    .frame(width: 20, height: 20)

                Text(player.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                Text("Hoop \(player.hoopsRun + 1)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Run Hoop button
            Button("Run Hoop") {
                onHoopRun()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .disabled(player.hoopsRun >= 12)
            .frame(maxWidth: .infinity)
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    GameControlsView()
        .environmentObject(GameViewModel())
}
