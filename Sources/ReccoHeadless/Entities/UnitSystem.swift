import Foundation

public enum UnitSystem {
    case imperialUS
    case imperialGB
    case metric
}

extension Locale {
    public func getUnitSystem() -> UnitSystem {
        switch regionCode {
        case "US":
            return .imperialUS
        case "GB", "MM", "LR":
            return .imperialGB
        default:
            return .metric
        }
    }
}
