import SwiftUI
import Combine
import SharedModels
import SharedServices

class GameViewModel: ObservableObject {
    @Published var currentGame: Game?
    @Published var canUndo: Bool = false
    @Published var isConnected: Bool = false
    @Published var currentError: Error?
    
    private var gameHistory: [Game] = []
    private var cancellables = Set<AnyCancellable>()
    private let firebaseService: FirebaseGameService
    
    init(firebaseService: FirebaseGameService = FirebaseGameServiceImpl()) {
        self.firebaseService = firebaseService
        setupFirebaseObservation()
        
        // Initialize with sample game for preview purposes
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            startSampleGame()
        }
        #endif
    }
    
    private func setupFirebaseObservation() {
        // Observe Firebase service connection state
        if let firebaseServiceImpl = firebaseService as? FirebaseGameServiceImpl {
            firebaseServiceImpl.$isConnected
                .assign(to: \.isConnected, on: self)
                .store(in: &cancellables)
            
            firebaseServiceImpl.$currentError
                .assign(to: \.currentError, on: self)
                .store(in: &cancellables)
        }
    }
    
    func startNewGame(players: [Player], tournamentInfo: String?) {
        let newGame = Game(players: players, tournament: tournamentInfo)
        
        saveCurrentState()
        currentGame = newGame
        
        // Create game in Firebase and start listening
        Task {
            do {
                try await firebaseService.createNewGame(newGame)
                await startListeningForUpdates()
            } catch {
                await MainActor.run {
                    self.currentError = error
                }
            }
        }
    }
    
    func joinGame(gameId: String) {
        Task {
            do {
                let game = try await firebaseService.joinGame(gameId: gameId)
                await MainActor.run {
                    self.currentGame = game
                }
                await startListeningForUpdates()
            } catch {
                await MainActor.run {
                    self.currentError = error
                }
            }
        }
    }
    
    @MainActor
    private func startListeningForUpdates() {
        firebaseService.startListening { [weak self] updatedGame in
            self?.currentGame = updatedGame
        }
    }
    
    deinit {
        firebaseService.stopListening()
    }
    
    func toggleDeadness(from: Int, to: Int) {
        guard var game = currentGame, from != to else { return }
        
        saveCurrentState()
        game.deadnessMatrix[from][to].toggle()
        game.timestamp = Date()
        currentGame = game
        syncToFirebase()
    }
    
    
    func clearAllDeadness(for playerIndex: Int) {
        guard var game = currentGame, playerIndex < game.players.count else { return }
        
        saveCurrentState()
        game.clearAllDeadnessFor(playerIndex: playerIndex)
        currentGame = game
        syncToFirebase()
    }
    
    func clearAllDeadness() {
        guard var game = currentGame else { return }
        
        saveCurrentState()
        game.clearAllDeadness()
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
        firebaseService.updateGame(currentGame)
    }
    
    // MARK: - Debug/Preview helpers
    
    #if DEBUG
    private func startSampleGame() {
        let samplePlayers = [
            Player(name: "Alice", ballColor: .blue),
            Player(name: "Bob", ballColor: .red),
            Player(name: "Carol", ballColor: .black),
            Player(name: "Dave", ballColor: .yellow)
        ]
        
        var sampleGame = Game(players: samplePlayers, tournament: "Sample Tournament")
        
        // Set some sample deadness
        sampleGame.setDeadness(from: 0, to: 1, isDead: true) // Alice dead on Bob
        sampleGame.setDeadness(from: 2, to: 3, isDead: true) // Carol dead on Dave
        
        currentGame = sampleGame
    }
    #endif
}