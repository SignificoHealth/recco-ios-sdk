@testable import ReccoHeadless
import XCTest

final class MockContentRepository: ContentRepository {
    enum ExpectationType {
        case setRating
        case setBookmark
    }

    var expectations: [ExpectationType: XCTestExpectation] = [:]
    var expectedUpdateRating: UpdateRating?

    var setRatingError: NSError?
    var setBookmarkError: NSError?

    func setRating(_ updateRating: UpdateRating) async throws {
        expectations[.setRating]?.fulfill()

        if let expectedUpdateRating = expectedUpdateRating {
            XCTAssertEqual(updateRating, expectedUpdateRating)
        }

        if let setRatingError = setRatingError {
            throw setRatingError
        }
    }

    func setBookmark(_ updateBookmark: UpdateBookmark) async throws {
        expectations[.setBookmark]?.fulfill()

        if let setBookmarkError = setBookmarkError {
            throw setBookmarkError
        }
    }
}
