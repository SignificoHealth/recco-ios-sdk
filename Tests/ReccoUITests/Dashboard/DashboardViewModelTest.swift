import XCTest
@testable import ReccoHeadless
@testable import ReccoUI

final class DashboardViewModelTest: XCTestCase {

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
    private let feedSection = Mocks.feedSectionWithTopic
    private lazy var questionnaireDestination: Destination = {
        .questionnaire(
            feedSection.topic ?? .nutrition,
            { _ in /* No need to mock this */}
        )
    }()

    private func getViewModel(
        feedRepo: FeedRepository? = nil,
        recRepo: RecommendationRepository? = nil,
        nav: ReccoCoordinator? = nil
    ) -> DashboardViewModel {
        return DashboardViewModel(
            feedRepo: feedRepo ?? MockFeedRepository(),
            recRepo: recRepo ?? MockRecommendationRepository(),
            nav: nav ?? MockRecoCoordinator()
        )
    }

    // MARK: - init

    func test_init_callsGetFeedItems() async {
        let mockFeedRepository = MockFeedRepository()
        let getFeedExpectation = expectation(description: "getFeed was not called")
        mockFeedRepository.expectations[.getFeed] = getFeedExpectation
        // Calls getFeedItems in constructor
        _ = getViewModel(feedRepo: mockFeedRepository)

        await fulfillment(of: [getFeedExpectation], timeout: 1)
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

        wait(for: [navigateExpectation], timeout: 1)
    }

    func test_goToDetail_whenNavigatesToArticle_seenContentMarksContentAsSeen() async {
        var appUserRecommendation = appUserRecommendation
        let mockCoordinator = MockRecoCoordinator()
        let viewModel = getViewModel(nav: mockCoordinator)
        // Mark as not seen
        appUserRecommendation.status = .noInteraction
        viewModel.sections = [FeedSectionViewState(
            section: FeedSection(
                type: .mostPopular,
                state: .unlock
            ),
            isLoading: false
        )]
        viewModel.items[.mostPopular] = [appUserRecommendation]

        viewModel.goToDetail(of: appUserRecommendation)
        // They are equal except for the closures
        XCTAssertEqual(mockCoordinator.lastDestination, articleDestination)
        guard case .article(_, _, _, let seenContent, _) = mockCoordinator.lastDestination else {
            return XCTFail("destination was not .article")
        }

        seenContent(appUserRecommendation.id)
        XCTAssertEqual(viewModel.items[.mostPopular]?.first?.id, appUserRecommendation.id)
        XCTAssertEqual(viewModel.items[.mostPopular]?.first?.status, .viewed)

    }

    // MARK: - goToBookmarks

    func test_goToBookmarks_navigatesToBookmarks() {
        let mockCoordinator = MockRecoCoordinator()
        let expectedDestination = Destination.bookmarks
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation
        let viewModel = getViewModel(nav: mockCoordinator)

        viewModel.goToBookmarks()

        wait(for: [navigateExpectation], timeout: 1)
    }

    // MARK: - dismiss

    func test_dismiss_navigatesToDismiss() {
        let mockCoordinator = MockRecoCoordinator()
        let expectedDestination = Destination.dismiss
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation
        let viewModel = getViewModel(nav: mockCoordinator)

        viewModel.dismiss()

        wait(for: [navigateExpectation], timeout: 1)
    }

    // MARK: - pressedUnlockSectionStart

    func test_pressedUnlockSectionStart_whenLockedSectionAlertAndTopicAreNotNil_navigatesToQuestionnaire() async {
        let feedSection = Mocks.feedSectionWithTopic
        let mockCoordinator = MockRecoCoordinator()
        let expectedDestination = questionnaireDestination
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation
        let viewModel = getViewModel(nav: mockCoordinator)
        viewModel.lockedSectionAlert = feedSection

        await viewModel.pressedUnlockSectionStart()

        await fulfillment(of: [navigateExpectation], timeout: 1)
        XCTAssertNil(viewModel.lockedSectionAlert)
    }

    func test_pressedUnlockSectionStart_whenNavigatesToQuestionnaire_doesReloadSections() async {
        let feedSection = Mocks.feedSectionWithTopic
        let mockCoordinator = MockRecoCoordinator()
        let expectedDestination = questionnaireDestination
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation
        let mockFeedRepository = MockFeedRepository()
        mockFeedRepository.expectedGetFeed = []
        let getFeedExpectation = expectation(description: "getFeed was not called")
        mockFeedRepository.expectations[.getFeed] = getFeedExpectation
        // Calls getFeedItems in constructor
        let mockRecommendationRepository = MockRecommendationRepository()
        let viewModel = getViewModel(feedRepo: mockFeedRepository, recRepo: mockRecommendationRepository, nav: mockCoordinator)
        viewModel.lockedSectionAlert = feedSection
        await fulfillment(of: [getFeedExpectation], timeout: 1)
        // Needs to be setup after viewModel.init
        let getFeedSectionExpectation = expectation(description: "getFeedSection was not called")
        mockRecommendationRepository.expectations[.getFeedSection] = getFeedSectionExpectation
        mockRecommendationRepository.expectedGetFeedSection = [appUserRecommendation]
        viewModel.sections = [FeedSectionViewState(
            section: FeedSection(
                type: .mostPopular,
                state: .partiallyUnlock
            ),
            isLoading: false
        )]

        XCTAssertTrue(viewModel.items.isEmpty)
        await viewModel.pressedUnlockSectionStart()
        // They are equal except for the closures
        XCTAssertEqual(mockCoordinator.lastDestination, questionnaireDestination)
        guard case .questionnaire(_, let reloadSections) = mockCoordinator.lastDestination else {
            return XCTFail("destination was not .questionnaire")
        }
        reloadSections(true)

        await fulfillment(of: [navigateExpectation, getFeedSectionExpectation], timeout: 1)
        XCTAssertNil(viewModel.lockedSectionAlert)
        XCTAssertEqual(viewModel.items[.mostPopular], [appUserRecommendation])
    }

    func test_pressedUnlockSectionStart_whenNavigatesToQuestionnaireAndReloadSectionsFails_updatesError() async {
        let feedSection = Mocks.feedSectionWithTopic
        let mockCoordinator = MockRecoCoordinator()
        let expectedDestination = questionnaireDestination
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation
        let mockFeedRepository = MockFeedRepository()
        mockFeedRepository.expectedGetFeed = []
        let getFeedExpectation = expectation(description: "getFeed was not called")
        mockFeedRepository.expectations[.getFeed] = getFeedExpectation
        // Calls getFeedItems in constructor
        let mockRecommendationRepository = MockRecommendationRepository()
        let viewModel = getViewModel(feedRepo: mockFeedRepository, recRepo: mockRecommendationRepository, nav: mockCoordinator)
        viewModel.lockedSectionAlert = feedSection
        await fulfillment(of: [getFeedExpectation], timeout: 1)
        // Needs to be setup after viewModel.init
        let getFeedSectionExpectation = expectation(description: "getFeedSection was not called")
        mockRecommendationRepository.expectations[.getFeedSection] = getFeedSectionExpectation
        let getFeedSectionError = NSError(domain: "getFeedSectionError", code: 0)
        mockRecommendationRepository.getFeedSectionError = getFeedSectionError
        viewModel.sections = [FeedSectionViewState(
            section: FeedSection(
                type: .mostPopular,
                state: .partiallyUnlock
            ),
            isLoading: false
        )]

        await viewModel.pressedUnlockSectionStart()
        // They are equal except for the closures
        XCTAssertEqual(mockCoordinator.lastDestination, questionnaireDestination)
        guard case .questionnaire(_, let reloadSections) = mockCoordinator.lastDestination else {
            return XCTFail("destination was not .questionnaire")
        }
        reloadSections(true)

        await fulfillment(of: [navigateExpectation, getFeedSectionExpectation], timeout: 1)
        XCTAssertNil(viewModel.lockedSectionAlert)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(getFeedSectionError, viewModel.initialLoadError as? NSError)
    }

    func test_pressedUnlockSectionStart_whenLockedSectionAlertIsNil_doesNotCallNavigate() async {
        let mockCoordinator = MockRecoCoordinator()
        let navigateExpectation = expectation(description: "navigate was not called")
        navigateExpectation.isInverted = true
        mockCoordinator.expectations[.navigate] = navigateExpectation
        let viewModel = getViewModel(nav: mockCoordinator)

        XCTAssertNil(viewModel.lockedSectionAlert)
        await viewModel.pressedUnlockSectionStart()

        await fulfillment(of: [navigateExpectation], timeout: 1)
        XCTAssertNil(viewModel.lockedSectionAlert)
    }

    func test_pressedUnlockSectionStart_whenLockedSectionAlertisSetButTopicIsNil_doesNotCallNavigate() async {
        let mockCoordinator = MockRecoCoordinator()
        let navigateExpectation = expectation(description: "navigate was not called")
        navigateExpectation.isInverted = true
        mockCoordinator.expectations[.navigate] = navigateExpectation
        let viewModel = getViewModel(nav: mockCoordinator)
        viewModel.lockedSectionAlert = FeedSection(type: .mostPopular, state: .unlock, topic: nil)

        XCTAssertNotNil(viewModel.lockedSectionAlert)
        XCTAssertNil(viewModel.lockedSectionAlert?.topic)
        await viewModel.pressedUnlockSectionStart()

        await fulfillment(of: [navigateExpectation], timeout: 1)
        XCTAssertNil(viewModel.lockedSectionAlert)
    }

    // MARK: - pressedLocked

    func test_pressedLocked_setsLockedSectionAlert() {
        let viewModel = getViewModel()
        let feedSection = Mocks.feedSections[0]

        XCTAssertNil(viewModel.lockedSectionAlert)
        viewModel.pressedLocked(section: feedSection)

        XCTAssertEqual(feedSection, viewModel.lockedSectionAlert)
    }

    // MARK: - getFeedItems

    func test_getFeedItems_whenGetFeedFails_updatesSectionsAndItems() async {
        let mockFeedRepository = MockFeedRepository()
        let getFeedExpectation1 = expectation(description: "getFeed was not called")
        mockFeedRepository.expectations[.getFeed] = getFeedExpectation1
        mockFeedRepository.expectedGetFeed = []
        let mockRecommendationRepository = MockRecommendationRepository()
        // Calls getFeedItems in constructor
        let viewModel = getViewModel(feedRepo: mockFeedRepository, recRepo: mockRecommendationRepository)
        await fulfillment(of: [getFeedExpectation1], timeout: 1)
        // Needs to be setup after viewModel.init
        let sections = Mocks.feedSections
        let expectedSectionsViewState = sections.map { FeedSectionViewState(section: $0, isLoading: false) }
        let getFeedExpectation2 = expectation(description: "getFeed was not called")
        mockFeedRepository.expectations[.getFeed] = getFeedExpectation2
        mockFeedRepository.expectedGetFeed = sections
        let getFeedSectionExpectation = expectation(description: "getFeedSection was not called \(sections.count) times")
        getFeedSectionExpectation.expectedFulfillmentCount = sections.count
        mockRecommendationRepository.expectations[.getFeedSection] = getFeedSectionExpectation

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.initialLoadError)
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertTrue(viewModel.items.isEmpty)
        await viewModel.getFeedItems()

        await fulfillment(of: [getFeedExpectation2, getFeedSectionExpectation], timeout: 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.sections, expectedSectionsViewState)
        XCTAssertFalse(viewModel.items.isEmpty)
        XCTAssertTrue(viewModel.errors.allSatisfy { $0.value == nil })
        XCTAssertNil(viewModel.initialLoadError)
    }

    func test_getFeedItems_whenGetFeedFails_updatesError() async {
        let mockFeedRepository = MockFeedRepository()
        let getFeedExpectation1 = expectation(description: "getFeed was not called")
        mockFeedRepository.expectations[.getFeed] = getFeedExpectation1
        mockFeedRepository.expectedGetFeed = []
        // Calls getFeedItems in constructor
        let viewModel = getViewModel(feedRepo: mockFeedRepository)
        await fulfillment(of: [getFeedExpectation1], timeout: 1)
        // Needs to be setup after viewModel.init
        let getFeedError = NSError(domain: "getFeedError", code: 0)
        mockFeedRepository.getFeedError = getFeedError
        let getFeedExpectation2 = expectation(description: "getFeed was not called")
        mockFeedRepository.expectations[.getFeed] = getFeedExpectation2

        XCTAssertNil(viewModel.initialLoadError)
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertTrue(viewModel.items.isEmpty)
        await viewModel.getFeedItems()

        await fulfillment(of: [getFeedExpectation2], timeout: 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(getFeedError, viewModel.initialLoadError as? NSError)
    }

    // MARK: - load

    func test_load_whenAllSectionsAreLocked_doesNothing() async {
        let mockFeedRepository = MockFeedRepository()
        mockFeedRepository.expectedGetFeed = []
        let getFeedExpectation = expectation(description: "getFeed was not called")
        mockFeedRepository.expectations[.getFeed] = getFeedExpectation
        // Calls getFeedItems in constructor
        let mockRecommendationRepository = MockRecommendationRepository()
        let viewModel = getViewModel(feedRepo: mockFeedRepository, recRepo: mockRecommendationRepository)
        await fulfillment(of: [getFeedExpectation], timeout: 1)
        // Needs to be setup after viewModel.init
        let getFeedSectionExpectation = expectation(description: "getFeedSection was not called")
        getFeedSectionExpectation.isInverted = true
        mockRecommendationRepository.expectations[.getFeedSection] = getFeedSectionExpectation
        let lockedSection = FeedSection(
            type: .mostPopular,
            state: .locked
        )
        viewModel.sections = [FeedSectionViewState(
            section: lockedSection,
            isLoading: false
        )]

        await viewModel.load(sections: [lockedSection])

        await fulfillment(of: [ getFeedSectionExpectation], timeout: 1)
    }

    func test_load_whenSectionIsNotLockedAndGetFeedSectionSucceeds_updatesItemsInThatSection() async {
        let mockFeedRepository = MockFeedRepository()
        mockFeedRepository.expectedGetFeed = []
        let getFeedExpectation = expectation(description: "getFeed was not called")
        mockFeedRepository.expectations[.getFeed] = getFeedExpectation
        // Calls getFeedItems in constructor
        let mockRecommendationRepository = MockRecommendationRepository()
        let viewModel = getViewModel(feedRepo: mockFeedRepository, recRepo: mockRecommendationRepository)
        await fulfillment(of: [getFeedExpectation], timeout: 1)
        // Needs to be setup after viewModel.init
        let getFeedSectionExpectation = expectation(description: "getFeedSection was not called")
        mockRecommendationRepository.expectations[.getFeedSection] = getFeedSectionExpectation
        mockRecommendationRepository.expectedGetFeedSection = [appUserRecommendation]
        let unlockedSection = FeedSection(
            type: .mostPopular,
            state: .unlock
        )
        viewModel.sections = [FeedSectionViewState(
            section: unlockedSection,
            isLoading: false
        )]

        XCTAssertTrue(viewModel.items.isEmpty)
        await viewModel.load(sections: [unlockedSection])

        await fulfillment(of: [ getFeedSectionExpectation], timeout: 1)
        XCTAssertEqual(viewModel.items[.mostPopular], [appUserRecommendation])
        XCTAssertFalse(viewModel.sections[0].isLoading)
    }

    func test_load_whenSectionIsNotLockedAndGetFeedSectionFails_updatesError() async {
        let mockFeedRepository = MockFeedRepository()
        mockFeedRepository.expectedGetFeed = []
        let getFeedExpectation = expectation(description: "getFeed was not called")
        mockFeedRepository.expectations[.getFeed] = getFeedExpectation
        // Calls getFeedItems in constructor
        let mockRecommendationRepository = MockRecommendationRepository()
        let viewModel = getViewModel(feedRepo: mockFeedRepository, recRepo: mockRecommendationRepository)
        await fulfillment(of: [getFeedExpectation], timeout: 1)
        // Needs to be setup after viewModel.init
        let getFeedSectionError = NSError(domain: "getFeedSection", code: 0)
        mockRecommendationRepository.getFeedSectionError = getFeedSectionError
        let getFeedSectionExpectation = expectation(description: "getFeedSection was not called")
        mockRecommendationRepository.expectations[.getFeedSection] = getFeedSectionExpectation
        let unlockedSection = FeedSection(
            type: .mostPopular,
            state: .unlock
        )
        viewModel.sections = [FeedSectionViewState(
            section: unlockedSection,
            isLoading: false
        )]

        await viewModel.load(sections: [unlockedSection])

        await fulfillment(of: [ getFeedSectionExpectation], timeout: 1)
        XCTAssertEqual(getFeedSectionError, viewModel.initialLoadError as? NSError)
    }
}
