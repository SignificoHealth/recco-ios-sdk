import Foundation

public protocol RecommendationRepository {
    func getFeedSection(_ section: FeedSection) async throws -> [AppUserRecommendation]
}

final class LiveRecommendationRepository: RecommendationRepository {
    init() {}
    
    func getFeedSection(_ section: FeedSection) async throws -> [AppUserRecommendation] {
        switch (section.type, section.topic) {
        case (.physicalActivityRecommendations, .some(let topic)), (.nutritionRecommendations, .some(let topic)),
            (.physicalWellbeingRecommendations, .some(let topic)),
            (.sleepRecommendations, .some(let topic)):
            return try await RecommendationAPI
                .getTailoredRecommendationsByTopic(
                    topic: .init(entity: topic)
                )
                .map(AppUserRecommendation.init)
        case (.preferredRecommendations, _):
            return try await RecommendationAPI
                .getUserPreferredRecommendations()
                .map(AppUserRecommendation.init)
        case (.mostPopular, _):
            return try await RecommendationAPI
                .getMostPopularContent()
                .map(AppUserRecommendation.init)
        case (.newContent, _):
            return try await RecommendationAPI
                .getNewestContent()
                .map(AppUserRecommendation.init)
        case (.physicalActivityExplore, .some(let topic)),
            (.nutritionExplore, .some(let topic)),
            (.physicalWellbeingExplore, .some(let topic)),
            (.sleepExplore, .some(let topic)):
            return try await RecommendationAPI
                .exploreContentByTopic(topic: .init(entity: topic))
                .map(AppUserRecommendation.init)
        case (.startingRecommendations, _):
            return try await RecommendationAPI
                .getStartingRecommendations()
                .map(AppUserRecommendation.init)
        default:
            assertionFailure("This should never happen")
            return []
        }
    }
}
