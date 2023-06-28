import Foundation

public enum SFNotificationStyle: Equatable {
    case error
    case confirmation
}

public struct SFNotificationData: Equatable {
    public init(title: String, subtitle: String? = nil, style: SFNotificationStyle) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
    }
    
    public var title: String
    public var subtitle: String?
    public var style: SFNotificationStyle
}

extension SFNotificationData {
    public static func confirmation(_ title: String, subtitle: String? = nil) -> SFNotificationData {
        return SFNotificationData(title: title, subtitle: subtitle, style: .confirmation)
    }
    
    public static func error(_ title: String, subtitle: String? = nil) -> SFNotificationData {
        return SFNotificationData(title: title, subtitle: subtitle, style: .error)
    }
}
