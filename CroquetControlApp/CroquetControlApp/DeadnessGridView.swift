import SwiftUI

struct DeadnessGridView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            if gameViewModel.currentGame != nil {
                Text("Deadness Matrix")
                    .font(.headline)
                    .padding(.bottom, 2)
            }

            if gameViewModel.currentGame != nil {
                let game = gameViewModel.currentGame!
                VStack(spacing: 6) {
                    // Header row with player colors
                    HStack(spacing: 6) {
                        Color.clear
                            .frame(width: 40, height: 40)

                        ForEach(game.players.indices, id: \.self) { index in
                            Circle()
                                .fill(game.players[index].ballColor.color)
                                .frame(width: 40, height: 40)
                                .frame(width: 68)
                        }
                    }

                    // Grid rows
                    ForEach(game.players.indices, id: \.self) { row in
                        HStack(spacing: 6) {
                            // Row header
                            Circle()
                                .fill(game.players[row].ballColor.color)
                                .frame(width: 40, height: 40)
                                .frame(height: 68)

                            // Deadness cells
                            ForEach(game.players.indices, id: \.self) { col in
                                DeadnessCell(
                                    isDead: game.deadnessMatrix[row][col],
                                    isDisabled: row == col
                                ) {
                                    gameViewModel.toggleDeadness(from: row, to: col)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct DeadnessCell: View {
    let isDead: Bool
    let isDisabled: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            RoundedRectangle(cornerRadius: 8)
                .fill(cellColor)
                .frame(width: 68, height: 68)
                .overlay(
                    Image(systemName: isDead ? "xmark" : "")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(isDead ? .white : .clear)
                )
        }
        .disabled(isDisabled)
    }
    
    private var cellColor: Color {
        if isDisabled {
            return .gray.opacity(0.3)
        } else if isDead {
            return .red
        } else {
            return .green.opacity(0.6)
        }
    }
}

#Preview {
    DeadnessGridView()
        .environmentObject(GameViewModel())
}
