@testable import ReccoHeadless
import XCTest

final class MockRecommendationRepository: RecommendationRepository {
    enum ExpectationType {
        case getFeedSection
        case getBookmarks
    }

    var expectations: [ExpectationType: XCTestExpectation] = [:]
    var expectedGetFeedSection: [AppUserRecommendation] = Mocks.appUserRecommendations

    var getFeedSectionError: NSError?
    var getBookmarksError: NSError?

    func getFeedSection(_ section: ReccoHeadless.FeedSection) async throws -> [AppUserRecommendation] {
        expectations[.getFeedSection]?.fulfill()

        if let getFeedSectionError = getFeedSectionError {
            throw getFeedSectionError
        }

        return expectedGetFeedSection
    }

    func getBookmarks() async throws -> [AppUserRecommendation] {
        expectations[.getBookmarks]?.fulfill()

        if let getBookmarksError = getBookmarksError {
            throw getBookmarksError
        }

        return expectedGetFeedSection
    }
}
