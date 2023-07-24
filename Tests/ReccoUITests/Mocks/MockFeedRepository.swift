import XCTest
@testable import ReccoHeadless

final class MockFeedRepository: FeedRepository {

    enum ExpectationType {
        case getFeed
    }

    var expectations: [ExpectationType: XCTestExpectation] = [:]
    var expectedGetFeed: [FeedSection] = Mocks.feedSections

    var getFeedError: NSError?

    func getFeed() async throws -> [FeedSection] {
        expectations[.getFeed]?.fulfill()

        if let getFeedError = getFeedError {
            throw getFeedError
        }

        return expectedGetFeed
    }
}
