import SwiftUI
import Combine

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
        // Firebase service will be initialized when the service layer is implemented
        // For now, this is a placeholder
    }
    
    // MARK: - Debug/Preview helpers
    
    #if DEBUG
    private func loadSampleGame() {
        let samplePlayers = [
            Player(name: "Alice Johnson", ballColor: .blue, hoopsRun: 2, score: 0),
            Player(name: "Bob Smith", ballColor: .red, hoopsRun: 1, score: 0),
            Player(name: "Carol Davis", ballColor: .black, hoopsRun: 0, score: 0),
            Player(name: "Dave Wilson", ballColor: .yellow, hoopsRun: 3, score: 0)
        ]
        
        var sampleMatrix = Array(repeating: Array(repeating: false, count: 4), count: 4)
        sampleMatrix[0][1] = true // Alice dead on Bob
        sampleMatrix[2][3] = true // Carol dead on Dave
        sampleMatrix[1][0] = true // Bob dead on Alice
        
        currentGame = Game(
            id: "sample-game",
            tournament: "Spring Championship 2024",
            players: samplePlayers,
            deadnessMatrix: sampleMatrix,
            currentStriker: 0,
            hoopProgression: [2, 1, 0, 3],
            timestamp: Date().addingTimeInterval(-1800), // Started 30 minutes ago
            status: .active
        )
        
        connectionStatus = .connected
    }
    
    func simulateGameUpdate() {
        guard var game = currentGame else { return }
        
        // Simulate some game changes for testing
        game.currentStriker = (game.currentStriker + 1) % game.players.count
        game.timestamp = Date()
        
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