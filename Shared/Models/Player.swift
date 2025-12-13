import Foundation
import SwiftUI

public struct Player: Codable, Identifiable, Hashable {
    public let id: String
    public var name: String
    public let ballColor: BallColor
    public var hoopsRun: Int
    public var score: Int

    public init(id: String = UUID().uuidString, name: String, ballColor: BallColor, hoopsRun: Int = 0, score: Int = 0) {
        self.id = id
        self.name = name
        self.ballColor = ballColor
        self.hoopsRun = hoopsRun
        self.score = score
    }
}

public extension Player {
    var displayName: String {
        name.isEmpty ? ballColor.rawValue : name
    }
}