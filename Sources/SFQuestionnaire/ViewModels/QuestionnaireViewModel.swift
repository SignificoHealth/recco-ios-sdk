import Foundation
import SFRepo
import SFEntities
import Combine

public class QuestionnaireViewModel: ObservableObject {
    private let repo: QuestionnaireRepository
    private let nextScreen: () -> Void
    private let getQuestions: (QuestionnaireRepository) async throws -> [Question]

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
    
    private var isOnboarding: Bool {
        type(of: self) == OnboardingQuestionnaireViewModel.self
    }
    
    init(
        repo: QuestionnaireRepository,
        nextScreen: @escaping () -> Void,
        getQuestions: @escaping (QuestionnaireRepository) async throws -> [Question]
    ) {
        self.repo = repo
        self.nextScreen = nextScreen
        self.getQuestions = getQuestions
        self.mainButtonEnabled = type(of: self) == TopicQuestionnaireViewModel.self
        
        if isOnboarding {
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
        let isValid = validate(answer: answer, for: question)
        
        answers[question] = .init(
            value: answer,
            questionId: question.id,
            type: question.type,
            questionnaireId: question.questionnaireId
        )
        
        if question.isSingleChoice,
           answer.multichoice != nil,
           question.type != .numeric,
           !isOnLastQuestion,
           isValid
        {
            next()
        }
        
        if !isOnboarding {
            mainButtonEnabled = isValid
        }
    }
    
    @MainActor
    func getQuestionnaire() async {
        do {
            let data = try await getQuestions(repo)
            questions = data
            answers = data.reduce(into: [:], { answers, question in
                answers[question] = CreateQuestionnaireAnswer(
                    value: question.type == .multichoice ? .multiChoice(nil) : .numeric(nil),
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
    
    private func validateAnswerOnQuestionChange() {
        $currentQuestion
            .compactMap { $0 }
            .combineLatest($answers)
            .map { [unowned self] newValue, answers in
                if let a = answers[newValue], let answer = a, isOnboarding {
                    return validate(answer: answer.value, for: newValue)
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
                try await repo.sendQuestionnaire(answers)
                
                nextScreen()
            } catch {
                sendError = error
            }
            
            sendLoading = false
        }
    }
    
    private func validate(answer: EitherAnswerType, for question: Question) -> Bool {
        switch question.value {
        case let .multiChoice(q):
            guard q.minOptions <= q.maxOptions else { return false }
            guard let count = answer.multichoice.map(\.count), count != 0 else {
                return !isOnboarding
            }
            return (q.minOptions...q.maxOptions).contains(count)
            
        case let .numeric(q):
            guard q.minValue <= q.maxValue else { return false }
            guard let value = answer.numeric, value != 0 else {
                return !isOnboarding
            }
            
            return (Double(q.minValue)...Double(q.maxValue)).contains(value)
        }
    }
}
