import Foundation

/// Represents an action taken during a game for undo/redo functionality
struct GameAction: Codable, Identifiable {
    let id: String
    let type: ActionType
    let timestamp: Date
    let description: String
    let previousGameState: Game?
    
    init(type: ActionType, description: String, previousGameState: Game? = nil) {
        self.id = UUID().uuidString
        self.type = type
        self.timestamp = Date()
        self.description = description
        self.previousGameState = previousGameState
    }
    
    enum ActionType: String, Codable {
        case gameStart = "game_start"
        case deadnessToggle = "deadness_toggle"
        case strikerAdvance = "striker_advance"
        case hoopRun = "hoop_run"
        case clearDeadness = "clear_deadness"
        case clearAllDeadness = "clear_all_deadness"
        case gameEnd = "game_end"
        case gamePause = "game_pause"
        case gameResume = "game_resume"
        
        var displayName: String {
            switch self {
            case .gameStart:
                return "Game Started"
            case .deadnessToggle:
                return "Deadness Changed"
            case .strikerAdvance:
                return "Striker Advanced"
            case .hoopRun:
                return "Hoop Run"
            case .clearDeadness:
                return "Deadness Cleared"
            case .clearAllDeadness:
                return "All Deadness Cleared"
            case .gameEnd:
                return "Game Ended"
            case .gamePause:
                return "Game Paused"
            case .gameResume:
                return "Game Resumed"
            }
        }
        
        var isUndoable: Bool {
            switch self {
            case .gameStart, .gameEnd:
                return false
            case .deadnessToggle, .strikerAdvance, .hoopRun, .clearDeadness, .clearAllDeadness, .gamePause, .gameResume:
                return true
            }
        }
    }
}

extension GameAction {
    var canUndo: Bool {
        type.isUndoable && previousGameState != nil
    }
}