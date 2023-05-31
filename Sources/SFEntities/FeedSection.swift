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
    public var topicId: Int?

    public init(type: FeedSectionType, locked: Bool, topicId: Int? = nil) {
        self.type = type
        self.locked = locked
        self.topicId = topicId
    }
}

