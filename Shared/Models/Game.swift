import Foundation

public struct Game: Codable, Identifiable {
    public let id: String
    public var tournament: String?
    public var players: [Player]
    public var deadnessMatrix: [[Bool]]
    public var currentStriker: Int
    public var hoopProgression: [Int]
    public var timestamp: Date
    public var status: GameStatus
    public var creatorUid: String?

    public init(id: String, tournament: String? = nil, players: [Player], deadnessMatrix: [[Bool]], currentStriker: Int, hoopProgression: [Int], timestamp: Date, status: GameStatus, creatorUid: String? = nil) {
        self.id = id
        self.tournament = tournament
        self.players = players
        self.deadnessMatrix = deadnessMatrix
        self.currentStriker = currentStriker
        self.hoopProgression = hoopProgression
        self.timestamp = timestamp
        self.status = status
        self.creatorUid = creatorUid
    }

    // Convenience initializer for new games
    public init(players: [Player], tournament: String? = nil, creatorUid: String? = nil) {
        self.id = UUID().uuidString
        self.tournament = tournament
        self.players = players
        self.deadnessMatrix = Array(repeating: Array(repeating: false, count: players.count), count: players.count)
        self.currentStriker = 0
        self.hoopProgression = Array(repeating: 0, count: players.count)
        self.timestamp = Date()
        self.status = .active
        self.creatorUid = creatorUid
    }
}

public extension Game {
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