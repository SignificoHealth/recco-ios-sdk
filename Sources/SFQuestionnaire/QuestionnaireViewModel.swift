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
    
    func previousQuestion() {
        guard currentIndex != 0 else { return }
        currentQuestion = questions?[safe: currentIndex - 1]
    }
    
    func next() {
        if isOnLastQuestion {
            
        } else {
            currentQuestion = questions?[safe: currentIndex + 1]
        }
    }
    
    @MainActor
    func getQuestionnaire() async {
        do {
            questions = try await repo.getQuestionnaire(topic: topic)
            currentQuestion = questions?.first
        } catch {
            initialLoadError = error
        }
    }
}
