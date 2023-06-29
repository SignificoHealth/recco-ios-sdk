import Foundation
import ReccoHeadless

final class OnboardingQuestionnaireViewModel: QuestionnaireViewModel {
    init(
        nextScreen: @escaping (Bool) -> Void,
        repo: QuestionnaireRepository
    ) {
        super.init(
            repo: repo,
            nextScreen: nextScreen,
            getQuestions: { repo in
                try await repo.getOnboardingQuestionnaire()
            }, sendQuestions: { repo, answers in
                try await repo.sendOnboardingQuestionnaire(answers)
            }
        )
    }
}
