import XCTest
@testable import ReccoHeadless

final class MockRecommendationRepository: RecommendationRepository {

    enum ExpectationType {
        case getFeedSection
        case getBookmarks
    }

    var expectations: [ExpectationType: XCTestExpectation] = [:]
    var expectedContentId: ContentId?

    var getFeedSectionError: NSError?
    var getBookmarksError: NSError?

    func getFeedSection(_ section: ReccoHeadless.FeedSection) async throws -> [ReccoHeadless.AppUserRecommendation] {
        expectations[.getFeedSection]?.fulfill()

        if let getFeedSectionError = getFeedSectionError {
            throw getFeedSectionError
        }

        return Mocks.appUserRecommendations
    }

    func getBookmarks() async throws -> [ReccoHeadless.AppUserRecommendation] {
        expectations[.getBookmarks]?.fulfill()

        if let getBookmarksError = getBookmarksError {
            throw getBookmarksError
        }

        return Mocks.appUserRecommendations
    }

}
