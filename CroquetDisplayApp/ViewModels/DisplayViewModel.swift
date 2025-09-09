import SwiftUI
import Combine
import SharedModels

class DisplayViewModel: ObservableObject {
    @Published var currentGame: Game?
    @Published var connectionStatus: ConnectionStatus = .disconnected
    
    private var cancellables = Set<AnyCancellable>()
    private var firebaseService: FirebaseGameService?
    
    enum ConnectionStatus {
        case connected
        case disconnected
        case connecting
    }
    
    init() {
        // Initialize Firebase service when available
        setupFirebaseService()
        
        #if DEBUG
        // Load sample game for previews
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            loadSampleGame()
        }
        #endif
    }
    
    func startListening() {
        connectionStatus = .connecting
        
        // Start listening for game updates from Firebase
        firebaseService?.startListening { [weak self] game in
            DispatchQueue.main.async {
                self?.currentGame = game
                self?.connectionStatus = game != nil ? .connected : .disconnected
            }
        }
    }
    
    func stopListening() {
        firebaseService?.stopListening()
        connectionStatus = .disconnected
    }
    
    private func setupFirebaseService() {
        firebaseService = FirebaseGameService.shared
    }
    
    // MARK: - Debug/Preview helpers
    
    #if DEBUG
    private func loadSampleGame() {
        let samplePlayers = [
            Player(id: "1", name: "Alice Johnson", ballColor: .blue),
            Player(id: "2", name: "Bob Smith", ballColor: .red),
            Player(id: "3", name: "Carol Davis", ballColor: .black),
            Player(id: "4", name: "Dave Wilson", ballColor: .yellow)
        ]
        
        var sampleMatrix = Array(repeating: Array(repeating: false, count: 4), count: 4)
        sampleMatrix[0][1] = true // Alice dead on Bob
        sampleMatrix[2][3] = true // Carol dead on Dave
        sampleMatrix[1][0] = true // Bob dead on Alice
        
        currentGame = Game(
            id: "sample-game",
            players: samplePlayers,
            deadnessMatrix: sampleMatrix,
            tournament: "Spring Championship 2024"
        )
        
        connectionStatus = .connected
    }
    
    func simulateGameUpdate() {
        guard var game = currentGame else { return }
        
        // Toggle some deadness for visual effect
        let row = Int.random(in: 0..<4)
        let col = Int.random(in: 0..<4)
        if row != col {
            game.deadnessMatrix[row][col].toggle()
        }
        
        currentGame = game
    }
    #endif
}