import Foundation
import Combine
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth

public protocol FirebaseGameService {
    func signInAnonymously() async throws
    var currentUserId: String? { get }
    func updateGame(_ game: Game?)
    func startListening(completion: @escaping (Game?) -> Void)
    func stopListening()
    func createNewGame(_ game: Game) async throws
    func joinGame(gameId: String) async throws -> Game?
    func deleteGame(gameId: String) async throws
    func setCurrentGame(gameId: String?)
}

class FirebaseGameServiceImpl: FirebaseGameService, ObservableObject {
    @Published var isConnected: Bool = false
    @Published var currentError: Error?
    
    private var gameListener: DatabaseHandle?
    private var currentGameId: String?
    private var cancellables = Set<AnyCancellable>()
    private let database: DatabaseReference
    
    init() {
        // Initialize Firebase Database reference
        self.database = Database.database().reference()
        setupFirebase()
    }
    
    deinit {
        stopListening()
    }
    
    // MARK: - Authentication

    func signInAnonymously() async throws {
        try await Auth.auth().signInAnonymously()
    }

    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    // MARK: - Firebase Setup
    
    private func setupFirebase() {
        // Monitor connection state
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value) { [weak self] snapshot in
            guard let self = self else { return }
            
            if let connected = snapshot.value as? Bool, connected {
                self.handleConnectionStateChange(true)
            } else {
                self.handleConnectionStateChange(false)
            }
        }
    }
    
    // MARK: - Game Operations
    
    func createNewGame(_ game: Game) async throws {
        do {
            try await database.child("games").child(game.id).setValue(game.firebaseData)
            currentGameId = game.id
        } catch {
            throw FirebaseServiceError.networkError(error)
        }
    }
    
    func joinGame(gameId: String) async throws -> Game? {
        do {
            let snapshot = try await database.child("games").child(gameId).getData()
            
            guard let gameData = snapshot.value as? [String: Any] else {
                throw FirebaseServiceError.gameNotFound
            }
            
            guard let game = Game.fromFirebaseData(gameData) else {
                throw FirebaseServiceError.invalidGameData
            }
            
            currentGameId = gameId
            return game
            
        } catch {
            if error is FirebaseServiceError {
                throw error
            } else {
                throw FirebaseServiceError.networkError(error)
            }
        }
    }
    
    func updateGame(_ game: Game?) {
        guard let game = game, 
              let gameId = currentGameId else { return }
        
        // Update game in Firebase Realtime Database
        database.child("games").child(gameId).setValue(game.firebaseData) { [weak self] error, _ in
            if let error = error {
                self?.handleError(FirebaseServiceError.networkError(error))
            }
        }
    }
    
    func deleteGame(gameId: String) async throws {
        do {
            try await database.child("games").child(gameId).removeValue()
            
            if currentGameId == gameId {
                currentGameId = nil
            }
        } catch {
            throw FirebaseServiceError.networkError(error)
        }
    }
    
    // MARK: - Real-time Listening
    
    func startListening(completion: @escaping (Game?) -> Void) {
        guard let gameId = currentGameId else {
            completion(nil)
            return
        }
        
        // Stop any existing listener first
        stopListening()
        
        // Start listening for real-time changes in Firebase
        gameListener = database.child("games").child(gameId).observe(.value) { [weak self] snapshot in
            guard let self = self else { return }
            
            if let gameData = snapshot.value as? [String: Any] {
                let game = Game.fromFirebaseData(gameData)
                DispatchQueue.main.async {
                    completion(game)
                }
            } else {
                // Game was deleted or doesn't exist
                DispatchQueue.main.async {
                    completion(nil)
                    self.currentGameId = nil
                }
            }
        } withCancel: { [weak self] error in
            self?.handleError(FirebaseServiceError.networkError(error))
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func stopListening() {
        guard let listener = gameListener,
              let gameId = currentGameId else { return }
        
        // Remove Firebase listener
        database.child("games").child(gameId).removeObserver(withHandle: listener)
        gameListener = nil
    }
    
    func setCurrentGame(gameId: String?) {
        stopListening() // Stop listening to previous game
        currentGameId = gameId
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
        var data: [String: Any] = [
            "id": id,
            "tournament": tournament ?? "",
            "players": players.map { $0.firebaseData },
            "deadnessMatrix": deadnessMatrix,
            "currentStriker": currentStriker,
            "hoopProgression": hoopProgression,
            "timestamp": timestamp.timeIntervalSince1970,
            "startTime": startTime.timeIntervalSince1970,
            "status": status.rawValue
        ]
        if let creatorUid = creatorUid {
            data["creatorUid"] = creatorUid
        }
        return data
    }
    
    static func fromFirebaseData(_ data: [String: Any]) -> Game? {
        guard let id = data["id"] as? String,
              let playersData = data["players"] as? [[String: Any]],
              let deadnessMatrix = data["deadnessMatrix"] as? [[Bool]],
              let timestampInterval = data["timestamp"] as? TimeInterval,
              let statusRaw = data["status"] as? String,
              let status = GameStatus(rawValue: statusRaw) else {
            return nil
        }
        
        let players = playersData.compactMap { Player.fromFirebaseData($0) }
        guard players.count == playersData.count else { return nil }
        
        let tournament = (data["tournament"] as? String)?.isEmpty == false ? data["tournament"] as? String : nil
        
        let currentStriker = data["currentStriker"] as? Int ?? 0
        let hoopProgression = data["hoopProgression"] as? [Int] ?? Array(repeating: 0, count: players.count)
        let startTimeInterval = data["startTime"] as? TimeInterval
        let creatorUid = data["creatorUid"] as? String

        return Game(
            id: id,
            tournament: tournament,
            players: players,
            deadnessMatrix: deadnessMatrix,
            currentStriker: currentStriker,
            hoopProgression: hoopProgression,
            timestamp: Date(timeIntervalSince1970: timestampInterval),
            startTime: startTimeInterval.map { Date(timeIntervalSince1970: $0) },
            status: status,
            creatorUid: creatorUid
        )
    }
}

extension Player {
    var firebaseData: [String: Any] {
        return [
            "id": id,
            "name": name,
            "ballColor": ballColor.rawValue
        ]
    }
    
    static func fromFirebaseData(_ data: [String: Any]) -> Player? {
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let ballColorRaw = data["ballColor"] as? String,
              let ballColor = BallColor(rawValue: ballColorRaw) else {
            return nil
        }
        
        return Player(
            id: id,
            name: name,
            ballColor: ballColor
        )
    }
}