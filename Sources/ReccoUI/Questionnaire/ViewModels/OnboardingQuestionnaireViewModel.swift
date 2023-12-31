import Foundation
import ReccoHeadless

final class OnboardingQuestionnaireViewModel: QuestionnaireViewModel {
    init(
        nextScreen: @escaping (Bool) -> Void,
        repo: QuestionnaireRepository,
        nav: ReccoCoordinator,
        logger: Logger
    ) {
        super.init(
            repo: repo,
            nav: nav,
            logger: logger,
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
