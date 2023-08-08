import XCTest
@testable import ReccoHeadless
@testable import ReccoUI

final class QuestionnaireViewModelTest: XCTestCase {

    let questions = Mocks.numericQuestions
    var answers: [Question: CreateQuestionnaireAnswer] {
        var result = [Question: CreateQuestionnaireAnswer]()
        questions.forEach {
            result[$0] = CreateQuestionnaireAnswer(value: $0.answer, questionId: $0.id, type: $0.type, questionnaireId: $0.questionnaireId)
        }
        return result
    }

    private func getViewModel(
        repo: QuestionnaireRepository? = nil,
        nav: ReccoCoordinator? = nil,
        shouldValidateAllAnswersOnQuestionChange: Bool? = nil,
        mainButtonEnabledByDefault: Bool? = nil,
        nextScreen: ((Bool) -> Void)? = nil,
        getQuestions: ((QuestionnaireRepository) async throws -> [Question])? = nil,
        sendQuestions: ((QuestionnaireRepository, [CreateQuestionnaireAnswer]) async throws -> Void)? = nil
    ) -> QuestionnaireViewModel {
        return QuestionnaireViewModel(
            repo: repo ?? MockQuestionnaireRepository(),
            nav: nav ?? MockRecoCoordinator(),
            shouldValidateAllAnswersOnQuestionChange: shouldValidateAllAnswersOnQuestionChange ?? false,
            mainButtonEnabledByDefault: mainButtonEnabledByDefault ?? false,
            nextScreen: nextScreen ?? { _ in },
            getQuestions: getQuestions ?? { repo in try await repo.getOnboardingQuestionnaire() },
            sendQuestions: sendQuestions ?? { repo, answers in try await repo.sendQuestionnaire(answers) }
        )
    }

    // MARK: - init

    func test_init_whenShouldValidateAllAnswersOnQuestionChangeIsFalse_doesNotCallsValidateAnswerOnQuestionChange() throws {
        let (questions, answers) = try Mocks.getNumericQuestionsWithAnswers(
            answers: [Mocks.numericCorrectAnswer, Mocks.numericCorrectAnswer]
        )
        let viewModel = getViewModel(shouldValidateAllAnswersOnQuestionChange: true, mainButtonEnabledByDefault: false)
        viewModel.questions = questions
        viewModel.answers = answers

        XCTAssertFalse(viewModel.mainButtonEnabled)
        viewModel.currentQuestion = questions.first

        XCTAssertTrue(viewModel.mainButtonEnabled)
    }

    func test_init_whenShouldValidateAllAnswersOnQuestionChangeIsTrue_callsValidateAnswerOnQuestionChange() throws {
        let (questions, answers) = try Mocks.getNumericQuestionsWithAnswers(
            answers: [Mocks.numericCorrectAnswer, Mocks.numericCorrectAnswer]
        )
        let viewModel = getViewModel(shouldValidateAllAnswersOnQuestionChange: false, mainButtonEnabledByDefault: false)
        viewModel.questions = questions
        viewModel.answers = answers

        XCTAssertFalse(viewModel.mainButtonEnabled)
        viewModel.currentQuestion = questions.first

        XCTAssertFalse(viewModel.mainButtonEnabled)
    }

    // MARK: - previousQuestion

    func test_previousQuestion_whenCurrentIndexIsZero_doesNothing() async {
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.currentQuestion = questions.first

        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertEqual(viewModel.currentQuestion, questions.first)
        await viewModel.previousQuestion()

        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertEqual(viewModel.currentQuestion, questions.first)
    }

    func test_previousQuestion_whenCurrentIndexIsHigherThanZero_changesCurrentQuestionToThePreviousOne() async {
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.currentQuestion = questions[1]

        XCTAssertEqual(viewModel.currentIndex, 1)
        XCTAssertEqual(viewModel.currentQuestion, questions[1])
        await viewModel.previousQuestion()

        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertEqual(viewModel.currentQuestion, questions.first)
    }

    // MARK: - next

    func test_next_whenNotInLastQuestion_changesCurrentQuestionToTheNextOne() async {
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.currentQuestion = questions.first

        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertEqual(viewModel.currentQuestion, questions.first)
        await viewModel.next()

        XCTAssertEqual(viewModel.currentIndex, 1)
        XCTAssertEqual(viewModel.currentQuestion, questions[1])
    }

    func test_next_whenInLastQuestion_callsSendQuestions() async {
        let sendQuestionsExpectation = expectation(description: "sendQuestions was not called")
        let sendQuestions: (QuestionnaireRepository, [CreateQuestionnaireAnswer]) async throws -> Void = { _, _ in
            sendQuestionsExpectation.fulfill()
        }
        let viewModel = getViewModel(sendQuestions: sendQuestions)
        viewModel.questions = questions
        viewModel.currentQuestion = questions.last

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        XCTAssertEqual(viewModel.currentQuestion, questions.last)
        await viewModel.next()

        await fulfillment(of: [sendQuestionsExpectation], timeout: 1)
    }

    // MARK: - answer

    func test_answer_whenIsValidSingleChoiceAndNotLastQuestion_callsNextAndEnablesMainButton() async throws {
        let questions = Mocks.singleChoiceQuestions
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.currentQuestion = questions.first

        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertFalse(viewModel.mainButtonEnabled)
        await viewModel.answer(Mocks.singleChoiceCorrectAnswer, for: questions.first!)

        XCTAssertEqual(viewModel.currentIndex, 1)
        XCTAssertTrue(viewModel.mainButtonEnabled)
    }

    func test_answer_whenIsValidSingleChoiceAndLastQuestion_enablesMainButtonAndDoesNotCallsNext() async throws {
        let questions = Mocks.singleChoiceQuestions
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.currentQuestion = questions.last

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        XCTAssertFalse(viewModel.mainButtonEnabled)
        await viewModel.answer(Mocks.singleChoiceCorrectAnswer, for: questions.last!)

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        XCTAssertTrue(viewModel.mainButtonEnabled)
    }

    func test_answer_whenIsValidNumericAndNotLastQuestion_enablesMainButtonAndDoesNotCallsNext() async throws {
        let questions = Mocks.numericQuestions
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.currentQuestion = questions.first

        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertFalse(viewModel.mainButtonEnabled)
        await viewModel.answer(Mocks.numericCorrectAnswer, for: questions.first!)

        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertTrue(viewModel.mainButtonEnabled)
    }

    func test_answer_whenIsLastQuestionAndShouldValidateAllAnswersOnQuestionChangeIsTrueAndAllAnswersAreValid_enablesMainButton() async throws {
        let (questions, answers) = try Mocks.getNumericQuestionsWithAnswers(answers: [
            Mocks.numericCorrectAnswer,
            Mocks.numericCorrectAnswer,
            Mocks.numericInvalidAnswer
        ])
        let viewModel = getViewModel(shouldValidateAllAnswersOnQuestionChange: true)
        viewModel.questions = questions
        viewModel.currentQuestion = questions.last
        viewModel.answers = answers

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        XCTAssertFalse(viewModel.mainButtonEnabled)
        await viewModel.answer(Mocks.numericCorrectAnswer, for: questions.last!)

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        XCTAssertTrue(viewModel.mainButtonEnabled)
    }

    func test_answer_whenIsLastQuestionAndShouldValidateAllAnswersOnQuestionChangeIsTrueAndNotAllAnswersAreValid_disablesMainButton() async throws {
        let (questions, answers) = try Mocks.getNumericQuestionsWithAnswers(answers: [
            Mocks.numericInvalidAnswer,
            Mocks.numericInvalidAnswer,
            Mocks.numericInvalidAnswer
        ])
        let viewModel = getViewModel(shouldValidateAllAnswersOnQuestionChange: true)
        viewModel.questions = questions
        viewModel.currentQuestion = questions.last
        viewModel.answers = answers

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        XCTAssertFalse(viewModel.mainButtonEnabled)
        await viewModel.answer(Mocks.numericCorrectAnswer, for: questions.last!)

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        XCTAssertFalse(viewModel.mainButtonEnabled)
    }

    func test_answer_whenIsLastQuestionAndShouldValidateAllAnswersOnQuestionChangeIsFalseAndAllAnswersAreValid_enablesMainButton() async throws {
        let (questions, answers) = try Mocks.getNumericQuestionsWithAnswers(answers: [
            Mocks.numericCorrectAnswer,
            Mocks.numericCorrectAnswer,
            Mocks.numericCorrectAnswer
        ])
        let viewModel = getViewModel(shouldValidateAllAnswersOnQuestionChange: false)
        viewModel.questions = questions
        viewModel.currentQuestion = questions.last
        viewModel.answers = answers

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        XCTAssertFalse(viewModel.mainButtonEnabled)
        await viewModel.answer(Mocks.numericCorrectAnswer, for: questions.last!)

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        XCTAssertTrue(viewModel.mainButtonEnabled)
    }

    func test_answer_whenIsLastQuestionAndIsShouldValidateAllAnswersOnQuestionChangeIsFalseAndNotAllAnswersAreValid_disablesMainButton() async throws {
        let invalidAnswer = EitherAnswerType.numeric(20)
        let (questions, answers) = try Mocks.getNumericQuestionsWithAnswers(answers: [
            Mocks.numericCorrectAnswer,
            Mocks.numericCorrectAnswer,
            invalidAnswer
        ])
        let viewModel = getViewModel(shouldValidateAllAnswersOnQuestionChange: false)
        viewModel.questions = questions
        viewModel.currentQuestion = questions.last
        viewModel.answers = answers

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        XCTAssertFalse(viewModel.mainButtonEnabled)
        await viewModel.answer(invalidAnswer, for: questions.last!)

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        XCTAssertFalse(viewModel.mainButtonEnabled)
    }

    func test_answer_whenIsSingleChoiceQuestionAndAnswerIsValid_enablesMainButtonAndCallsNext() async throws {
        let (questions, answers) = try Mocks.getSingleChoiceQuestionsWithAnswers(answers: [
            Mocks.singleChoiceCorrectAnswer,
            Mocks.singleChoiceCorrectAnswer,
            Mocks.singleChoiceCorrectAnswer
        ])
        let sendQuestionsExpectation = expectation(description: "sendQuestions was called")
        sendQuestionsExpectation.isInverted = true
        let sendQuestions: (QuestionnaireRepository, [CreateQuestionnaireAnswer]) async throws -> Void = { _, _ in
            sendQuestionsExpectation.fulfill()
        }
        let viewModel = getViewModel(shouldValidateAllAnswersOnQuestionChange: false, sendQuestions: sendQuestions)
        viewModel.questions = questions
        viewModel.currentQuestion = questions.first
        viewModel.answers = answers

        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertFalse(viewModel.mainButtonEnabled)
        await viewModel.answer(Mocks.singleChoiceCorrectAnswer, for: questions.first!)
        await fulfillment(of: [sendQuestionsExpectation], timeout: 1)

        XCTAssertEqual(viewModel.currentIndex, 1)
        XCTAssertTrue(viewModel.mainButtonEnabled)
    }

    func test_answer_whenIsNotLastSingleChoiceQuestionAndAllAnswersAreValid_enablesMainButtonAndDoesNotCallsNext() async throws {
        let (questions, answers) = try Mocks.getNumericQuestionsWithAnswers(answers: [
            Mocks.numericCorrectAnswer,
            Mocks.numericCorrectAnswer,
            Mocks.numericCorrectAnswer
        ])
        let sendQuestionsExpectation = expectation(description: "sendQuestions was called")
        sendQuestionsExpectation.isInverted = true
        let sendQuestions: (QuestionnaireRepository, [CreateQuestionnaireAnswer]) async throws -> Void = { _, _ in
            sendQuestionsExpectation.fulfill()
        }
        let viewModel = getViewModel(shouldValidateAllAnswersOnQuestionChange: false, sendQuestions: sendQuestions)
        viewModel.questions = questions
        viewModel.currentQuestion = questions.first
        viewModel.answers = answers

        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertFalse(viewModel.mainButtonEnabled)
        await viewModel.answer(Mocks.numericCorrectAnswer, for: questions.first!)
        await fulfillment(of: [sendQuestionsExpectation], timeout: 1)

        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertTrue(viewModel.mainButtonEnabled)
    }


    // MARK: - getQuestionnaire

    func test_getQuestionnaire_whenGetQuestionsSucceeds_updatesQuestionsAndAnswersAndCurrentQuestion() async {
        let getQuestionsExpectation = expectation(description: "getQuestions was not called")
        let getQuestions: (QuestionnaireRepository) async throws -> [Question] = { _ in
            getQuestionsExpectation.fulfill()
            return self.questions
        }
        let viewModel = getViewModel(getQuestions: getQuestions)

        await viewModel.getQuestionnaire()

        await fulfillment(of: [getQuestionsExpectation], timeout: 1)
        XCTAssertNil(viewModel.initialLoadError)
        XCTAssertEqual(viewModel.questions, questions)
        XCTAssertEqual(viewModel.currentQuestion, questions.first)
        XCTAssertEqual(viewModel.answers, answers)
    }

    func test_getQuestionnaire_whenGetQuestionsFails_updatesError() async {
        let getQuestionsExpectation = expectation(description: "getQuestions was not called")
        let getQuestionsError = NSError(domain: "getQuestions", code: 0)
        let getQuestions: (QuestionnaireRepository) async throws -> [Question] = { _ in
            getQuestionsExpectation.fulfill()
            throw getQuestionsError
        }
        let viewModel = getViewModel(getQuestions: getQuestions)

        await viewModel.getQuestionnaire()

        await fulfillment(of: [getQuestionsExpectation], timeout: 1)
        XCTAssertNotNil(viewModel.initialLoadError)
        XCTAssertEqual(viewModel.initialLoadError as? NSError, getQuestionsError)
        XCTAssertNil(viewModel.questions)
        XCTAssertNil(viewModel.currentQuestion)
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

        wait(for: [navigateExpectation], timeout: 1)
    }

    // MARK: - shouldChangeToNextQuestion

    func test_shouldChangeToNextQuestion_whenQuestionIsSingleChoiceAndAnswerIsValidAndIsNotLastQuestion_shouldReturnTrue() {
        let questions = Mocks.singleChoiceQuestions
        let currentQuestion = questions.first!
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.currentQuestion = currentQuestion

        let result = viewModel.shouldChangeToNextQuestion(question: currentQuestion, answer: Mocks.singleChoiceCorrectAnswer, isAnswerValid: true)

        XCTAssertTrue(result)
    }

    func test_shouldChangeToNextQuestion_whenQuestionIsSingleChoiceAndAnswerIsValidAndIsLastQuestion_shouldReturnFalse() {
        let questions = Mocks.singleChoiceQuestions
        let currentQuestion = questions.last!
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.currentQuestion = currentQuestion

        let result = viewModel.shouldChangeToNextQuestion(question: currentQuestion, answer: Mocks.singleChoiceCorrectAnswer, isAnswerValid: true)


        XCTAssertFalse(result)
    }

    func test_shouldChangeToNextQuestion_whenQuestionIsSingleChoiceAndAnswerIsNotValidAndIsNotLastQuestion_shouldReturnFalse() {
        let questions = Mocks.singleChoiceQuestions
        let currentQuestion = questions.first!
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.currentQuestion = currentQuestion

        let result = viewModel.shouldChangeToNextQuestion(question: currentQuestion, answer: Mocks.singleChoiceCorrectAnswer, isAnswerValid: false)


        XCTAssertFalse(result)
    }

    func test_shouldChangeToNextQuestion_whenQuestionIsMultiChoiceAndAnswerIsValidAndIsNotLastQuestion_shouldReturnFalse() {
        let questions = Mocks.multiChoiceQuestions
        let currentQuestion = questions.first!
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.currentQuestion = currentQuestion

        let result = viewModel.shouldChangeToNextQuestion(question: currentQuestion, answer: Mocks.multiChoiceCorrectAnswer, isAnswerValid: true)


        XCTAssertFalse(result)
    }

    func test_shouldChangeToNextQuestion_whenQuestionIsNumericAndAnswerIsValidAndIsNotLastQuestion_shouldReturnFalse() {
        let questions = Mocks.numericQuestions
        let currentQuestion = questions.first!
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.currentQuestion = currentQuestion

        let result = viewModel.shouldChangeToNextQuestion(question: currentQuestion, answer: Mocks.numericCorrectAnswer, isAnswerValid: true)


        XCTAssertFalse(result)
    }

    // MARK: - sendQuestionnaire

    func test_init_whenSendQuestionsFails_doesNotCallsNextScreenAndUpdatesError() async {
        let sendQuestionsError = NSError(domain: "sendQuestions", code: 0)
        let sendQuestionsExpectation = expectation(description: "sendQuestions was not called")
        let sendQuestions: (QuestionnaireRepository, [CreateQuestionnaireAnswer]) throws -> Void = { _, _ in
            sendQuestionsExpectation.fulfill()
            throw sendQuestionsError
        }
        let nextScreenExpectation = expectation(description: "nextScreen was called")
        nextScreenExpectation.isInverted = true
        let nextScreen: (Bool) -> Void = { _ in
            nextScreenExpectation.fulfill()
        }
        let viewModel = getViewModel(
            nextScreen: nextScreen,
            sendQuestions: sendQuestions
        )
        viewModel.questions = questions
        viewModel.answers = answers
        // Place it in the last question
        viewModel.currentQuestion = questions.last

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        await viewModel.next()

        await fulfillment(of: [sendQuestionsExpectation, nextScreenExpectation], timeout: 1)
        XCTAssertEqual(sendQuestionsError, viewModel.sendError as? NSError)
    }

    func test_init_whenSendQuestionsSucceeds_callsNextScreen() async throws {
        let nextScreenExpectation = expectation(description: "nextScreen was not called")
        let nextScreen: (Bool) -> Void = { _ in
            nextScreenExpectation.fulfill()
        }
        // Using Set because the order is not guaranteed
        let expectedSendQuestionsAnswers = Set(answers.values)
        let sendQuestionsExpectation = expectation(description: "sendQuestions was not called")
        let sendQuestions: (QuestionnaireRepository, [CreateQuestionnaireAnswer]) -> Void = { _, answers in
            XCTAssertEqual(expectedSendQuestionsAnswers, Set(answers))
            sendQuestionsExpectation.fulfill()
        }
        let viewModel = getViewModel(
            nextScreen: nextScreen,
            sendQuestions: sendQuestions
        )
        viewModel.questions = questions
        viewModel.answers = answers
        // Place it in the last question
        viewModel.currentQuestion = questions.last

        XCTAssertEqual(viewModel.currentIndex, questions.count - 1)
        await viewModel.next()

        await fulfillment(of: [sendQuestionsExpectation, nextScreenExpectation], timeout: 1)
        XCTAssertNil(viewModel.sendError)
    }

    // MARK: - validate - numeric

    func test_validate_numericQuestionWithMultiChoiceAnswerAndMandatory_returnsFalse() {
        let question = Mocks.numericQuestion
        let answer = EitherAnswerType.multiChoice([])
        let viewModel = getViewModel()

        let isValid = viewModel.validate(answer: answer, for: question, mandatoryAnswer: true)

        XCTAssertFalse(isValid)
    }

    func test_validate_numericQuestionWithMultiChoiceAnswerAndNotMandatory_returnsTrue() {
        let question = Mocks.numericQuestion
        let answer = EitherAnswerType.multiChoice([])
        let viewModel = getViewModel()

        let isValid = viewModel.validate(answer: answer, for: question, mandatoryAnswer: false)

        XCTAssertTrue(isValid)
    }

    func test_validate_numericQuestionWithCorrectNumericAnswer_returnsTrue() {
        let question = Mocks.numericQuestion
        let answer = Mocks.numericCorrectAnswer
        let viewModel = getViewModel()

        let isValid = viewModel.validate(answer: answer, for: question, mandatoryAnswer: true)

        XCTAssertTrue(isValid)
    }

    func test_validate_numericQuestionWithInvalidNumericAnswer_returnsFalse() {
        let question = Mocks.numericQuestion
        let answer = Mocks.numericInvalidAnswer
        let viewModel = getViewModel()

        let isValid = viewModel.validate(answer: answer, for: question, mandatoryAnswer: true)

        XCTAssertFalse(isValid)
    }

    // MARK: - validate - multiChoice

    func test_validate_multiChoiceQuestionWithNumericAnswerAndMandatory_returnsFalse() {
        let question = Mocks.multiChoiceQuestion
        let answer = EitherAnswerType.numeric(1)
        let viewModel = getViewModel()

        let isValid = viewModel.validate(answer: answer, for: question, mandatoryAnswer: true)

        XCTAssertFalse(isValid)
    }

    func test_validate_multiChoiceQuestionWithNumericAnswerAndNotMandatory_returnsTrue() {
        let question = Mocks.multiChoiceQuestion
        let answer = EitherAnswerType.numeric(1)
        let viewModel = getViewModel()

        let isValid = viewModel.validate(answer: answer, for: question, mandatoryAnswer: false)

        XCTAssertTrue(isValid)
    }

    func test_validate_multiChoiceQuestionWithCorrectMultiChoiceAnswer_returnsTrue() {
        let question = Mocks.multiChoiceQuestion
        let answer = Mocks.multiChoiceCorrectAnswer
        let viewModel = getViewModel()

        let isValid = viewModel.validate(answer: answer, for: question, mandatoryAnswer: true)

        XCTAssertTrue(isValid)
    }

    func test_validate_multiChoiceQuestionWithEmptyMultiChoiceAnswer_returnsFalse() {
        let question = Mocks.multiChoiceQuestion
        let answer = EitherAnswerType.multiChoice([])
        let viewModel = getViewModel()

        let isValid = viewModel.validate(answer: answer, for: question, mandatoryAnswer: true)

        XCTAssertFalse(isValid)
    }

    func test_validate_multiChoiceQuestionWithNilMultiChoiceAnswer_returnsFalse() {
        let question = Mocks.multiChoiceQuestion
        let answer = EitherAnswerType.multiChoice(nil)
        let viewModel = getViewModel()

        let isValid = viewModel.validate(answer: answer, for: question, mandatoryAnswer: true)

        XCTAssertFalse(isValid)
    }

    // MARK: - validateAll

    func test_validateAll_whenAllAnswersAreValidAndMandatory_returnsTrue() throws {
        let (questions, answers) = try Mocks.getNumericQuestionsWithAnswers(answers: [
            Mocks.numericCorrectAnswer,
            Mocks.numericCorrectAnswer,
            Mocks.numericCorrectAnswer
        ])
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.answers = answers

        let isValid = viewModel.validateAll(until: questions.last!, mandatoryAnswer: true)

        XCTAssertTrue(isValid)
    }

    func test_validateAll_whenSomeAnswersAreValidAndMandatory_returnsFalse() throws {
        let (questions, answers) = try Mocks.getNumericQuestionsWithAnswers(answers: [
            Mocks.numericCorrectAnswer,
            Mocks.numericInvalidAnswer,
            Mocks.numericInvalidAnswer
        ])
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.answers = answers

        let isValid = viewModel.validateAll(until: questions.last!, mandatoryAnswer: true)

        XCTAssertFalse(isValid)
    }

    func test_validateAll_whenSomeAnswersAreValidAndNotMandatory_returnsTrue() throws {
        let (questions, answers) = try Mocks.getNumericQuestionsWithAnswers(answers: [
            Mocks.numericCorrectAnswer,
            Mocks.numericInvalidAnswer,
            Mocks.numericInvalidAnswer
        ])
        let viewModel = getViewModel()
        viewModel.questions = questions
        viewModel.answers = answers

        let isValid = viewModel.validateAll(until: questions.last!, mandatoryAnswer: false)
        
        XCTAssertTrue(isValid)
    }

}
