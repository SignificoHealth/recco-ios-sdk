import Foundation
import SFRepo
import SFEntities

public final class QuestionnaireViewModel: ObservableObject {
    private let repo: QuestionnaireRepository
    let topic: SFTopic
    
    @Published var currentQuestion: Question?
    @Published var questions: [Question]?
    @Published var answers: [Question: CreateQuestionnaireAnswer?] = [:]
    @Published var initialLoadError: Error?
    @Published var sendError: Error?
    @Published var sendLoading: Bool = false
    @Published var mainButtonEnabled = true
    
    var currentIndex: Int {
        currentQuestion.flatMap {
            questions?.firstIndex(of: $0)
        } ?? 0
    }
    
    var isOnLastQuestion: Bool {
        return currentIndex == (questions?.count ?? 0) - 1
    }
    
    init(
        topic: SFTopic,
        repo: QuestionnaireRepository
    ) {
        self.repo = repo
        self.topic = topic
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
        
        if isValid {
            answers[question] = .init(
                value: answer,
                questionId: question.id,
                type: question.type,
                questionnaireId: question.questionnaireId
            )
            
            if question.isSingleChoice,
               answer.multichoice != nil,
               question.type != .numeric,
               !isOnLastQuestion
            {
                next()
            }
        }
        
        mainButtonEnabled = isValid
    }
    
    @MainActor
    func getQuestionnaire() async {
        do {
            let data = try await repo.getQuestionnaire(topic: topic)
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
    
    @MainActor
    private func sendQuestionnaire() {
        Task {
            sendLoading = true
            do {
                let answers: [CreateQuestionnaireAnswer] = answers.values.compactMap { $0 }
                try await repo.sendQuestionnaire(answers)
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
            guard let count =  answer.multichoice.map(\.count) else { return true }
            return (q.minOptions...q.maxOptions).contains(count)
            
        case let .numeric(q):
            guard q.minValue <= q.maxValue else { return false }
            guard let value = answer.numeric else {
                return true
            }
            
            return (Double(q.minValue)...Double(q.maxValue)).contains(value)
        }
    }
}
