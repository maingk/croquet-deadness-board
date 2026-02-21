import SwiftUI
import Combine

struct GameInfoPanelView: View {
    let game: Game
    @State private var currentTime = Date()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private let primaryText = Color(red: 0.1, green: 0.1, blue: 0.1)
    private let secondaryText = Color(red: 0.25, green: 0.25, blue: 0.25)
    private let dividerColor = Color(red: 0.3, green: 0.5, blue: 0.3)

    var body: some View {
        VStack(spacing: 32) {
            // Tournament info
            if let tournament = game.tournament {
                VStack(spacing: 8) {
                    Text("TOURNAMENT")
                        .font(.system(size: 40, weight: .medium, design: .rounded))
                        .foregroundStyle(secondaryText)

                    Text(tournament)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(primaryText)
                        .multilineTextAlignment(.center)
                }
            }

            Divider().background(dividerColor)

            // Current striker
            VStack(spacing: 16) {
                Text("CURRENT STRIKER")
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundStyle(secondaryText)

                let currentPlayer = game.players[game.currentStriker]

                VStack(spacing: 12) {
                    Circle()
                        .fill(currentPlayer.ballColor.color)
                        .frame(width: 140, height: 140)
                        .overlay(
                            Circle()
                                .stroke(Color(red: 0.3, green: 0.5, blue: 0.3), lineWidth: 6)
                        )
                        .scaleEffect(1.1)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: currentTime)

                    Text(currentPlayer.name.uppercased())
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(primaryText)

                    Text(currentPlayer.ballColor.rawValue.uppercased())
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundStyle(secondaryText)
                }
            }

            Divider().background(dividerColor)

            // Hoop progression
            VStack(spacing: 16) {
                Text("HOOP PROGRESSION")
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundStyle(secondaryText)

                VStack(spacing: 12) {
                    ForEach(game.players.indices, id: \.self) { index in
                        HoopProgressRow(
                            player: game.players[index],
                            hoopsCompleted: game.hoopProgression[index]
                        )
                    }
                }
            }

            Divider().background(dividerColor)

            // Game timer
            VStack(spacing: 8) {
                Text("GAME TIME")
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundStyle(secondaryText)

                Text(gameTimeString)
                    .font(.system(size: 84, weight: .regular, design: .monospaced))
                    .foregroundStyle(primaryText)
            }

            Spacer()

            // Status indicator
            HStack {
                Circle()
                    .fill(.green)
                    .frame(width: 20, height: 20)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: currentTime)

                Text("LIVE")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.green)
            }
        }
        .padding(32)
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }

    private var gameTimeString: String {
        let elapsed = currentTime.timeIntervalSince(game.startTime)
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        let seconds = Int(elapsed) % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

struct HoopProgressRow: View {
    let player: Player
    let hoopsCompleted: Int

    private let primaryText = Color(red: 0.1, green: 0.1, blue: 0.1)

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(player.ballColor.color)
                .frame(width: 48, height: 48)

            Text(player.name)
                .font(.system(size: 28, weight: .medium, design: .rounded))
                .foregroundStyle(primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(hoopDisplayText)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(primaryText)
        }
    }

    private var hoopDisplayText: String {
        switch hoopsCompleted {
        case 0...11:
            return "Hoop \(hoopsCompleted + 1)"
        case 12:
            return "Rover"
        case 13:
            return "Finished"
        default:
            return "Hoop 1"
        }
    }
}

struct WaitingForGameView: View {
    private let primaryText = Color(red: 0.1, green: 0.1, blue: 0.1)
    private let secondaryText = Color(red: 0.25, green: 0.25, blue: 0.25)

    var body: some View {
        VStack(spacing: 32) {
            Text("CROQUET DEADNESS BOARD")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(primaryText)

            Text("Waiting for game to start...")
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .foregroundStyle(secondaryText)

            Text("Connect your iOS device to begin")
                .font(.system(size: 20, weight: .regular, design: .rounded))
                .foregroundStyle(secondaryText.opacity(0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Game Info Panel") {
    let sampleGame = Game(
        id: "sample",
        tournament: "Spring Championship 2024",
        players: [
            Player(name: "Alice Johnson", ballColor: .blue, hoopsRun: 2, score: 0),
            Player(name: "Bob Smith", ballColor: .red, hoopsRun: 1, score: 0),
            Player(name: "Carol Davis", ballColor: .black, hoopsRun: 0, score: 0),
            Player(name: "Dave Wilson", ballColor: .yellow, hoopsRun: 3, score: 0)
        ],
        deadnessMatrix: Array(repeating: Array(repeating: false, count: 4), count: 4),
        currentStriker: 0,
        hoopProgression: [2, 1, 0, 3],
        timestamp: Date().addingTimeInterval(-1800), // 30 minutes ago
        status: .active
    )

    GameInfoPanelView(game: sampleGame)
        .frame(width: 400, height: 800)
        .background(Color(red: 0.90, green: 0.93, blue: 0.88))
}

#Preview("Waiting View") {
    WaitingForGameView()
        .background(Color(red: 0.95, green: 0.97, blue: 0.93))
}
