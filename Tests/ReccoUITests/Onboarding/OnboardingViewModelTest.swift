import XCTest
@testable import ReccoUI

final class OnboardingViewModelTest: XCTestCase {

    func testNext() {
        let mockCoordinator = MockRecoCoordinator()
        let viewModel = OnboardingViewModel(nav: mockCoordinator)
        let expectedDestination = Destination.onboardingQuestionnaire
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "Navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation

        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.totalPages, 3)
        viewModel.next()
        XCTAssertEqual(viewModel.currentPage, 2)
        viewModel.next()
        XCTAssertEqual(viewModel.currentPage, 3)
        viewModel.next()

        wait(for: [navigateExpectation], timeout: 1)
    }

    func testClose() {
        let mockCoordinator = MockRecoCoordinator()
        let viewModel = OnboardingViewModel(nav: mockCoordinator)
        let expectedDestination = Destination.dismiss
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "Navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation

        viewModel.close()

        wait(for: [navigateExpectation], timeout: 1)
    }
}
