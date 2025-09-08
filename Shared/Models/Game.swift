import Foundation

struct Game: Codable, Identifiable {
    let id: String
    var tournament: String?
    var players: [Player]
    var deadnessMatrix: [[Bool]]
    var currentStriker: Int
    var hoopProgression: [Int]
    var timestamp: Date
    var status: GameStatus
    
    init(id: String, tournament: String? = nil, players: [Player], deadnessMatrix: [[Bool]], currentStriker: Int, hoopProgression: [Int], timestamp: Date, status: GameStatus) {
        self.id = id
        self.tournament = tournament
        self.players = players
        self.deadnessMatrix = deadnessMatrix
        self.currentStriker = currentStriker
        self.hoopProgression = hoopProgression
        self.timestamp = timestamp
        self.status = status
    }
    
    // Convenience initializer for new games
    init(players: [Player], tournament: String? = nil) {
        self.id = UUID().uuidString
        self.tournament = tournament
        self.players = players
        self.deadnessMatrix = Array(repeating: Array(repeating: false, count: players.count), count: players.count)
        self.currentStriker = 0
        self.hoopProgression = Array(repeating: 0, count: players.count)
        self.timestamp = Date()
        self.status = .active
    }
}

extension Game {
    // Helper methods for game logic
    
    var currentPlayer: Player {
        players[currentStriker]
    }
    
    var isGameComplete: Bool {
        players.contains { $0.hoopsRun >= 13 } // Completed all hoops + peg out
    }
    
    func isPlayerDead(_ playerIndex: Int, on targetIndex: Int) -> Bool {
        guard playerIndex != targetIndex,
              playerIndex < deadnessMatrix.count,
              targetIndex < deadnessMatrix[playerIndex].count else {
            return false
        }
        return deadnessMatrix[playerIndex][targetIndex]
    }
    
    mutating func setDeadness(from playerIndex: Int, to targetIndex: Int, isDead: Bool) {
        guard playerIndex != targetIndex,
              playerIndex < deadnessMatrix.count,
              targetIndex < deadnessMatrix[playerIndex].count else {
            return
        }
        deadnessMatrix[playerIndex][targetIndex] = isDead
        timestamp = Date()
    }
    
    mutating func clearAllDeadnessFor(playerIndex: Int) {
        guard playerIndex < deadnessMatrix.count else { return }
        
        for i in 0..<deadnessMatrix.count {
            deadnessMatrix[playerIndex][i] = false
            deadnessMatrix[i][playerIndex] = false
        }
        timestamp = Date()
    }
    
    mutating func advanceStriker() {
        currentStriker = (currentStriker + 1) % players.count
        timestamp = Date()
    }
    
    mutating func runHoop(for playerIndex: Int) {
        guard playerIndex < players.count else { return }
        
        players[playerIndex].hoopsRun += 1
        hoopProgression[playerIndex] = players[playerIndex].hoopsRun
        timestamp = Date()
        
        // Check if game is complete
        if isGameComplete {
            status = .completed
        }
    }
}