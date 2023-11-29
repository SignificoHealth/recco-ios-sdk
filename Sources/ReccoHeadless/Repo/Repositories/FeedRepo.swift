import Foundation

public protocol FeedRepository {
    func getFeed() async throws -> [FeedSection]
}

final class LiveFeedRepository: FeedRepository {
    init() {}

    func getFeed() async throws -> [FeedSection] {
        let dto = try await FeedAPI.getFeed()
        
        var feedAndTayloredSections = [
            FeedSection(type: .physicalActivityRecommendations, state: .unlock, topic: .physicalActivity),
            FeedSection(type: .nutritionRecommendations, state: .unlock, topic: .nutrition),
            FeedSection(type: .mentalWellbeingRecommendations, state: .unlock, topic: .mentalWellbeing),
            FeedSection(type: .sleepRecommendations, state: .unlock, topic: .sleep)
        ]
        
        var feedSections = dto.map(FeedSection.init)
        feedAndTayloredSections.append(contentsOf: feedSections)
        return feedAndTayloredSections
    }
}
