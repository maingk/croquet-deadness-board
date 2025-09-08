import Foundation

enum GameStatus: String, Codable, CaseIterable {
    case setup = "setup"
    case active = "active"
    case paused = "paused"
    case completed = "completed"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .setup:
            return "Setting Up"
        case .active:
            return "Active"
        case .paused:
            return "Paused"
        case .completed:
            return "Completed"
        case .cancelled:
            return "Cancelled"
        }
    }
    
    var isPlayable: Bool {
        switch self {
        case .setup, .active:
            return true
        case .paused, .completed, .cancelled:
            return false
        }
    }
    
    var canModify: Bool {
        switch self {
        case .setup, .active, .paused:
            return true
        case .completed, .cancelled:
            return false
        }
    }
}