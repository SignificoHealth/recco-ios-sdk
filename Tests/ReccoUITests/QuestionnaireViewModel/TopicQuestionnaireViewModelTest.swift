import XCTest
@testable import ReccoHeadless
@testable import ReccoUI

final class TopicQuestionnaireViewModelTest: XCTestCase {

    private func getViewModel(
        topic: ReccoTopic,
        reloadSection: ((Bool) -> Void)? = nil,
        nav: ReccoCoordinator? = nil,
        repo: QuestionnaireRepository? = nil
    ) -> TopicQuestionnaireViewModel {
        return TopicQuestionnaireViewModel(
            topic: topic,
            reloadSection: reloadSection ?? { _ in },
            nav: nav ?? MockRecoCoordinator(),
            repo: repo ?? MockQuestionnaireRepository()
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
}
