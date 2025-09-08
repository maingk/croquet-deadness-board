import Foundation
import SwiftUI

struct Player: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    let ballColor: BallColor
    
    init(id: String = UUID().uuidString, name: String, ballColor: BallColor) {
        self.id = id
        self.name = name
        self.ballColor = ballColor
    }
}

extension Player {
    var displayName: String {
        name.isEmpty ? ballColor.rawValue : name
    }
}