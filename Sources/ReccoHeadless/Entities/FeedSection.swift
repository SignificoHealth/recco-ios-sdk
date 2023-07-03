import Foundation

public enum FeedSectionType: String, Codable, CaseIterable {
    case physicalActivityRecommendations
    case nutritionRecommendations
    case mentalWellbeingRecommendations
    case sleepRecommendations
    case preferredRecommendations
    case mostPopular
    case newContent
    case physicalActivityExplore
    case nutritionExplore
    case mentalWellbeingExplore
    case sleepExplore
    case startingRecommendations
}

public enum FeedSectionState: String {
    case locked = "LOCK"
    case unlock = "UNLOCK"
    case partiallyUnlock = "PARTIALLY_UNLOCK"
}

public struct FeedSection: Equatable, Hashable {
    public var type: FeedSectionType
    public var state: FeedSectionState
    public var topic: SFTopic?

    public init(type: FeedSectionType, state: FeedSectionState, topic: SFTopic? = nil) {
        self.type = type
        self.state = state
        self.topic = topic
    }
}

extension FeedSection {
    public var locked: Bool {
        get {
            self.state == .locked
        } set {
            self.state = newValue ? .locked : .unlock
        }
    }
}

