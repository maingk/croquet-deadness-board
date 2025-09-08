import SwiftUI

struct GameSetupSheet: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var playerNames = ["", "", "", ""]
    @State private var gameFormat: GameFormat = .singles
    @State private var tournamentInfo = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Game Format") {
                    Picker("Format", selection: $gameFormat) {
                        Text("Singles").tag(GameFormat.singles)
                        Text("Doubles").tag(GameFormat.doubles)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Players") {
                    ForEach(0..<4, id: \.self) { index in
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

#Preview {
    GameSetupSheet()
        .environmentObject(GameViewModel())
}