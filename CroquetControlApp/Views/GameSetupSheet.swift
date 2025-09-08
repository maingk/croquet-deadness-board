import SwiftUI
import SharedModels

struct GameSetupSheet: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var playerNames = ["", "", "", ""]
    @State private var tournamentInfo = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Players & Ball Colors") {
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
            .navigationTitle("Deadness Board Setup")
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
            Player(name: name.trimmingCharacters(in: .whitespacesAndNewlines), ballColor: color)
        }
        
        gameViewModel.startNewGame(
            players: players,
            tournamentInfo: tournamentInfo.isEmpty ? nil : tournamentInfo
        )
        
        dismiss()
    }
}

#Preview {
    GameSetupSheet()
        .environmentObject(GameViewModel())
}