import XCTest
@testable import ReccoHeadless
@testable import ReccoUI

@MainActor
final class OnboardingQuestionnaireViewModelTest: XCTestCase {

    private func getViewModel(
        nextScreen: ((Bool) -> Void)? = nil,
        repo: QuestionnaireRepository? = nil,
        nav: ReccoCoordinator? = nil,
        logger: Logger? = nil
    ) -> OnboardingQuestionnaireViewModel {
        return OnboardingQuestionnaireViewModel(
            nextScreen: nextScreen ?? { _ in },
            repo: repo ?? MockQuestionnaireRepository(),
            nav: nav ?? MockRecoCoordinator(),
            logger: logger ?? Logger { _ in}
        )
    }

    // MARK: - init

    func test_init_getQuestionnaire_callsGetOnboardingQuestionnaire() async {
        let mockQuestionnaireRepository = MockQuestionnaireRepository()
        let getOnboardingQuestionnaireExpectation = expectation(description: "getOnboardingQuestionnaire was not called")
        mockQuestionnaireRepository.expectations[.getOnboardingQuestionnaire] = getOnboardingQuestionnaireExpectation
        let viewModel = getViewModel(repo: mockQuestionnaireRepository)

        await viewModel.getQuestionnaire()
        
        await fulfillment(of: [getOnboardingQuestionnaireExpectation], timeout: 1)
    }

    func test_init_sendQuestionsCallsSendQuestionnaire() async {
        let mockQuestionnaireRepository = MockQuestionnaireRepository()
        let sendOnboardingQuestionnaireExpectation = expectation(description: "sendOnboardingQuestionnaire was not called with")
        mockQuestionnaireRepository.expectations[.sendOnboardingQuestionnaire] = sendOnboardingQuestionnaireExpectation
        let viewModel = getViewModel(repo: mockQuestionnaireRepository)
        let questions = Mocks.numericQuestions
        viewModel.questions = questions
        // Place it in the last question
        viewModel.currentQuestion = questions.last

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        viewModel.next()

        await fulfillment(of: [sendOnboardingQuestionnaireExpectation], timeout: 1)
    }

    func test_init_whenSendQuestionsSucceeds_callsReloadSectionAndNavigatesToBack() async {
        let mockQuestionnaireRepository = MockQuestionnaireRepository()
        let sendOnboardingQuestionnaireExpectation = expectation(description: "sendOnboardingQuestionnaire was not called with")
        mockQuestionnaireRepository.expectations[.sendOnboardingQuestionnaire] = sendOnboardingQuestionnaireExpectation
        let nextScreenExpectation = expectation(description: "nextScreen was not called with")
        let nextScreen: (Bool) -> Void = { didAnswerAllQuestions in
            nextScreenExpectation.fulfill()
        }
        let viewModel = getViewModel(nextScreen: nextScreen, repo: mockQuestionnaireRepository)
        let questions = Mocks.numericQuestions
        viewModel.questions = questions
        // Place it in the last question
        viewModel.currentQuestion = questions.last

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        viewModel.next()

        await fulfillment(of: [sendOnboardingQuestionnaireExpectation, nextScreenExpectation], timeout: 1)
    }
}
