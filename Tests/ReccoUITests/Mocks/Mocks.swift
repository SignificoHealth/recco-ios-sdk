@testable import ReccoHeadless

final class Mocks {
    static let article = AppUserArticle(
        id: ContentId(
            itemId: "itemId",
            catalogId: "catalogId"
        ),
        rating: .notRated,
        status: .viewed,
        headline: "headline",
        bookmarked: false
    )

    static let appUserRecommendation = AppUserRecommendation(
        id: ContentId(
            itemId: "itemId",
            catalogId: "catalogId"
        ),
        type: .articles,
        rating: .like,
        status: .viewed,
        headline: "headline"
    )

    static let appUserRecommendations: [AppUserRecommendation] = (1...10).map { index in
        return AppUserRecommendation(
            id: ContentId(
                itemId: "item-\(index)",
                catalogId: "catalog-\(index)"
            ),
            type: .articles,
            rating: .like,
            status: .viewed,
            headline: "headline-\(index)"
        )
    }

    static let feedSectionWithTopic = FeedSection(
        type: .mostPopular,
        state: .unlock,
        topic: .nutrition
    )

    static let feedSections: [FeedSection] = [
        FeedSection(type: .mentalWellbeingExplore, state: .unlock),
        FeedSection(type: .mentalWellbeingRecommendations, state: .unlock),
        FeedSection(type: .mostPopular, state: .unlock),
        FeedSection(type: .newContent, state: .unlock),
        FeedSection(type: .nutritionExplore, state: .unlock),
    ]

    static let createQuestionnaireAnswers: [CreateQuestionnaireAnswer] = (0...4).map { index in
        CreateQuestionnaireAnswer(
            value: .numeric(0),
            questionId: "question-\(index)",
            type: .numeric,
            questionnaireId: "questionnaire-\(index)"
        )
    }

    static let singleChoiceQuestion: Question = try! Question(
        id: "question-0",
        questionnaireId: "questionnaire-0",
        index: 0,
        text: "Question 0",
        type: .multichoice,
        multiChoice: MultiChoiceQuestion(
            maxOptions: 1,
            minOptions: 1,
            options: (1...5).map { MultiChoiceAnswerOption(id: $0, text: "\($0)") }
        ),
        multichoiceAnswer: [1]
    )
    static let singleChoiceCorrectAnswer = EitherAnswerType.multiChoice([1])

    static let singleChoiceQuestions: [Question] = (0...4).map { index in
        try! Question(
            id: "question-\(index)",
            questionnaireId: "questionnaire-\(index)",
            index: index,
            text: "Question \(index)",
            type: .multichoice,
            multiChoice: MultiChoiceQuestion(
                maxOptions: 1,
                minOptions: 1,
                options: (1...5).map { MultiChoiceAnswerOption(id: $0, text: "\($0)") }
            ),
            multichoiceAnswer: [1]
        )
    }

    static let multiChoiceQuestion: Question = try! Question(
        id: "question-0",
        questionnaireId: "questionnaire-0",
        index: 0,
        text: "Question 0",
        type: .multichoice,
        multiChoice: MultiChoiceQuestion(
            maxOptions: 3,
            minOptions: 1,
            options: (1...5).map { MultiChoiceAnswerOption(id: $0, text: "\($0)") }
        ),
        multichoiceAnswer: [1, 2]
    )
    static let multiChoiceCorrectAnswer = EitherAnswerType.multiChoice([1, 2])
    static let multiChoiceInvalidAnswer = EitherAnswerType.multiChoice([])

    static let numericQuestion: Question = try! Question(
        id: "question-0",
        questionnaireId: "questionnaire-0",
        index: 0,
        text: "Question 0",
        type: .numeric,
        numeric: NumericQuestion(
            maxValue: 4,
            minValue: 0,
            format: .decimal
        ),
        numericAnswer: 2
    )
    static let numericCorrectAnswer = EitherAnswerType.numeric(1)
    static let numericInvalidAnswer = EitherAnswerType.numeric(nil)

    static let numericQuestions: [Question] = (0...4).map { index in
        try! Question(
            id: "question-\(index)",
            questionnaireId: "questionnaire-\(index)",
            index: index,
            text: "Question \(index)",
            type: .numeric,
            numeric: NumericQuestion(
                maxValue: 4,
                minValue: 0,
                format: .decimal
            ),
            numericAnswer: 2
        )
    }

    static func getNumericQuestionsWithAnswers(answers: [EitherAnswerType]) throws -> ([Question], [Question: CreateQuestionnaireAnswer]) {
        let count = answers.count
        var questions = [Question]()
        var answersMap = [Question: CreateQuestionnaireAnswer]()

        try (0..<count).forEach { index in
            let question = try Question(
                id: "question-\(index)",
                questionnaireId: "questionnaire-\(index)",
                index: index,
                text: "Question \(index)",
                type: .numeric,
                numeric: NumericQuestion(
                    maxValue: 4,
                    minValue: 0,
                    format: .decimal
                ),
                numericAnswer: 2
            )
            let answer = CreateQuestionnaireAnswer(
                value: answers[index],
                questionId: question.id,
                type: question.type,
                questionnaireId: question.questionnaireId
            )
            questions.append(question)
            answersMap[question] = answer
        }

        return (questions, answersMap)
    }
}
