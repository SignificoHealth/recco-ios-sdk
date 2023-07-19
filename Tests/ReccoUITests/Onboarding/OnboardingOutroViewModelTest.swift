import XCTest
@testable import ReccoUI

final class OnboardingOutroViewModelTest: XCTestCase {

    func test_goToDashboardPressed_whenGetMeFails_throwsAnError() async throws {
        let mockMeRepository = MockMeRepository()
        let viewModel = OnboardingOutroViewModel(meRepo: mockMeRepository, nav: MockRecoCoordinator())
        let getMeError = NSError(domain: "GetMeError", code: 0)
        mockMeRepository.getMeError = getMeError
        let getMeExpectation = expectation(description: "GetMe was not called")
        mockMeRepository.expectations[.getMe] = getMeExpectation

        viewModel.goToDashboardPressed()

        await fulfillment(of: [getMeExpectation], timeout: 1)
        XCTAssertEqual(getMeError, viewModel.meError as? NSError)
    }

    func test_goToDashboardPressed_whenGetMeSuccess_doesNotThrowsAnError() async throws {
        let mockMeRepository = MockMeRepository()
        let viewModel = OnboardingOutroViewModel(meRepo: mockMeRepository, nav: MockRecoCoordinator())
        let getMeExpectation = expectation(description: "GetMe was not called")
        mockMeRepository.expectations[.getMe] = getMeExpectation

        viewModel.goToDashboardPressed()

        await fulfillment(of: [getMeExpectation], timeout: 1)
        XCTAssertNil(viewModel.meError)
    }

    func test_close_navigatesToDismiss() {
        let mockCoordinator = MockRecoCoordinator()
        let viewModel = OnboardingOutroViewModel(meRepo: MockMeRepository(), nav: mockCoordinator)
        let expectedDestination = Destination.dismiss
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "Navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation

        viewModel.close()

        wait(for: [navigateExpectation], timeout: 1)
    }
}
