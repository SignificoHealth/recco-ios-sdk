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
}
