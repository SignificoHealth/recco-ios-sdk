@testable import ReccoUI
import XCTest

@MainActor
final class OnboardingViewModelTest: XCTestCase {
    // MARK: - next

    func test_next_whenCalledOneTime_incrementsCurrentPage() {
        let viewModel = OnboardingViewModel(nav: MockRecoCoordinator())

        XCTAssertEqual(viewModel.currentPage, 1)
        viewModel.next()
        XCTAssertEqual(viewModel.currentPage, 2)
    }

    func test_next_whenCalledThreeTimes_navigatesToOnboardingQuestionnaire() {
        let mockCoordinator = MockRecoCoordinator()
        let viewModel = OnboardingViewModel(nav: mockCoordinator)
        let expectedDestination = Destination.onboardingQuestionnaire
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation

        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.totalPages, 3)
        viewModel.next()
        viewModel.next()
        XCTAssertEqual(viewModel.currentPage, 3)
        viewModel.next()
        XCTAssertEqual(viewModel.currentPage, 3)

        wait(for: [navigateExpectation], timeout: 1)
    }

    // MARK: - close

    func test_close_navigatesToDismiss() {
        let mockCoordinator = MockRecoCoordinator()
        let viewModel = OnboardingViewModel(nav: mockCoordinator)
        let expectedDestination = Destination.dismiss
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation

        viewModel.close()

        wait(for: [navigateExpectation], timeout: 1)
    }
}
