import Foundation

extension FeedSectionState {
    init(dto: FeedSectionStateDTO) {
        switch dto {
        case .lock:
            self = .lock
        case .unlock:
            self = .unlock
        case .partiallyUnlock:
            self = .partiallyUnlock
        }
    }
}


extension FeedSectionType {
    init(dto: FeedSectionTypeDTO) {
        switch dto {
        case .physicalActivityRecommendations:
            self = .physicalActivityRecommendations
        case .nutritionRecommendations:
            self = .nutritionRecommendations
        case .physicalWellbeingRecommendations:
            self = .physicalWellbeingRecommendations
        case .sleepRecommendations:
            self = .sleepRecommendations
        case .preferredRecommendations:
            self = .preferredRecommendations
        case .mostPopular:
            self = .mostPopular
        case .newContent:
            self = .newContent
        case .physicalActivityExplore:
            self = .physicalActivityExplore
        case .nutritionExplore:
            self = .nutritionExplore
        case .physicalWellbeingExplore:
            self = .physicalWellbeingExplore
        case .sleepExplore:
            self = .sleepExplore
        case .startingRecommendations:
            self = .startingRecommendations
        }
    }
}

extension SFTopic {
    init(dto: TopicDTO) {
        switch dto {
        case .physicalActivity:
            self = .physicalActivity
        case .nutrition:
            self = .nutrition
        case .physicalWellbeing:
            self = .physicalWellbeing
        case .sleep:
            self = .sleep
        }
    }
}

extension TopicDTO {
    init(entity: SFTopic) {
        switch entity {
        case .physicalActivity:
            self = .physicalActivity
        case .nutrition:
            self = .nutrition
        case .physicalWellbeing:
            self = .physicalWellbeing
        case .sleep:
            self = .sleep
        }
    }
}

extension FeedSection {
    init(dto: FeedSectionDTO) {
        self.init(
            type: .init(dto: dto.type),
            state: .init(dto: dto.state),
            topic: dto.topic.map(SFTopic.init)
        )
    }
}
