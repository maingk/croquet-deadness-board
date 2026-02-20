import SwiftUI

struct GameSetupView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @State private var showingSetup = false
    
    var body: some View {
        Group {
            if gameViewModel.currentGame == nil {
                GeometryReader { geometry in
                    VStack(spacing: 30) {
                        Spacer()
                            .frame(height: geometry.size.height * 0.10)

                        Button("Setup New Game") {
                            showingSetup = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)

                        Image("ClubLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .sheet(isPresented: $showingSetup) {
            GameSetupSheet()
                .environmentObject(gameViewModel)
        }
    }
}

struct PlayerCard: View {
    let player: Player
    let isCurrentStriker: Bool

    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(player.ballColor.color)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(isCurrentStriker ? Color.primary : Color.clear, lineWidth: 3)
                )

            Text(player.name)
                .font(.caption)
                .lineLimit(1)

            Text("Hoop \(player.hoopsRun + 1)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    GameSetupView()
        .environmentObject(GameViewModel())
}
