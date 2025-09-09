import SwiftUI
import SharedModels

struct GameInfoPanelView: View {
    let game: Game
    @State private var currentTime = Date()
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 24) {
            // Tournament info
            if let tournament = game.tournament {
                VStack(spacing: 8) {
                    Text("TOURNAMENT")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Text(tournament)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
            }
            
            Divider()
            
            // Players list 
            VStack(spacing: 12) {
                Text("PLAYERS")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                
                VStack(spacing: 8) {
                    ForEach(game.players.indices, id: \.self) { index in
                        PlayerInfoRow(player: game.players[index])
                    }
                }
            }
            
            Divider()
            
            // Game timer
            VStack(spacing: 8) {
                Text("SESSION TIME")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                
                Text(sessionTimeString)
                    .font(.system(size: 24, weight: .mono, design: .monospaced))
                    .foregroundStyle(.primary)
            }
            
            Spacer()
            
            // Live indicator
            HStack {
                Circle()
                    .fill(.green)
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: currentTime)
                
                Text("LIVE")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(.green)
            }
        }
        .padding(16)
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
    
    private var sessionTimeString: String {
        let elapsed = currentTime.timeIntervalSince(game.timestamp)
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        
        if hours > 0 {
            return String(format: "%02d:%02d", hours, minutes)
        } else {
            return String(format: "%02d min", minutes)
        }
    }
}

struct PlayerInfoRow: View {
    let player: Player
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(player.ballColor.color)
                .frame(width: 20, height: 20)
            
            Text(player.name)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
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
        players: [
            Player(id: "1", name: "Alice Johnson", ballColor: .blue),
            Player(id: "2", name: "Bob Smith", ballColor: .red),
            Player(id: "3", name: "Carol Davis", ballColor: .black),
            Player(id: "4", name: "Dave Wilson", ballColor: .yellow)
        ],
        deadnessMatrix: [
            [false, true, false, false],
            [false, false, false, true],
            [true, false, false, false],
            [false, false, true, false]
        ],
        tournament: "Spring Championship 2024"
    )
    
    GameInfoPanelView(game: sampleGame)
        .frame(width: 300, height: 800)
        .background(Color(.systemGray6))
}

#Preview("Waiting View") {
    WaitingForGameView()
        .background(.black)
}