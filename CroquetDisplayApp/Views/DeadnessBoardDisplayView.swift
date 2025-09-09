import SwiftUI
import SharedModels

struct DeadnessBoardDisplayView: View {
    let game: Game
    
    var body: some View {
        VStack(spacing: 32) {
            Text("DEADNESS BOARD")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.top, 40)
            
            // Deadness grid - optimized for maximum visibility
            VStack(spacing: 12) {
                // Header row with player info
                HStack(spacing: 12) {
                    Spacer()
                        .frame(width: 160)
                    
                    ForEach(game.players.indices, id: \.self) { index in
                        PlayerHeaderCell(player: game.players[index])
                    }
                }
                
                // Grid rows
                ForEach(game.players.indices, id: \.self) { row in
                    HStack(spacing: 12) {
                        // Row header
                        PlayerHeaderCell(player: game.players[row])
                            .frame(width: 160)
                        
                        // Deadness cells - larger for tournament visibility
                        ForEach(game.players.indices, id: \.self) { col in
                            DisplayDeadnessCell(
                                isDead: game.deadnessMatrix[row][col],
                                isDisabled: row == col,
                                fromColor: game.players[row].ballColor,
                                toColor: game.players[col].ballColor
                            )
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct PlayerHeaderCell: View {
    let player: Player
    
    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(player.ballColor.color)
                .frame(width: 100, height: 100)
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 5)
                )
            
            VStack(spacing: 6) {
                Text(player.name.uppercased())
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Text(player.ballColor.rawValue.uppercased())
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .frame(height: 180)
    }
}

struct DisplayDeadnessCell: View {
    let isDead: Bool
    let isDisabled: Bool
    let fromColor: BallColor
    let toColor: BallColor
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(cellBackgroundColor)
            .frame(width: 160, height: 160)
            .overlay(
                Group {
                    if isDisabled {
                        Image(systemName: "minus")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundStyle(.white.opacity(0.5))
                    } else if isDead {
                        Image(systemName: "xmark")
                            .font(.system(size: 70, weight: .bold))
                            .foregroundStyle(.white)
                    } else {
                        Image(systemName: "checkmark")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.4), lineWidth: 3)
            )
            .scaleEffect(isDead ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isDead)
    }
    
    private var cellBackgroundColor: Color {
        if isDisabled {
            return .gray.opacity(0.4)
        } else if isDead {
            return .red.opacity(0.8)
        } else {
            return .green.opacity(0.6)
        }
    }
}

#Preview {
    let sampleGame = Game(
        id: "sample",
        players: [
            Player(id: "1", name: "Alice", ballColor: .blue),
            Player(id: "2", name: "Bob", ballColor: .red),
            Player(id: "3", name: "Carol", ballColor: .black),
            Player(id: "4", name: "Dave", ballColor: .yellow)
        ],
        deadnessMatrix: [
            [false, true, false, false],
            [false, false, false, true],
            [true, false, false, false],
            [false, false, true, false]
        ],
        tournament: "Test Tournament"
    )
    
    DeadnessBoardDisplayView(game: sampleGame)
        .background(.black)
}