import XCTest
@testable import ReccoHeadless
@testable import ReccoUI

final class TopicQuestionnaireViewModelTest: XCTestCase {

    private func getViewModel(
        topic: ReccoTopic,
        reloadSection: ((Bool) -> Void)? = nil,
        repo: QuestionnaireRepository? = nil,
        nav: ReccoCoordinator? = nil
    ) -> TopicQuestionnaireViewModel {
        return TopicQuestionnaireViewModel(
            topic: topic,
            reloadSection: reloadSection ?? { _ in },
            repo: repo ?? MockQuestionnaireRepository(),
            nav: nav ?? MockRecoCoordinator()
        )
    }

    // MARK: - init

    func test_init_getQuestionnaire_callsGetQuestionsWithCorrectTopic() async {
        let mockQuestionnaireRepository = MockQuestionnaireRepository()
        let topic = ReccoTopic.nutrition
        let getQuestionnaireExpectation = expectation(description: "getQuestionnaire was not called with topic: \(topic.rawValue)")
        mockQuestionnaireRepository.expectations[.getQuestionnaire] = getQuestionnaireExpectation
        let viewModel = getViewModel(topic: topic, repo: mockQuestionnaireRepository)

        await viewModel.getQuestionnaire()

        await fulfillment(of: [getQuestionnaireExpectation], timeout: 1)
    }

    func test_init_sendQuestionsCallsSendQuestionnaire() async {
        let mockQuestionnaireRepository = MockQuestionnaireRepository()
        let topic = ReccoTopic.nutrition
        let sendQuestionnaireExpectation = expectation(description: "sendQuestionnaire was not called with")
        mockQuestionnaireRepository.expectations[.sendQuestionnaire] = sendQuestionnaireExpectation
        let viewModel = getViewModel(topic: topic, repo: mockQuestionnaireRepository)
        let questions = Mocks.numericQuestions
        viewModel.questions = questions
        // Place it in the last question
        viewModel.currentQuestion = questions.last

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        await viewModel.next()

        await fulfillment(of: [sendQuestionnaireExpectation], timeout: 1)
    }

    func test_init_whenSendQuestionsSucceeds_callsReloadSectionAndNavigatesToBack() async {
        let mockQuestionnaireRepository = MockQuestionnaireRepository()
        let topic = ReccoTopic.nutrition
        let sendQuestionnaireExpectation = expectation(description: "sendQuestionnaire was not called with")
        mockQuestionnaireRepository.expectations[.sendQuestionnaire] = sendQuestionnaireExpectation
        let mockCoordinator = MockRecoCoordinator()
        let expectedDestination = Destination.back
        mockCoordinator.expectedDestination = expectedDestination
        let navigateExpectation = expectation(description: "Navigate was not called with: \(expectedDestination)")
        mockCoordinator.expectations[.navigate] = navigateExpectation
        let reloadSectionExpectation = expectation(description: "reloadSection was not called with")
        let reloadSection: (Bool) -> Void = { didAnswerAllQuestions in
            reloadSectionExpectation.fulfill()
        }
        let viewModel = getViewModel(
            topic: topic,
            reloadSection: reloadSection,
            repo: mockQuestionnaireRepository,
            nav: mockCoordinator
        )
        let questions = Mocks.numericQuestions
        viewModel.questions = questions
        // Place it in the last question
        viewModel.currentQuestion = questions.last

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        await viewModel.next()

        await fulfillment(of: [sendQuestionnaireExpectation, reloadSectionExpectation, navigateExpectation], timeout: 1)
    }
}
