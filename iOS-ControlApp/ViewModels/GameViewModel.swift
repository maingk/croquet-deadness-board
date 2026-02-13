import SwiftUI
import Combine
import FirebaseAuth

class GameViewModel: ObservableObject {
    @Published var currentGame: Game?
    @Published var canUndo: Bool = false
    
    private var gameHistory: [Game] = []
    private var cancellables = Set<AnyCancellable>()
    
    // Firebase service will be injected later
    private var firebaseService: FirebaseGameService?
    
    init() {
        // Initialize with sample game for preview purposes
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            startSampleGame()
        }
        #endif
    }
    
    func startNewGame(players: [Player], format: GameFormat, tournamentInfo: String?) {
        let newGame = Game(
            id: UUID().uuidString,
            tournament: tournamentInfo,
            players: players,
            deadnessMatrix: Array(repeating: Array(repeating: false, count: 4), count: 4),
            currentStriker: 0,
            hoopProgression: Array(repeating: 0, count: 4),
            timestamp: Date(),
            status: .active,
            creatorUid: Auth.auth().currentUser?.uid
        )
        
        saveCurrentState()
        currentGame = newGame
        syncToFirebase()
    }
    
    func toggleDeadness(from: Int, to: Int) {
        guard var game = currentGame, from != to else { return }
        
        saveCurrentState()
        game.deadnessMatrix[from][to].toggle()
        game.timestamp = Date()
        currentGame = game
        syncToFirebase()
    }
    
    func nextStriker() {
        guard var game = currentGame else { return }
        
        saveCurrentState()
        game.currentStriker = (game.currentStriker + 1) % game.players.count
        game.timestamp = Date()
        currentGame = game
        syncToFirebase()
    }
    
    func runHoop(for playerIndex: Int) {
        guard var game = currentGame, playerIndex < game.players.count else { return }
        
        saveCurrentState()
        game.players[playerIndex].hoopsRun += 1
        game.hoopProgression[playerIndex] = game.players[playerIndex].hoopsRun
        game.timestamp = Date()
        currentGame = game
        syncToFirebase()
    }
    
    func clearAllDeadness(for playerIndex: Int) {
        guard var game = currentGame, playerIndex < game.players.count else { return }
        
        saveCurrentState()
        
        // Clear deadness for this player (both directions)
        for i in 0..<4 {
            game.deadnessMatrix[playerIndex][i] = false
            game.deadnessMatrix[i][playerIndex] = false
        }
        
        game.timestamp = Date()
        currentGame = game
        syncToFirebase()
    }
    
    func clearAllDeadness() {
        guard var game = currentGame else { return }
        
        saveCurrentState()
        game.deadnessMatrix = Array(repeating: Array(repeating: false, count: 4), count: 4)
        game.timestamp = Date()
        currentGame = game
        syncToFirebase()
    }
    
    func undoLastAction() {
        guard !gameHistory.isEmpty else { return }
        
        currentGame = gameHistory.removeLast()
        canUndo = !gameHistory.isEmpty
        syncToFirebase()
    }
    
    func endGame() {
        guard var game = currentGame else { return }
        
        game.status = .completed
        game.timestamp = Date()
        currentGame = game
        syncToFirebase()
        
        // Clear after a delay to allow viewing final state
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.currentGame = nil
            self.gameHistory.removeAll()
            self.canUndo = false
        }
    }
    
    private func saveCurrentState() {
        guard let game = currentGame else { return }
        
        gameHistory.append(game)
        
        // Keep only last 10 states to prevent memory issues
        if gameHistory.count > 10 {
            gameHistory.removeFirst()
        }
        
        canUndo = !gameHistory.isEmpty
    }
    
    private func syncToFirebase() {
        // Firebase sync will be implemented when service is available
        firebaseService?.updateGame(currentGame)
    }
    
    // MARK: - Debug/Preview helpers
    
    #if DEBUG
    private func startSampleGame() {
        let samplePlayers = [
            Player(name: "Alice", ballColor: .blue, hoopsRun: 2, score: 0),
            Player(name: "Bob", ballColor: .red, hoopsRun: 1, score: 0),
            Player(name: "Carol", ballColor: .black, hoopsRun: 0, score: 0),
            Player(name: "Dave", ballColor: .yellow, hoopsRun: 3, score: 0)
        ]
        
        var sampleMatrix = Array(repeating: Array(repeating: false, count: 4), count: 4)
        sampleMatrix[0][1] = true // Alice dead on Bob
        sampleMatrix[2][3] = true // Carol dead on Dave
        
        currentGame = Game(
            id: "sample-game",
            tournament: "Sample Tournament",
            players: samplePlayers,
            deadnessMatrix: sampleMatrix,
            currentStriker: 0,
            hoopProgression: [2, 1, 0, 3],
            timestamp: Date(),
            status: .active
        )
    }
    #endif
}