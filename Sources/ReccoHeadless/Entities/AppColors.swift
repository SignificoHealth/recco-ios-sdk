

import Foundation

public struct AppColors: Equatable, Hashable, Codable {
    
    init(primary: String, onPrimary: String, background: String, onBackground: String, accent: String, onAccent: String, illustration: String, illustrationOutline: String) {
        self.primary = primary
        self.onPrimary = onPrimary
        self.background = background
        self.onBackground = onBackground
        self.accent = accent
        self.onAccent = onAccent
        self.illustration = illustration
        self.illustrationOutline = illustrationOutline
    }
    
    public var primary: String
    public var onPrimary: String
    public var background: String
    public var onBackground: String
    public var accent: String
    public var onAccent: String
    public var illustration: String
    public var illustrationOutline: String
}
