import SwiftUI
import SharedModels

struct DeadnessGridView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Deadness Matrix")
                .font(.headline)
                .padding(.bottom, 4)
            
            if let game = gameViewModel.currentGame {
                VStack(spacing: 2) {
                    // Header row with player colors
                    HStack(spacing: 2) {
                        Color.clear
                            .frame(width: 60, height: 40)
                        
                        ForEach(game.players.indices, id: \.self) { index in
                            Circle()
                                .fill(game.players[index].ballColor.color)
                                .frame(width: 40, height: 40)
                        }
                    }
                    
                    // Grid rows
                    ForEach(game.players.indices, id: \.self) { row in
                        HStack(spacing: 2) {
                            // Row header
                            Circle()
                                .fill(game.players[row].ballColor.color)
                                .frame(width: 40, height: 40)
                            
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
            } else {
                Text("No active game")
                    .foregroundStyle(.secondary)
                    .padding()
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
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: isDead ? "xmark" : "")
                        .font(.title2)
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