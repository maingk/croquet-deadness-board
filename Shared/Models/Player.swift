import Foundation
import SwiftUI

struct Player: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    let ballColor: BallColor
    var hoopsRun: Int
    var score: Int
    
    init(id: String = UUID().uuidString, name: String, ballColor: BallColor, hoopsRun: Int = 0, score: Int = 0) {
        self.id = id
        self.name = name
        self.ballColor = ballColor
        self.hoopsRun = hoopsRun
        self.score = score
    }
}

extension Player {
    var displayName: String {
        name.isEmpty ? ballColor.rawValue : name
    }
    
    var currentHoopName: String {
        switch hoopsRun {
        case 0...11:
            return "Hoop \(hoopsRun + 1)"
        case 12:
            return "Rover"
        case 13:
            return "Finished"
        default:
            return "Hoop 1"
        }
    }
    
    var isFinished: Bool {
        hoopsRun >= 13
    }
    
    var progressPercentage: Double {
        min(Double(hoopsRun) / 13.0, 1.0)
    }
}