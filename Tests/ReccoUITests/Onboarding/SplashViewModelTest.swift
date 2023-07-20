import XCTest
@testable import ReccoHeadless
@testable import ReccoUI

final class SplashViewModelTest: XCTestCase {

    func test_init_whenCurrentUserChanges_itUpdatesUser() {
        let mockMeRepository = MockMeRepository()
        let viewModel = SplashViewModel(repo: mockMeRepository)
        let user = AppUser(id: "id", isOnboardingQuestionnaireCompleted: true)

        XCTAssertNil(viewModel.user)
        mockMeRepository._currentUser.value = user

        // TODO: Improve me
        // Workaround to test ".receive(on: DispatchQueue.main)". We  need a way to pass that Scheduler from outside
        let expectation = self.expectation(description: "Test")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 1)


        XCTAssertEqual(user, viewModel.user)
    }
}


