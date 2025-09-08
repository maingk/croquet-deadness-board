import Foundation
import SwiftUI

enum BallColor: String, CaseIterable, Codable {
    case blue = "Blue"
    case red = "Red"
    case black = "Black"
    case yellow = "Yellow"
    
    var color: Color {
        switch self {
        case .blue:
            return .blue
        case .red:
            return .red
        case .black:
            return .black
        case .yellow:
            return .yellow
        }
    }
    
    var contrastingTextColor: Color {
        switch self {
        case .blue, .red, .black:
            return .white
        case .yellow:
            return .black
        }
    }
    
    var darkModeColor: Color {
        switch self {
        case .blue:
            return Color(red: 0.2, green: 0.5, blue: 1.0)
        case .red:
            return Color(red: 1.0, green: 0.3, blue: 0.3)
        case .black:
            return Color(red: 0.3, green: 0.3, blue: 0.3)
        case .yellow:
            return Color(red: 1.0, green: 0.9, blue: 0.2)
        }
    }
    
    /// Returns the color appropriate for the current color scheme
    func adaptiveColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return darkModeColor
        case .light:
            return color
        @unknown default:
            return color
        }
    }
}

extension BallColor: Comparable {
    static func < (lhs: BallColor, rhs: BallColor) -> Bool {
        let order: [BallColor] = [.blue, .red, .black, .yellow]
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}