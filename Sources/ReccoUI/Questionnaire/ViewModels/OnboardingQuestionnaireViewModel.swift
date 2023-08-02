import Foundation
import ReccoHeadless

final class OnboardingQuestionnaireViewModel: QuestionnaireViewModel {
    init(
        nextScreen: @escaping (Bool) -> Void,
        repo: QuestionnaireRepository,
        nav: ReccoCoordinator
    ) {
        super.init(
            repo: repo,
            nav: nav,
            shouldValidateAllAnswersOnQuestionChange: true,
            mainButtonEnabledByDefault: false,
            nextScreen: nextScreen,
            getQuestions: { repo in
                try await repo.getOnboardingQuestionnaire()
            }, sendQuestions: { repo, answers in
                try await repo.sendOnboardingQuestionnaire(answers)
            }
        )
    }
}
