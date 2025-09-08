import Foundation
import Combine

protocol FirebaseGameService {
    func updateGame(_ game: Game?)
    func startListening(completion: @escaping (Game?) -> Void)
    func stopListening()
    func createNewGame(_ game: Game) async throws
    func joinGame(gameId: String) async throws -> Game?
    func deleteGame(gameId: String) async throws
}

class FirebaseGameServiceImpl: FirebaseGameService, ObservableObject {
    @Published var isConnected: Bool = false
    @Published var currentError: Error?
    
    private var gameListener: Any?
    private var currentGameId: String?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupFirebase()
    }
    
    deinit {
        stopListening()
    }
    
    // MARK: - Firebase Setup
    
    private func setupFirebase() {
        // Firebase initialization will be done here
        // This is a placeholder for the actual Firebase implementation
        
        // For now, simulate connection
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isConnected = true
        }
    }
    
    // MARK: - Game Operations
    
    func createNewGame(_ game: Game) async throws {
        // Implementation for creating a new game in Firebase
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
        
        // Store the game in Firebase Realtime Database
        // await firebaseRef.child("games").child(game.id).setValue(game.firebaseData)
        
        currentGameId = game.id
    }
    
    func joinGame(gameId: String) async throws -> Game? {
        // Implementation for joining an existing game
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
        
        // Fetch game from Firebase
        // let snapshot = await firebaseRef.child("games").child(gameId).getData()
        // return Game.fromFirebaseData(snapshot.value)
        
        currentGameId = gameId
        return nil // Placeholder
    }
    
    func updateGame(_ game: Game?) {
        guard let game = game, 
              let gameId = currentGameId else { return }
        
        // Update game in Firebase Realtime Database
        // firebaseRef.child("games").child(gameId).setValue(game.firebaseData)
        
        // For testing, we'll simulate the update
        print("Updating game \(gameId) in Firebase")
    }
    
    func deleteGame(gameId: String) async throws {
        // Implementation for deleting a game
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
        
        // Delete from Firebase
        // await firebaseRef.child("games").child(gameId).removeValue()
        
        if currentGameId == gameId {
            currentGameId = nil
        }
    }
    
    // MARK: - Real-time Listening
    
    func startListening(completion: @escaping (Game?) -> Void) {
        guard let gameId = currentGameId else {
            completion(nil)
            return
        }
        
        // Start listening for changes in Firebase
        // gameListener = firebaseRef.child("games").child(gameId).observe(.value) { snapshot in
        //     if let gameData = snapshot.value {
        //         let game = Game.fromFirebaseData(gameData)
        //         completion(game)
        //     } else {
        //         completion(nil)
        //     }
        // }
        
        // For testing, simulate listening with sample data
        print("Started listening for game updates: \(gameId)")
    }
    
    func stopListening() {
        guard let listener = gameListener else { return }
        
        // Remove Firebase listener
        // firebaseRef.removeObserver(withHandle: listener)
        
        gameListener = nil
        print("Stopped listening for game updates")
    }
    
    // MARK: - Connection Management
    
    private func handleConnectionStateChange(_ isConnected: Bool) {
        DispatchQueue.main.async {
            self.isConnected = isConnected
            if !isConnected {
                self.currentError = FirebaseServiceError.connectionLost
            } else {
                self.currentError = nil
            }
        }
    }
    
    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.currentError = error
        }
    }
}

// MARK: - Service Errors

enum FirebaseServiceError: LocalizedError {
    case notInitialized
    case connectionLost
    case gameNotFound
    case invalidGameData
    case unauthorized
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .notInitialized:
            return "Firebase service not initialized"
        case .connectionLost:
            return "Connection to Firebase lost"
        case .gameNotFound:
            return "Game not found"
        case .invalidGameData:
            return "Invalid game data received"
        case .unauthorized:
            return "Not authorized to access this game"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Game Firebase Extensions

extension Game {
    var firebaseData: [String: Any] {
        return [
            "id": id,
            "tournament": tournament ?? "",
            "players": players.map { $0.firebaseData },
            "deadnessMatrix": deadnessMatrix,
            "currentStriker": currentStriker,
            "hoopProgression": hoopProgression,
            "timestamp": timestamp.timeIntervalSince1970,
            "status": status.rawValue
        ]
    }
    
    static func fromFirebaseData(_ data: [String: Any]) -> Game? {
        guard let id = data["id"] as? String,
              let playersData = data["players"] as? [[String: Any]],
              let deadnessMatrix = data["deadnessMatrix"] as? [[Bool]],
              let currentStriker = data["currentStriker"] as? Int,
              let hoopProgression = data["hoopProgression"] as? [Int],
              let timestampInterval = data["timestamp"] as? TimeInterval,
              let statusRaw = data["status"] as? String,
              let status = GameStatus(rawValue: statusRaw) else {
            return nil
        }
        
        let players = playersData.compactMap { Player.fromFirebaseData($0) }
        guard players.count == playersData.count else { return nil }
        
        let tournament = (data["tournament"] as? String)?.isEmpty == false ? data["tournament"] as? String : nil
        
        return Game(
            id: id,
            tournament: tournament,
            players: players,
            deadnessMatrix: deadnessMatrix,
            currentStriker: currentStriker,
            hoopProgression: hoopProgression,
            timestamp: Date(timeIntervalSince1970: timestampInterval),
            status: status
        )
    }
}

extension Player {
    var firebaseData: [String: Any] {
        return [
            "id": id,
            "name": name,
            "ballColor": ballColor.rawValue,
            "hoopsRun": hoopsRun,
            "score": score
        ]
    }
    
    static func fromFirebaseData(_ data: [String: Any]) -> Player? {
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let ballColorRaw = data["ballColor"] as? String,
              let ballColor = BallColor(rawValue: ballColorRaw),
              let hoopsRun = data["hoopsRun"] as? Int,
              let score = data["score"] as? Int else {
            return nil
        }
        
        return Player(
            id: id,
            name: name,
            ballColor: ballColor,
            hoopsRun: hoopsRun,
            score: score
        )
    }
}