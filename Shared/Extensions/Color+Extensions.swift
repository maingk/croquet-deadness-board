import SwiftUI

extension Color {
    // MARK: - Croquet Theme Colors
    
    static let croquetGreen = Color(red: 0.2, green: 0.6, blue: 0.2)
    static let croquetFieldGreen = Color(red: 0.15, green: 0.5, blue: 0.15)
    static let croquetDeadnessRed = Color(red: 0.8, green: 0.2, blue: 0.2)
    static let croquetAliveGreen = Color(red: 0.2, green: 0.8, blue: 0.2)
    
    // MARK: - High Contrast Colors for Outdoor Use
    
    static let highContrastBlue = Color(red: 0.0, green: 0.3, blue: 1.0)
    static let highContrastRed = Color(red: 1.0, green: 0.0, blue: 0.0)
    static let highContrastYellow = Color(red: 1.0, green: 0.9, blue: 0.0)
    static let highContrastBlack = Color(red: 0.1, green: 0.1, blue: 0.1)
    
    // MARK: - Utility Functions
    
    /// Creates a color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Returns the hex string representation of the color
    var hexString: String {
        guard let components = cgColor?.components else { return "#000000" }
        
        let r = Float(components[0])
        let g = Float(components.count > 1 ? components[1] : 0)
        let b = Float(components.count > 2 ? components[2] : 0)
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
    
    /// Returns a color with adjusted brightness
    func adjustBrightness(_ factor: Double) -> Color {
        guard let components = cgColor?.components else { return self }
        
        let r = min(1.0, max(0.0, Double(components[0]) * factor))
        let g = min(1.0, max(0.0, Double(components.count > 1 ? components[1] : 0) * factor))
        let b = min(1.0, max(0.0, Double(components.count > 2 ? components[2] : 0) * factor))
        let a = Double(components.count > 3 ? components[3] : 1)
        
        return Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    /// Returns a color with better contrast for the given background
    func withContrast(for background: Color) -> Color {
        // Simple contrast adjustment - in a real app, you'd use proper color theory
        let backgroundLuminance = background.luminance
        let foregroundLuminance = self.luminance
        
        let contrastRatio = (max(backgroundLuminance, foregroundLuminance) + 0.05) / 
                           (min(backgroundLuminance, foregroundLuminance) + 0.05)
        
        // If contrast is too low, return white or black based on background
        if contrastRatio < 4.5 {
            return backgroundLuminance > 0.5 ? .black : .white
        }
        
        return self
    }
    
    /// Calculates the relative luminance of the color
    private var luminance: Double {
        guard let components = cgColor?.components else { return 0 }
        
        let r = Double(components[0])
        let g = Double(components.count > 1 ? components[1] : 0)
        let b = Double(components.count > 2 ? components[2] : 0)
        
        // Convert to linear RGB
        func linearize(_ value: Double) -> Double {
            return value <= 0.03928 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
        }
        
        let linearR = linearize(r)
        let linearG = linearize(g)
        let linearB = linearize(b)
        
        // Calculate luminance
        return 0.2126 * linearR + 0.7152 * linearG + 0.0722 * linearB
    }
}

// MARK: - Theme Support

extension Color {
    static func adaptiveColor(light: Color, dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}