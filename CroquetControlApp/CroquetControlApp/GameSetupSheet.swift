import SwiftUI

struct GameSetupSheet: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var playerNames = ["", "", "", ""]
    @State private var gameFormat: GameFormat = .doubles
    @State private var tournamentInfo = ""
    @State private var team1Indices: [Int] = [0, 2]  // Blue, Black
    @State private var team2Indices: [Int] = [1, 3]  // Red, Yellow

    var body: some View {
        NavigationView {
            Form {
                Section("Game Format") {
                    Picker("Format", selection: $gameFormat) {
                        Text("Doubles").tag(GameFormat.doubles)
                        Text("Singles").tag(GameFormat.singles)
                    }
                    .pickerStyle(.segmented)
                }

                if gameFormat == .doubles {
                    Section("Team 1") {
                        ForEach(team1Indices, id: \.self) { index in
                            playerRow(index: index)
                        }
                    }

                    Section("Team 2") {
                        ForEach(team2Indices, id: \.self) { index in
                            playerRow(index: index)
                        }
                    }

                    Section("Team Pairing") {
                        Picker("Pairing", selection: Binding(
                            get: { teamPairing },
                            set: { applyPairing($0) }
                        )) {
                            Text("Blue+Black vs Red+Yellow").tag(TeamPairing.blueBlack_redYellow)
                            Text("Blue+Red vs Black+Yellow").tag(TeamPairing.blueRed_blackYellow)
                            Text("Blue+Yellow vs Red+Black").tag(TeamPairing.blueYellow_redBlack)
                        }
                        .pickerStyle(.menu)
                    }
                } else {
                    Section("Players") {
                        ForEach(0..<4, id: \.self) { index in
                            playerRow(index: index)
                        }
                    }
                }

                Section("Tournament Information (Optional)") {
                    TextField("Tournament Name", text: $tournamentInfo)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .navigationTitle("New Game Setup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start Game") {
                        startNewGame()
                    }
                    .disabled(!isValidSetup)
                }
            }
        }
    }
    
    private func playerRow(index: Int) -> some View {
        HStack {
            Circle()
                .fill(BallColor.allCases[index].color)
                .frame(width: 30, height: 30)

            Text(BallColor.allCases[index].rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 60, alignment: .leading)

            TextField("Player Name", text: $playerNames[index])
                .textFieldStyle(.roundedBorder)
        }
    }

    private var teamPairing: TeamPairing {
        let sorted1 = team1Indices.sorted()
        if sorted1 == [0, 2] { return .blueBlack_redYellow }
        if sorted1 == [0, 1] { return .blueRed_blackYellow }
        if sorted1 == [0, 3] { return .blueYellow_redBlack }
        return .blueBlack_redYellow
    }

    private func applyPairing(_ pairing: TeamPairing) {
        switch pairing {
        case .blueBlack_redYellow:
            team1Indices = [0, 2]
            team2Indices = [1, 3]
        case .blueRed_blackYellow:
            team1Indices = [0, 1]
            team2Indices = [2, 3]
        case .blueYellow_redBlack:
            team1Indices = [0, 3]
            team2Indices = [1, 2]
        }
    }

    private var isValidSetup: Bool {
        playerNames.allSatisfy { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    private func startNewGame() {
        let players = zip(playerNames, BallColor.allCases).map { name, color in
            Player(name: name.trimmingCharacters(in: .whitespacesAndNewlines), ballColor: color, hoopsRun: 0, score: 0)
        }
        
        gameViewModel.startNewGame(
            players: players,
            format: gameFormat,
            tournamentInfo: tournamentInfo.isEmpty ? nil : tournamentInfo
        )
        
        dismiss()
    }
}



enum GameFormat: String, CaseIterable {
    case singles = "Singles"
    case doubles = "Doubles"
}

enum TeamPairing {
    case blueBlack_redYellow
    case blueRed_blackYellow
    case blueYellow_redBlack
}

#Preview {
    GameSetupSheet()
        .environmentObject(GameViewModel())
}
