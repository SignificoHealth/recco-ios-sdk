import Foundation
import SFApi
import SFEntities

extension FeedSectionType {
    init(dto: FeedSectionDTO.TypeDTO) {
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
            locked: dto.locked,
            topic: dto.topic.map(SFTopic.init)
        )
    }
}
