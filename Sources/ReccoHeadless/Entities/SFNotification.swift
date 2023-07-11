import Foundation

public enum ReccoNotificationStyle: Equatable {
    case error
    case confirmation
}

public struct ReccoNotificationData: Equatable {
    public init(title: String, subtitle: String? = nil, style: ReccoNotificationStyle) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
    }
    
    public var title: String
    public var subtitle: String?
    public var style: ReccoNotificationStyle
}

extension ReccoNotificationData {
    public static func confirmation(_ title: String, subtitle: String? = nil) -> ReccoNotificationData {
        return ReccoNotificationData(title: title, subtitle: subtitle, style: .confirmation)
    }
    
    public static func error(_ title: String, subtitle: String? = nil) -> ReccoNotificationData {
        return ReccoNotificationData(title: title, subtitle: subtitle, style: .error)
    }
}
