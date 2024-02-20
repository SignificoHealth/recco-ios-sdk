import Foundation

public enum AppUserMetricAction: String, Codable, CaseIterable {
    case view = "view"
    case hostAppOpen = "host_app_open"
    case reccoSDKOpen = "recco_sdk_open"
}
