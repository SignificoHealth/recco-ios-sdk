@testable import ReccoHeadless
import XCTest

final class MockArticleRepository: ArticleRepository {
    enum ExpectationType {
        case getArticle
    }

    var expectations: [ExpectationType: XCTestExpectation] = [:]
    var expectedContentId: ContentId?

    var getArticleError: NSError?

    func getArticle(with id: ContentId) async throws -> AppUserArticle {
        expectations[.getArticle]?.fulfill()

        if let expectedContentId = expectedContentId {
            XCTAssertEqual(id, expectedContentId)
        }

        if let getArticleError = getArticleError {
            throw getArticleError
        }

        return Mocks.article
    }
}
