import SwiftUI

struct HoopTrackView: View {
    let game: Game

    var body: some View {
        VStack(spacing: 8) {
            Text("Hoop Progress")
                .font(.headline)

            VStack(spacing: 6) {
                ForEach(game.players.indices, id: \.self) { index in
                    HoopTrackRow(
                        player: game.players[index],
                        hoopsCompleted: game.hoopProgression[index]
                    )
                }
            }
        }
        .padding()
    }
}

struct HoopTrackRow: View {
    let player: Player
    let hoopsCompleted: Int

    var body: some View {
        HStack(spacing: 6) {
            // Player identifier
            Circle()
                .fill(player.ballColor.color)
                .frame(width: 24, height: 24)

            Text(player.name)
                .font(.caption)
                .fontWeight(.medium)
                .frame(width: 60, alignment: .leading)
                .lineLimit(1)

            // Hoop track (12 hoops)
            HStack(spacing: 4) {
                ForEach(0..<12, id: \.self) { hoopIndex in
                    HoopIndicator(
                        hoopNumber: hoopIndex + 1,
                        isCompleted: hoopIndex < hoopsCompleted,
                        isCurrent: hoopIndex == hoopsCompleted,
                        playerColor: player.ballColor.color
                    )
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct HoopIndicator: View {
    let hoopNumber: Int
    let isCompleted: Bool
    let isCurrent: Bool
    let playerColor: Color

    var body: some View {
        ZStack {
            if isCompleted {
                // Completed hoop - filled circle
                Circle()
                    .fill(playerColor)
                    .frame(width: 16, height: 16)
            } else if isCurrent {
                // Current hoop - outlined circle
                Circle()
                    .strokeBorder(playerColor, lineWidth: 2)
                    .frame(width: 16, height: 16)
            } else {
                // Future hoop - small gray dot
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 10, height: 10)
            }
        }
        .frame(width: 16, height: 16)
    }
}

#Preview {
    let samplePlayers = [
        Player(name: "Alice", ballColor: .blue, hoopsRun: 3, score: 0),
        Player(name: "Bob", ballColor: .red, hoopsRun: 1, score: 0),
        Player(name: "Carol", ballColor: .black, hoopsRun: 5, score: 0),
        Player(name: "Dave", ballColor: .yellow, hoopsRun: 2, score: 0)
    ]

    let sampleGame = Game(
        id: "preview",
        tournament: "Test",
        players: samplePlayers,
        deadnessMatrix: Array(repeating: Array(repeating: false, count: 4), count: 4),
        currentStriker: 0,
        hoopProgression: [3, 1, 5, 2],
        timestamp: Date(),
        status: .active
    )

    return HoopTrackView(game: sampleGame)
}
