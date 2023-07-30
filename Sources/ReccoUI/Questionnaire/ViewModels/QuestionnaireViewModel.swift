import Foundation
import ReccoHeadless
import Combine

class QuestionnaireViewModel: ObservableObject {
    private let nav: ReccoCoordinator
    private let repo: QuestionnaireRepository
    private let nextScreen: (Bool) -> Void
    private let getQuestions: (QuestionnaireRepository) async throws -> [Question]
    private let sendQuestions: (QuestionnaireRepository, [CreateQuestionnaireAnswer]) async throws -> Void

    @Published var currentQuestion: Question?
    @Published var questions: [Question]?
    @Published var answers: [Question: CreateQuestionnaireAnswer?] = [:]
    @Published var initialLoadError: Error?
    @Published var sendError: Error?
    @Published var sendLoading: Bool = false
    @Published var mainButtonEnabled: Bool
    
    var currentIndex: Int {
        currentQuestion.flatMap {
            questions?.firstIndex(of: $0)
        } ?? 0
    }
    
    var isOnLastQuestion: Bool {
        return currentIndex == (questions?.count ?? 0) - 1
    }

    private var shouldValidateAnswerOnQuestionChange: Bool

    init(
        repo: QuestionnaireRepository,
        nav: ReccoCoordinator,
        shouldValidateAnswerOnQuestionChange: Bool,
        mainButtonEnabledByDefault: Bool,
        nextScreen: @escaping (Bool) -> Void,
        getQuestions: @escaping (QuestionnaireRepository) async throws -> [Question],
        sendQuestions: @escaping (QuestionnaireRepository, [CreateQuestionnaireAnswer]) async throws -> Void
    ) {
        self.repo = repo
        self.nextScreen = nextScreen
        self.getQuestions = getQuestions
        self.mainButtonEnabled = mainButtonEnabledByDefault
        self.sendQuestions = sendQuestions
        self.nav = nav
        self.shouldValidateAnswerOnQuestionChange = shouldValidateAnswerOnQuestionChange

        if shouldValidateAnswerOnQuestionChange {
            validateAnswerOnQuestionChange()
        }
    }
    
    @MainActor
    func previousQuestion() {
        guard currentIndex != 0 else { return }
        currentQuestion = questions?[safe: currentIndex - 1]
    }
    
    @MainActor
    func next() {
        if isOnLastQuestion {
            sendQuestionnaire()
        } else {
            currentQuestion = questions?[safe: currentIndex + 1]
        }
    }
    
    @MainActor
    func answer(_ answer: EitherAnswerType, for question: Question) {
        let isValid = validate(
            answer: answer,
            for: question,
            mandatoryAnswer: shouldValidateAnswerOnQuestionChange
        )
        
        answers[question] = .init(
            value: answer,
            questionId: question.id,
            type: question.type,
            questionnaireId: question.questionnaireId
        )
        
        if shouldValidateAnswerOnQuestionChange {
            mainButtonEnabled = validateAll(
                until: question,
                mandatoryAnswer: true
            )
        }
        
        if question.isSingleChoice,
           answer.multichoice != nil,
           question.type != .numeric,
           !isOnLastQuestion,
           isValid
        {
            next()
        }
        
        if !shouldValidateAnswerOnQuestionChange {
            mainButtonEnabled = validate(
                answer: answer,
                for: question,
                mandatoryAnswer: false
            )
        }
    }

    @MainActor
    func getQuestionnaire() async {
        do {
            let data = try await getQuestions(repo)
            questions = data
            answers = data.reduce(into: [:], { answers, question in
                answers[question] = CreateQuestionnaireAnswer(
                    value: question.answer,
                    questionId: question.id,
                    type: question.type,
                    questionnaireId: question.questionnaireId
                )
            })
            currentQuestion = questions?.first
        } catch {
            initialLoadError = error
        }
    }
    
    func dismiss() {
        nav.navigate(to: .dismiss)
    }
    
    // MARK: Private methods
    
    private func validateAnswerOnQuestionChange() {
        $currentQuestion
            .compactMap { $0 }
            .map { [unowned self] newValue in
                if shouldValidateAnswerOnQuestionChange {
                    return validateAll(until: newValue, mandatoryAnswer: true)
                } else {
                    return true
                }
            }
            .assign(to: &$mainButtonEnabled)
    }
    
    @MainActor
    private func sendQuestionnaire() {
        Task {
            sendLoading = true
            
            do {
                let answers: [CreateQuestionnaireAnswer] = answers.values.compactMap { $0 }
                try await sendQuestions(repo, answers)
                
                nextScreen(didAnswerAllQuestions())
            } catch {
                sendError = error
            }
            
            sendLoading = false
        }
    }
    
    private func didAnswerAllQuestions() -> Bool {
        guard let lastQuestion = questions?.last else { return false }

        return validateAll(until: lastQuestion, mandatoryAnswer: true)
    }
    
    internal func validate(
        answer: EitherAnswerType,
        for question: Question,
        mandatoryAnswer: Bool
    ) -> Bool {
        switch question.value {
        case let .multiChoice(q):
            guard q.minOptions <= q.maxOptions else { return false }
            guard let count = answer.multichoice.map(\.count), count != 0 else {
                return !mandatoryAnswer
            }
            return (q.minOptions...q.maxOptions).contains(count)
            
        case let .numeric(q):
            guard q.minValue <= q.maxValue else { return false }
            guard let value = answer.numeric else {
                return !mandatoryAnswer
            }
            
            return (Double(q.minValue)...Double(q.maxValue)).contains(value)
        }
    }
    
    internal func validateAll(until q: Question, mandatoryAnswer: Bool) -> Bool {
        guard let partial = questions?.firstIndex(of: q),
            let partialQuestions = questions?[0...partial] else {
            return false
        }
        
        return partialQuestions.reduce(true) { partialResult, q in
            if let answer = answers[q]??.value {
                return partialResult && validate(answer: answer, for: q, mandatoryAnswer: mandatoryAnswer)
            } else {
                return false
            }
        }
    }
}
