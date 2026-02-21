import SwiftUI

struct DeadnessBoardDisplayView: View {
    let game: Game

    private let primaryText = Color(red: 0.1, green: 0.1, blue: 0.1)

    var body: some View {
        VStack(spacing: 24) {
            Text("DEADNESS BOARD")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundStyle(primaryText)
                .padding(.top, 32)

            // Deadness grid
            VStack(spacing: 12) {
                // Header row with player info
                HStack(spacing: 12) {
                    Color.clear
                        .frame(width: 150, height: 0)

                    ForEach(game.players.indices, id: \.self) { index in
                        PlayerHeaderCell(player: game.players[index])
                            .frame(width: 150)
                    }
                }

                // Grid rows
                ForEach(game.players.indices, id: \.self) { row in
                    HStack(spacing: 12) {
                        // Row header
                        PlayerHeaderCell(player: game.players[row])
                            .frame(width: 150)

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

    private let primaryText = Color(red: 0.1, green: 0.1, blue: 0.1)
    private let secondaryText = Color(red: 0.25, green: 0.25, blue: 0.25)
    private let borderColor = Color(red: 0.3, green: 0.5, blue: 0.3)

    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(player.ballColor.color)
                .frame(width: 100, height: 100)
                .overlay(
                    Circle()
                        .stroke(borderColor, lineWidth: 5)
                )

            VStack(spacing: 4) {
                Text(player.name.uppercased())
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                Text(player.ballColor.rawValue.uppercased())
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundStyle(secondaryText)
            }
        }
        .frame(height: 170)
    }
}

struct DisplayDeadnessCell: View {
    let isDead: Bool
    let isDisabled: Bool
    let fromColor: BallColor
    let toColor: BallColor

    private let cellBorder = Color(red: 0.3, green: 0.5, blue: 0.3)

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(cellBackgroundColor)
            .frame(width: 150, height: 150)
            .overlay(
                Group {
                    if isDisabled {
                        EmptyView()
                    } else if isDead {
                        Image(systemName: "xmark")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundStyle(.white)
                    } else {
                        EmptyView()
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(cellBorder, lineWidth: 3)
            )
    }

    private var cellBackgroundColor: Color {
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
        .background(Color(red: 0.95, green: 0.97, blue: 0.93))
}
