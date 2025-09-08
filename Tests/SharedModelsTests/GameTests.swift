import XCTest
@testable import SharedModels

final class GameTests: XCTestCase {
    var testPlayers: [Player]!
    var testGame: Game!
    
    override func setUp() {
        super.setUp()
        testPlayers = [
            Player(name: "Alice", ballColor: .blue),
            Player(name: "Bob", ballColor: .red),
            Player(name: "Carol", ballColor: .black),
            Player(name: "Dave", ballColor: .yellow)
        ]
        testGame = Game(players: testPlayers, tournament: "Test Tournament")
    }
    
    override func tearDown() {
        testPlayers = nil
        testGame = nil
        super.tearDown()
    }
    
    func testGameInitialization() {
        XCTAssertEqual(testGame.players.count, 4)
        XCTAssertEqual(testGame.currentStriker, 0)
        XCTAssertEqual(testGame.status, .active)
        XCTAssertEqual(testGame.tournament, "Test Tournament")
        XCTAssertEqual(testGame.deadnessMatrix.count, 4)
        XCTAssertEqual(testGame.deadnessMatrix[0].count, 4)
        
        // Check that deadness matrix is initialized to false
        for row in testGame.deadnessMatrix {
            for cell in row {
                XCTAssertFalse(cell)
            }
        }
    }
    
    func testCurrentPlayer() {
        XCTAssertEqual(testGame.currentPlayer.name, "Alice")
        XCTAssertEqual(testGame.currentPlayer.ballColor, .blue)
    }
    
    func testAdvanceStriker() {
        testGame.advanceStriker()
        XCTAssertEqual(testGame.currentStriker, 1)
        XCTAssertEqual(testGame.currentPlayer.name, "Bob")
        
        // Test wraparound
        testGame.currentStriker = 3
        testGame.advanceStriker()
        XCTAssertEqual(testGame.currentStriker, 0)
        XCTAssertEqual(testGame.currentPlayer.name, "Alice")
    }
    
    func testSetDeadness() {
        XCTAssertFalse(testGame.isPlayerDead(0, on: 1))
        
        testGame.setDeadness(from: 0, to: 1, isDead: true)
        XCTAssertTrue(testGame.isPlayerDead(0, on: 1))
        
        testGame.setDeadness(from: 0, to: 1, isDead: false)
        XCTAssertFalse(testGame.isPlayerDead(0, on: 1))
    }
    
    func testSetDeadnessInvalidIndices() {
        // Test same player (should not set deadness)
        testGame.setDeadness(from: 0, to: 0, isDead: true)
        XCTAssertFalse(testGame.isPlayerDead(0, on: 0))
        
        // Test out of bounds
        testGame.setDeadness(from: 0, to: 5, isDead: true)
        XCTAssertFalse(testGame.isPlayerDead(0, on: 5))
    }
    
    func testClearAllDeadnessFor() {
        // Set some deadness
        testGame.setDeadness(from: 0, to: 1, isDead: true)
        testGame.setDeadness(from: 0, to: 2, isDead: true)
        testGame.setDeadness(from: 1, to: 0, isDead: true)
        testGame.setDeadness(from: 2, to: 0, isDead: true)
        
        // Clear deadness for player 0
        testGame.clearAllDeadnessFor(playerIndex: 0)
        
        // Check that player 0 has no deadness
        XCTAssertFalse(testGame.isPlayerDead(0, on: 1))
        XCTAssertFalse(testGame.isPlayerDead(0, on: 2))
        XCTAssertFalse(testGame.isPlayerDead(1, on: 0))
        XCTAssertFalse(testGame.isPlayerDead(2, on: 0))
    }
    
    func testRunHoop() {
        XCTAssertEqual(testGame.players[0].hoopsRun, 0)
        XCTAssertEqual(testGame.hoopProgression[0], 0)
        
        testGame.runHoop(for: 0)
        XCTAssertEqual(testGame.players[0].hoopsRun, 1)
        XCTAssertEqual(testGame.hoopProgression[0], 1)
    }
    
    func testGameCompletion() {
        XCTAssertFalse(testGame.isGameComplete)
        
        // Run all hoops for player 0 (13 hoops total)
        for _ in 0..<13 {
            testGame.runHoop(for: 0)
        }
        
        XCTAssertTrue(testGame.isGameComplete)
        XCTAssertEqual(testGame.status, .completed)
    }
    
    func testGameCodable() {
        // Set up some game state
        testGame.setDeadness(from: 0, to: 1, isDead: true)
        testGame.runHoop(for: 0)
        testGame.advanceStriker()
        
        // Encode and decode
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        do {
            let data = try encoder.encode(testGame)
            let decodedGame = try decoder.decode(Game.self, from: data)
            
            XCTAssertEqual(testGame.id, decodedGame.id)
            XCTAssertEqual(testGame.tournament, decodedGame.tournament)
            XCTAssertEqual(testGame.players.count, decodedGame.players.count)
            XCTAssertEqual(testGame.currentStriker, decodedGame.currentStriker)
            XCTAssertEqual(testGame.status, decodedGame.status)
            XCTAssertEqual(testGame.deadnessMatrix, decodedGame.deadnessMatrix)
            XCTAssertEqual(testGame.hoopProgression, decodedGame.hoopProgression)
            
            // Test specific game state
            XCTAssertTrue(decodedGame.isPlayerDead(0, on: 1))
            XCTAssertEqual(decodedGame.players[0].hoopsRun, 1)
            XCTAssertEqual(decodedGame.currentStriker, 1)
            
        } catch {
            XCTFail("Failed to encode/decode game: \(error)")
        }
    }
}