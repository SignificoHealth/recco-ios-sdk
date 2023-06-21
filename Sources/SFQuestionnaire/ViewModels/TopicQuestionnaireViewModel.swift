import Foundation
import SFRepo
import SFEntities

public final class TopicQuestionnaireViewModel: QuestionnaireViewModel {
    init(
        topic: SFTopic,
        unlocked: @escaping (SFTopic) -> Void,
        nav: QuestionnaireCoordinator,
        repo: QuestionnaireRepository
    ) {
        super.init(
            repo: repo,
            nextScreen: {
                unlocked(topic)
                nav.navigate(to: .back)
            },
            getQuestions: { repo in
                try await repo.getQuestionnaire(topic: topic)
            }, sendQuestions: { repo, answers in
                try await repo.sendQuestionnaire(answers)
            }
        )
    }
}
