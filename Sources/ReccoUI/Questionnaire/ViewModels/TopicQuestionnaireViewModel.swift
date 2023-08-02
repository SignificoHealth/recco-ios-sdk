import Foundation
import ReccoHeadless

final class TopicQuestionnaireViewModel: QuestionnaireViewModel {
    init(
        topic: ReccoTopic,
        reloadSection: @escaping (Bool) -> Void,
        repo: QuestionnaireRepository,
        nav: ReccoCoordinator
    ) {
        super.init(
            repo: repo,
            nav: nav,
            shouldValidateAllAnswersOnQuestionChange: false,
            mainButtonEnabledByDefault: true,
            nextScreen: { answeredAll in
                reloadSection(answeredAll)
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
