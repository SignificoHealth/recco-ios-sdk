import Foundation
import ReccoHeadless

final class TopicQuestionnaireViewModel: QuestionnaireViewModel {
    init(
        topic: ReccoTopic,
        reloadSection: @escaping (Bool) -> Void,
        repo: QuestionnaireRepository,
        nav: ReccoCoordinator,
        logger: Logger
    ) {
        super.init(
            repo: repo,
            nav: nav,
            logger: logger,
            shouldValidateAllAnswersOnQuestionChange: false,
            mainButtonEnabledByDefault: true,
            nextScreen: { answeredAll in
                reloadSection(answeredAll)
                nav.navigate(to: .back)
            },
            getQuestions: { repo in
                try await repo.getQuestionaryByTopic(topic: topic)
            }, sendQuestions: { repo, answers in
                try await repo.sendQuestionnaire(answers)
            }
        )
    }
}

final class ByIdQuestionnaireViewModel: QuestionnaireViewModel {
    init(
        id: ContentId,
        reloadSection: @escaping (Bool) -> Void,
        repo: QuestionnaireRepository,
        nav: ReccoCoordinator,
        logger: Logger
    ) {
        super.init(
            repo: repo,
            nav: nav,
            logger: logger,
            shouldValidateAllAnswersOnQuestionChange: false,
            mainButtonEnabledByDefault: true,
            nextScreen: { answeredAll in
                reloadSection(answeredAll)
                nav.navigate(to: .back)
            },
            getQuestions: { repo in
                try await repo.getQuestionaryById(id: id.itemId)
            }, sendQuestions: { repo, answers in
                try await repo.sendQuestionnaire(answers)
            }
        )
    }
}
