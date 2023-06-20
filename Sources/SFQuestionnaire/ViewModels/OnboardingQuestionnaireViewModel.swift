import Foundation
import SFRepo
import SFEntities

public final class OnboardingQuestionnaireViewModel: QuestionnaireViewModel {
    init(
        nextScreen: @escaping () -> Void,
        repo: QuestionnaireRepository
    ) {
        super.init(
            repo: repo,
            nextScreen: nextScreen,
            getQuestions: { repo in
                try await repo.getOnboardingQuestionnaire()
            }
        )
    }
}
