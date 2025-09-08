import Foundation

struct Game: Codable, Identifiable {
    let id: String
    var tournament: String?
    var players: [Player]
    var deadnessMatrix: [[Bool]]
    var timestamp: Date
    var status: GameStatus
    
    init(id: String, tournament: String? = nil, players: [Player], deadnessMatrix: [[Bool]], timestamp: Date, status: GameStatus) {
        self.id = id
        self.tournament = tournament
        self.players = players
        self.deadnessMatrix = deadnessMatrix
        self.timestamp = timestamp
        self.status = status
    }
    
    // Convenience initializer for new games
    init(players: [Player], tournament: String? = nil) {
        self.id = UUID().uuidString
        self.tournament = tournament
        self.players = players
        self.deadnessMatrix = Array(repeating: Array(repeating: false, count: players.count), count: players.count)
        self.timestamp = Date()
        self.status = .active
    }
}

extension Game {
    // Helper methods for deadness tracking
    
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
    
    mutating func clearAllDeadness() {
        deadnessMatrix = Array(repeating: Array(repeating: false, count: players.count), count: players.count)
        timestamp = Date()
    }
}