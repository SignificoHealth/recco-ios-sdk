import Foundation

public struct AppUserMetricEvent: Equatable, Hashable, Codable {
    public init(category: AppUserMetricCategory, action: AppUserMetricAction, value: String? = nil) {
        self.category = category
        self.action = action
        self.value = value
    }
    
    public var category: AppUserMetricCategory
    public var action: AppUserMetricAction
    public var value: String?
}
