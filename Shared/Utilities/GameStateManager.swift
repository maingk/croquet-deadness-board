import Foundation
import Combine

/// Manages game state, including undo/redo functionality and local persistence
class GameStateManager: ObservableObject {
    @Published var currentGame: Game?
    @Published var gameHistory: [GameAction] = []
    @Published var canUndo: Bool = false
    @Published var canRedo: Bool = false
    
    private let maxHistorySize = 50
    private var redoStack: [GameAction] = []
    private let userDefaults = UserDefaults.standard
    
    private let gameStateKey = "current_game_state"
    private let gameHistoryKey = "game_history"
    
    init() {
        loadPersistedState()
        updateUndoRedoState()
    }
    
    // MARK: - Game State Management
    
    func startNewGame(_ game: Game) {
        let action = GameAction(
            type: .gameStart,
            description: "Started new game with \(game.players.count) players",
            previousGameState: currentGame
        )
        
        currentGame = game
        addAction(action)
        clearRedoStack()
        persistState()
    }
    
    func updateGameState(_ game: Game, action: GameAction) {
        currentGame = game
        addAction(action)
        clearRedoStack()
        persistState()
    }
    
    func endGame() {
        guard var game = currentGame else { return }
        
        let action = GameAction(
            type: .gameEnd,
            description: "Game ended",
            previousGameState: game
        )
        
        game.status = .completed
        currentGame = game
        addAction(action)
        persistState()
    }
    
    // MARK: - Undo/Redo Operations
    
    func undo() {
        guard canUndo,
              let lastAction = gameHistory.last,
              let previousState = lastAction.previousGameState else { return }
        
        // Move the current action to redo stack
        redoStack.append(gameHistory.removeLast())
        
        // Restore previous game state
        currentGame = previousState
        
        updateUndoRedoState()
        persistState()
    }
    
    func redo() {
        guard canRedo,
              let redoAction = redoStack.last else { return }
        
        // Move action back to history
        gameHistory.append(redoStack.removeLast())
        
        // Apply the action's resulting state
        if let nextState = redoAction.previousGameState {
            currentGame = nextState
        }
        
        updateUndoRedoState()
        persistState()
    }
    
    // MARK: - Game Actions
    
    func toggleDeadness(from: Int, to: Int) {
        guard var game = currentGame, from != to else { return }
        
        let wasDeadBefore = game.deadnessMatrix[from][to]
        let playerFrom = game.players[from].name
        let playerTo = game.players[to].name
        let description = wasDeadBefore ? 
            "Cleared deadness: \(playerFrom) no longer dead on \(playerTo)" :
            "Set deadness: \(playerFrom) now dead on \(playerTo)"
        
        let action = GameAction(
            type: .deadnessToggle,
            description: description,
            previousGameState: game
        )
        
        game.setDeadness(from: from, to: to, isDead: !wasDeadBefore)
        updateGameState(game, action: action)
    }
    
    func advanceStriker() {
        guard var game = currentGame else { return }
        
        let currentPlayerName = game.players[game.currentStriker].name
        let nextStrikerIndex = (game.currentStriker + 1) % game.players.count
        let nextPlayerName = game.players[nextStrikerIndex].name
        
        let action = GameAction(
            type: .strikerAdvance,
            description: "Striker changed from \(currentPlayerName) to \(nextPlayerName)",
            previousGameState: game
        )
        
        game.advanceStriker()
        updateGameState(game, action: action)
    }
    
    func runHoop(for playerIndex: Int) {
        guard var game = currentGame,
              playerIndex < game.players.count else { return }
        
        let player = game.players[playerIndex]
        let hoopName = player.currentHoopName
        
        let action = GameAction(
            type: .hoopRun,
            description: "\(player.name) ran \(hoopName)",
            previousGameState: game
        )
        
        game.runHoop(for: playerIndex)
        updateGameState(game, action: action)
    }
    
    func clearDeadness(for playerIndex: Int) {
        guard var game = currentGame,
              playerIndex < game.players.count else { return }
        
        let playerName = game.players[playerIndex].name
        
        let action = GameAction(
            type: .clearDeadness,
            description: "Cleared all deadness for \(playerName)",
            previousGameState: game
        )
        
        game.clearAllDeadnessFor(playerIndex: playerIndex)
        updateGameState(game, action: action)
    }
    
    func clearAllDeadness() {
        guard var game = currentGame else { return }
        
        let action = GameAction(
            type: .clearAllDeadness,
            description: "Cleared all deadness on the board",
            previousGameState: game
        )
        
        game.deadnessMatrix = Array(repeating: Array(repeating: false, count: game.players.count), count: game.players.count)
        game.timestamp = Date()
        updateGameState(game, action: action)
    }
    
    // MARK: - Private Methods
    
    private func addAction(_ action: GameAction) {
        gameHistory.append(action)
        
        // Limit history size
        if gameHistory.count > maxHistorySize {
            gameHistory.removeFirst(gameHistory.count - maxHistorySize)
        }
        
        updateUndoRedoState()
    }
    
    private func clearRedoStack() {
        redoStack.removeAll()
        updateUndoRedoState()
    }
    
    private func updateUndoRedoState() {
        canUndo = !gameHistory.isEmpty && gameHistory.last?.canUndo == true
        canRedo = !redoStack.isEmpty
    }
    
    // MARK: - Persistence
    
    private func persistState() {
        if let game = currentGame,
           let gameData = try? JSONEncoder().encode(game) {
            userDefaults.set(gameData, forKey: gameStateKey)
        }
        
        if let historyData = try? JSONEncoder().encode(gameHistory) {
            userDefaults.set(historyData, forKey: gameHistoryKey)
        }
    }
    
    private func loadPersistedState() {
        // Load current game
        if let gameData = userDefaults.data(forKey: gameStateKey),
           let game = try? JSONDecoder().decode(Game.self, from: gameData) {
            currentGame = game
        }
        
        // Load game history
        if let historyData = userDefaults.data(forKey: gameHistoryKey),
           let history = try? JSONDecoder().decode([GameAction].self, from: historyData) {
            gameHistory = history
        }
    }
    
    func clearPersistedState() {
        userDefaults.removeObject(forKey: gameStateKey)
        userDefaults.removeObject(forKey: gameHistoryKey)
        currentGame = nil
        gameHistory.removeAll()
        redoStack.removeAll()
        updateUndoRedoState()
    }
}

// MARK: - Convenience Extensions

extension GameStateManager {
    var lastActionDescription: String? {
        gameHistory.last?.description
    }
    
    var gameStartTime: Date? {
        gameHistory.first { $0.type == .gameStart }?.timestamp
    }
    
    var totalGameDuration: TimeInterval? {
        guard let startTime = gameStartTime else { return nil }
        return Date().timeIntervalSince(startTime)
    }
    
    var actionCount: Int {
        gameHistory.count
    }
}