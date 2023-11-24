@testable import ReccoHeadless
@testable import ReccoUI
import XCTest

@MainActor
final class ArticleDetailViewModelTest: XCTestCase {
    private var loggerLogError: XCTestExpectation!
    private let mockArticle = Mocks.article
    private let mockLoadedContent: (ContentId, String, URL?, (ContentId) -> Void, (Bool) -> Void) = (
        ContentId(itemId: "itemId", catalogId: "catalogId"),
        "heading",
        nil, { _ in /* updateContentSeen */ }, { _ in /* onBookmarkChanged */ }
    )

    override func setUp() async throws {
        loggerLogError = expectation(description: "Logger received an error")
        loggerLogError.isInverted = true
    }

    private func expectErrorLogging() { loggerLogError.isInverted = false }

    private func getViewModel(
        loadedContent: (ContentId, String, URL?, (ContentId) -> Void, (Bool) -> Void)? = nil,
        articleRepo: ArticleRepository? = nil,
        contentRepo: ContentRepository? = nil,
        nav: ReccoCoordinator? = nil
    ) -> ArticleDetailViewModel {
        ArticleDetailViewModel(
            loadedContent: loadedContent ?? mockLoadedContent,
            articleRepo: articleRepo ?? MockArticleRepository(),
            contentRepo: contentRepo ?? MockContentRepository(),
            nav: nav ?? MockRecoCoordinator(),
            logger: Logger { [unowned self] _ in loggerLogError.fulfill() }
        )
    }

    // MARK: - initialLoad

    func test_initialLoad_whenGetArticleFails_throwsAnError() async {
        let mockArticleRepository = MockArticleRepository()
        let getArticleError = NSError(domain: "getArticleError", code: 0)
        mockArticleRepository.getArticleError = getArticleError
        let getArticleExpectation = expectation(description: "getArticle was not called")
        mockArticleRepository.expectations[.getArticle] = getArticleExpectation
        let updateContentSeenExpectation = expectation(description: "updateContentSeen was called")
        var mockLoadedContent = mockLoadedContent
        updateContentSeenExpectation.isInverted = true
        mockLoadedContent.3 = { _ in updateContentSeenExpectation.fulfill() }
        expectErrorLogging()

        let viewModel = getViewModel(
            loadedContent: mockLoadedContent,
            articleRepo: mockArticleRepository
        )

        XCTAssertNil(viewModel.article)
        XCTAssertTrue(viewModel.isLoading)

        await viewModel.initialLoad()
        await fulfillment(of: [getArticleExpectation, updateContentSeenExpectation, loggerLogError], timeout: 1)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.article)
        XCTAssertEqual(mockArticleRepository.getArticleError, viewModel.initialLoadError as? NSError)
    }

    func test_initialLoad_whenGetArticleSucceeds_updatesArticleAndCallsUpdateContentSeen() async {
        let mockArticleRepository = MockArticleRepository()
        let getArticleExpectation = expectation(description: "getArticle was not called")
        mockArticleRepository.expectations[.getArticle] = getArticleExpectation
        let expectedArticle = mockArticle
        mockArticleRepository.expectedContentId = expectedArticle.id
        let updateContentSeenExpectation = expectation(description: "updateContentSeen was not called")
        var mockLoadedContent = mockLoadedContent
        mockLoadedContent.3 = { contentId in
            XCTAssertEqual(contentId, expectedArticle.id)
            updateContentSeenExpectation.fulfill()
        }
        let viewModel = getViewModel(
            loadedContent: mockLoadedContent,
            articleRepo: mockArticleRepository
        )

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.article)
        await viewModel.initialLoad()
        await fulfillment(of: [getArticleExpectation, updateContentSeenExpectation, loggerLogError], timeout: 1)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.article, expectedArticle)
        XCTAssertNil(viewModel.initialLoadError)
    }

    // MARK: - toggleBookmark

    func test_toggleBookmark_whenArticleIsNil_doesNotCallSetBookmark() async {
        let mockContentRepository = MockContentRepository()
        let setBookmarkExpectation = expectation(description: "setBookmark was called")
        setBookmarkExpectation.isInverted = true
        mockContentRepository.expectations[.setBookmark] = setBookmarkExpectation
        let viewModel = getViewModel(contentRepo: mockContentRepository)

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.article)
        await viewModel.toggleBookmark()

        await fulfillment(of: [setBookmarkExpectation, loggerLogError], timeout: 1)
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.article)
    }

    func test_toggleBookmark_whenArticleIsNotNilAndSetBookmarkFails_throwsAnError() async {
        let mockContentRepository = MockContentRepository()
        var mockLoadedContent = mockLoadedContent
        let setBookmarkError = NSError(domain: "setBookmarkError", code: 0)
        mockContentRepository.setBookmarkError = setBookmarkError
        let setBookmarkExpectation = expectation(description: "setBookmark was not called")
        mockContentRepository.expectations[.setBookmark] = setBookmarkExpectation
        let onBookmarkChangedExpectation = expectation(description: "onBookmarkChanged was called")
        onBookmarkChangedExpectation.isInverted = true
        mockLoadedContent.4 = { _ in onBookmarkChangedExpectation.fulfill() }
        let viewModel = getViewModel(loadedContent: mockLoadedContent, contentRepo: mockContentRepository)
        viewModel.article = mockArticle
        expectErrorLogging()

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.article?.bookmarked, false)

        await viewModel.toggleBookmark()
        await fulfillment(of: [setBookmarkExpectation, onBookmarkChangedExpectation, loggerLogError], timeout: 1)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.article?.bookmarked, false)
        XCTAssertEqual(mockContentRepository.setBookmarkError, viewModel.actionError as? NSError)
    }

    func test_toggleBookmark_whenArticleIsNotNilAndSetBookmarkSucceeds_togglesArticleBookmarkedAndCallsOnBookmarkChanged() async {
        let mockContentRepository = MockContentRepository()
        var mockLoadedContent = mockLoadedContent
        let expectedBookmarked = true
        let onBookmarkChangedExpectation = expectation(description: "onBookmarkChanged was not called with \(expectedBookmarked)")
        mockLoadedContent.4 = { bookmarked in
            XCTAssertEqual(bookmarked, expectedBookmarked)
            onBookmarkChangedExpectation.fulfill()
        }
        let setBookmarkExpectation = expectation(description: "setBookmark was not called with \(expectedBookmarked)")
        mockContentRepository.expectations[.setBookmark] = setBookmarkExpectation
        let viewModel = getViewModel(loadedContent: mockLoadedContent, contentRepo: mockContentRepository)
        viewModel.article = mockArticle

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.article?.bookmarked, false)
        await viewModel.toggleBookmark()

        await fulfillment(of: [setBookmarkExpectation, onBookmarkChangedExpectation, loggerLogError], timeout: 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.article?.bookmarked, true)
        XCTAssertNil(viewModel.actionError)
    }

    // MARK: - rate

    func test_rate_whenArticleIsNil_doesNotCallSetRating() async {
        let mockContentRepository = MockContentRepository()
        let setRatingExpectation = expectation(description: "setRating was called")
        setRatingExpectation.isInverted = true
        mockContentRepository.expectations[.setRating] = setRatingExpectation
        let viewModel = getViewModel(contentRepo: mockContentRepository)

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.article)
        await viewModel.rate(.like)

        await fulfillment(of: [setRatingExpectation, loggerLogError], timeout: 1)
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.article)
    }

    func test_rate_whenArticleIsNotNilAndSetRatingFails_throwsAnError() async {
        let mockContentRepository = MockContentRepository()
        let setRatingError = NSError(domain: "setRatingError", code: 0)
        mockContentRepository.setRatingError = setRatingError
        let setRatingExpectation = expectation(description: "setRating was not called")
        mockContentRepository.expectations[.setRating] = setRatingExpectation
        let viewModel = getViewModel(contentRepo: mockContentRepository)
        viewModel.article = mockArticle
        expectErrorLogging()

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.article?.rating, .notRated)
        await viewModel.rate(.like)

        await fulfillment(of: [setRatingExpectation, loggerLogError], timeout: 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.article?.rating, .notRated)
        XCTAssertEqual(setRatingError, viewModel.actionError as? NSError)
    }

    func test_rate_whenArticleIsNotNilAndSetRatingSucceeds_updatesArticleRating() async {
        let mockContentRepository = MockContentRepository()
        let expectedRating: ContentRating = .like
        let setRatingExpectation = expectation(description: "setRating was not called with \(expectedRating.rawValue)")
        mockContentRepository.expectations[.setRating] = setRatingExpectation
        let viewModel = getViewModel(contentRepo: mockContentRepository)
        viewModel.article = mockArticle

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.article?.rating, .notRated)

        await viewModel.rate(expectedRating)
        await fulfillment(of: [setRatingExpectation, loggerLogError], timeout: 1)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.article?.rating, expectedRating)
        XCTAssertNil(viewModel.actionError)
    }

    // MARK: - dismiss

    func test_dismiss_navigatesToDismiss() {
        let mockCoordinator = MockRecoCoordinator()
        let expectedDestination = Destination.dismiss
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "Navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation
        let viewModel = getViewModel(nav: mockCoordinator)

        viewModel.dismiss()

        wait(for: [navigateExpectation, loggerLogError], timeout: 1)
    }

    // MARK: - back

    func test_back_navigatesToBack() {
        let mockCoordinator = MockRecoCoordinator()
        let expectedDestination = Destination.back
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "Navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation
        let viewModel = getViewModel(nav: mockCoordinator)

        viewModel.back()

        wait(for: [navigateExpectation, loggerLogError], timeout: 1)
    }
}
