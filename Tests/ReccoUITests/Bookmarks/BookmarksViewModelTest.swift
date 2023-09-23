@testable import ReccoHeadless
@testable import ReccoUI
import XCTest

@MainActor
final class BookmarksViewModelTest: XCTestCase {
    private var loggerLogError: XCTestExpectation!
    private let appUserRecommendation = Mocks.appUserRecommendation
    private lazy var articleDestination: Destination = {
        .article(
            id: appUserRecommendation.id,
            headline: appUserRecommendation.headline,
            imageUrl: appUserRecommendation.imageUrl,
            seenContent: { _ in /* No need to mock this */ },
            onBookmarkedChange: { _ in /* No need to mock this */ }
        )
    }()

	override func setUp() async throws {
		loggerLogError = expectation(description: "Logger received an error")
		loggerLogError.isInverted = true
	}

	private func expectErrorLogging() { loggerLogError.isInverted = false }
	
    private func getViewModel(
        recRepo: RecommendationRepository? = nil,
        nav: ReccoCoordinator? = nil
    ) -> BookmarksViewModel {
        BookmarksViewModel(
            recRepo: recRepo ?? MockRecommendationRepository(),
            nav: nav ?? MockRecoCoordinator(),
            logger: Logger { [unowned self] _ in loggerLogError.fulfill() }
        )
    }

    // MARK: - goToDetail

    func test_goToDetail_whenCalled_navigatesToArticle() {
        let mockCoordinator = MockRecoCoordinator()
        let expectedDestination = articleDestination
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation
        let viewModel = getViewModel(nav: mockCoordinator)

        viewModel.goToDetail(of: appUserRecommendation)

        wait(for: [navigateExpectation, loggerLogError], timeout: 1)
    }

    func test_goToDetail_whenNavigatesToArticleAndBookmarkedIsFalse_onBookmarkedChangeDoesRefreshBookmarks() async {
        let appUserRecommendation = Mocks.appUserRecommendation
        let mockCoordinator = MockRecoCoordinator()
        let mockRecommendationRepository = MockRecommendationRepository()
        let getBookmarksExpectation = expectation(description: "getBookmarks was not called")
        mockRecommendationRepository.expectations[.getBookmarks] = getBookmarksExpectation
        let viewModel = getViewModel(recRepo: mockRecommendationRepository, nav: mockCoordinator)

        viewModel.goToDetail(of: appUserRecommendation)
        // They are equal except for the closures
        XCTAssertEqual(mockCoordinator.lastDestination, articleDestination)
        guard case .article(_, _, _, _, let onBookmarkedChange) = mockCoordinator.lastDestination else {
            return XCTFail("destination was not .article")
        }
        onBookmarkedChange(false)

        await fulfillment(of: [getBookmarksExpectation, loggerLogError], timeout: 1)
    }

    func test_goToDetail_whenNavigatesToArticleAndBookmarkedIsTrue_onBookmarkedChangeDoesNotRefreshBookmarks() async {
        let appUserRecommendation = Mocks.appUserRecommendation
        let mockCoordinator = MockRecoCoordinator()
        let mockRecommendationRepository = MockRecommendationRepository()
        let getBookmarksExpectation = expectation(description: "getBookmarks was not called")
        getBookmarksExpectation.isInverted = true
        mockRecommendationRepository.expectations[.getBookmarks] = getBookmarksExpectation
        let viewModel = getViewModel(recRepo: mockRecommendationRepository, nav: mockCoordinator)

        viewModel.goToDetail(of: appUserRecommendation)
        // They are equal except for the closures
        XCTAssertEqual(mockCoordinator.lastDestination, articleDestination)
        guard case .article(_, _, _, _, let onBookmarkedChange) = mockCoordinator.lastDestination else {
            return XCTFail("destination was not .article")
        }
        
        onBookmarkedChange(true)

        await fulfillment(of: [getBookmarksExpectation, loggerLogError], timeout: 1)
    }

    func test_goToDetail_whenNavigatesToArticle_seenContentMarksContentAsSeen() async {
        let appUserRecommendation = appUserRecommendation
        let mockCoordinator = MockRecoCoordinator()
        let viewModel = getViewModel(nav: mockCoordinator)
        var items = Mocks.appUserRecommendations
        // Insert at last
        items.append(appUserRecommendation)
        // Mark all as not seen
        viewModel.items = items.map { item in
            var item = item
            item.status = .noInteraction
            return item
        }

        viewModel.goToDetail(of: appUserRecommendation)
        // They are equal except for the closures
        XCTAssertEqual(mockCoordinator.lastDestination, articleDestination)
        guard case .article(_, _, _, let seenContent, _) = mockCoordinator.lastDestination else {
            return XCTFail("destination was not .article")
        }

        XCTAssertTrue(viewModel.items.allSatisfy { $0.status == .noInteraction })
        seenContent(appUserRecommendation.id)
        XCTAssertEqual(viewModel.items.last?.id, appUserRecommendation.id)
        XCTAssertEqual(viewModel.items.last?.status, .viewed)

        await fulfillment(of: [loggerLogError], timeout: 1)
    }

    // MARK: - getBoomarks

    func test_getBookmarks_whenGetBookmarkSucceeds_updatesItems() async {
        let mockRecommendationRepository = MockRecommendationRepository()
        let getBookmarksExpectation = expectation(description: "getBookmarks was not called")
        mockRecommendationRepository.expectations[.getBookmarks] = getBookmarksExpectation
        let viewModel = getViewModel(recRepo: mockRecommendationRepository)

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertTrue(viewModel.items.isEmpty)
        await viewModel.getBookmarks()

        await fulfillment(of: [getBookmarksExpectation, loggerLogError], timeout: 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.items, Mocks.appUserRecommendations)
        XCTAssertNil(viewModel.error)
    }

    func test_getBookmarks_whenGetBookmarkFails_updatesError() async {
        let mockRecommendationRepository = MockRecommendationRepository()
        let getBookmarksExpectation = expectation(description: "getBookmarks was not called")
        mockRecommendationRepository.expectations[.getBookmarks] = getBookmarksExpectation
        let getBookmarksError = NSError(domain: "getBookmarksError", code: 0)
        mockRecommendationRepository.getBookmarksError = getBookmarksError
        let viewModel = getViewModel(recRepo: mockRecommendationRepository)
        expectErrorLogging()

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertTrue(viewModel.items.isEmpty)
        await viewModel.getBookmarks()

        await fulfillment(of: [getBookmarksExpectation, loggerLogError], timeout: 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(getBookmarksError, viewModel.error as? NSError)
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
}
