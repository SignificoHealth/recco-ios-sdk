import Foundation

public enum FeedSectionType: String, Codable, CaseIterable {
    case physicalActivityRecommendations
    case nutritionRecommendations
    case physicalWellbeingRecommendations
    case sleepRecommendations
    case preferredRecommendations
    case mostPopular
    case newContent
    case physicalActivityExplore
    case nutritionExplore
    case physicalWellbeingExplore
    case sleepExplore
    case startingRecommendations
}

public struct FeedSection: Equatable, Hashable {
    public var type: FeedSectionType
    public var locked: Bool
    public var topic: SFTopic?

    public init(type: FeedSectionType, locked: Bool, topic: SFTopic? = nil) {
        self.type = type
        self.locked = locked
        self.topic = topic
    }
}

