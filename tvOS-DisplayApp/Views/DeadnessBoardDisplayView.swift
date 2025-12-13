import SwiftUI
import SharedModels

struct DeadnessBoardDisplayView: View {
    let game: Game
    
    var body: some View {
        VStack(spacing: 24) {
            Text("DEADNESS BOARD")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.top, 32)
            
            // Deadness grid
            VStack(spacing: 8) {
                // Header row with player info
                HStack(spacing: 8) {
                    Spacer()
                        .frame(width: 120)
                    
                    ForEach(game.players.indices, id: \.self) { index in
                        PlayerHeaderCell(player: game.players[index])
                    }
                }
                
                // Grid rows
                ForEach(game.players.indices, id: \.self) { row in
                    HStack(spacing: 8) {
                        // Row header
                        PlayerHeaderCell(player: game.players[row])
                            .frame(width: 120)
                        
                        // Deadness cells
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
        VStack(spacing: 12) {
            Circle()
                .fill(player.ballColor.color)
                .frame(width: 80, height: 80)
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 4)
                )
            
            VStack(spacing: 4) {
                Text(player.name.uppercased())
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Text(player.ballColor.rawValue.uppercased())
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .frame(height: 140)
    }
}

struct DisplayDeadnessCell: View {
    let isDead: Bool
    let isDisabled: Bool
    let fromColor: BallColor
    let toColor: BallColor
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(cellBackgroundColor)
            .frame(width: 120, height: 120)
            .overlay(
                Group {
                    if isDisabled {
                        Image(systemName: "minus")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.white.opacity(0.5))
                    } else if isDead {
                        Image(systemName: "xmark")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundStyle(.white)
                    } else {
                        Image(systemName: "checkmark")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.3), lineWidth: 2)
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
        tournament: "Test Tournament",
        players: [
            Player(name: "Alice", ballColor: .blue, hoopsRun: 2, score: 0),
            Player(name: "Bob", ballColor: .red, hoopsRun: 1, score: 0),
            Player(name: "Carol", ballColor: .black, hoopsRun: 0, score: 0),
            Player(name: "Dave", ballColor: .yellow, hoopsRun: 3, score: 0)
        ],
        deadnessMatrix: [
            [false, true, false, false],
            [false, false, false, true],
            [true, false, false, false],
            [false, false, true, false]
        ],
        currentStriker: 0,
        hoopProgression: [2, 1, 0, 3],
        timestamp: Date(),
        status: .active
    )
    
    DeadnessBoardDisplayView(game: sampleGame)
        .background(.black)
}