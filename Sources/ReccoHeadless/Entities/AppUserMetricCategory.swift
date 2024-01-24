import Foundation

public enum AppUserMetricCategory: String, Codable, CaseIterable {
    case userSession = "user_session"
    case dashboardScreen = "dashboard_screen"
}
