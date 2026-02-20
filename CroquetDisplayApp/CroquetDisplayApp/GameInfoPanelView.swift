import SwiftUI
import Combine

struct GameInfoPanelView: View {
    let game: Game
    @State private var currentTime = Date()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 32) {
            // Tournament info
            if let tournament = game.tournament {
                VStack(spacing: 8) {
                    Text("TOURNAMENT")
                        .font(.system(size: 32, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Text(tournament)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
            }
            
            Divider()
            
            // Current striker
            VStack(spacing: 16) {
                Text("CURRENT STRIKER")
                    .font(.system(size: 32, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
                
                let currentPlayer = game.players[game.currentStriker]
                
                VStack(spacing: 12) {
                    Circle()
                        .fill(currentPlayer.ballColor.color)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 6)
                        )
                        .scaleEffect(1.1)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: currentTime)
                    
                    Text(currentPlayer.name.uppercased())
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text(currentPlayer.ballColor.rawValue.uppercased())
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            
            Divider()
            
            // Hoop progression
            VStack(spacing: 16) {
                Text("HOOP PROGRESSION")
                    .font(.system(size: 32, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))

                VStack(spacing: 12) {
                    ForEach(game.players.indices, id: \.self) { index in
                        HoopProgressRow(
                            player: game.players[index],
                            hoopsCompleted: game.hoopProgression[index]
                        )
                    }
                }
            }
            
            Divider()
            
            // Game timer
            VStack(spacing: 8) {
                Text("GAME TIME")
                    .font(.system(size: 32, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
                
                Text(gameTimeString)
                    .font(.system(size: 84, weight: .regular, design: .monospaced))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            // Status indicator
            HStack {
                Circle()
                    .fill(.green)
                    .frame(width: 12, height: 12)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: currentTime)
                
                Text("LIVE")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
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

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(player.ballColor.color)
                .frame(width: 32, height: 32)

            Text(player.name)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(hoopDisplayText)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
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
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "gamecontroller")
                .font(.system(size: 120))
                .foregroundStyle(.white.opacity(0.6))
                .offset(y: animationOffset)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animationOffset)
            
            VStack(spacing: 16) {
                Text("CROQUET DEADNESS BOARD")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Waiting for game to start...")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Text("Connect your iOS device to begin")
                .font(.system(size: 20, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
        }
        .onAppear {
            animationOffset = -20
        }
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
        .background(Color.gray.opacity(0.2))
}

#Preview("Waiting View") {
    WaitingForGameView()
        .background(.black)
}