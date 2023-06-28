import Foundation
import ReccoHeadless

final class TopicQuestionnaireViewModel: QuestionnaireViewModel {
    init(
        topic: SFTopic,
        unlocked: @escaping (SFTopic) -> Void,
        nav: ReccoCoordinator,
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
