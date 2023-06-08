import Foundation
import SFEntities
import SFApi
import SFCore

public protocol FeedRepository {
    func getFeed() async throws -> [FeedSection]
}

final class LiveFeedRepository: FeedRepository {
    init() {}
    
    func getFeed() async throws -> [FeedSection] {
        let dto = try await FeedAPI.getFeed()
        return dto.map(FeedSection.init)
    }
}
