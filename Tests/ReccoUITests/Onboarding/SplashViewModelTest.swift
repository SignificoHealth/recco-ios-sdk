@testable import ReccoHeadless
@testable import ReccoUI
import XCTest

@MainActor
final class SplashViewModelTest: XCTestCase {
    // MARK: - init

    func test_init_whenCurrentUserChanges_itUpdatesUser() {
        let mockMeRepository = MockMeRepository()
        let mockMetricRepository = MockMetricRepository()
        let viewModel = SplashViewModel(meRepository: mockMeRepository, metricRepository: mockMetricRepository)
        let user = AppUser(id: "id", isOnboardingQuestionnaireCompleted: true)

        XCTAssertNil(viewModel.user)
        mockMeRepository._currentUser.value = user

        // swiftlint:disable:next todo
        // TODO: Improve me
        // Workaround to test ".receive(on: DispatchQueue.main)". We  need a way to pass that Scheduler from outside
        let expectation = self.expectation(description: "Test")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(user, viewModel.user)
    }

    // MARK: - onReccoSDKOpen

    func test_onReccoSDKOpen_logsReccoSDKOpenEvent() {
        let mockMeRepository = MockMeRepository()
        let mockMetricRepository = MockMetricRepository()
        let viewModel = SplashViewModel(meRepository: mockMeRepository, metricRepository: mockMetricRepository)

        let event = AppUserMetricEvent(category: .userSession, action: .reccoSDKOpen)
        let logEventExpectation = expectation(description: "log was not called")
        mockMetricRepository.expectations[.logEvent] = logEventExpectation
        mockMetricRepository.expectedEvent = event

        viewModel.onReccoSDKOpened()
        wait(for: [logEventExpectation], timeout: 1)
    }
}
