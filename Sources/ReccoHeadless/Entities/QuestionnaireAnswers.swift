import Foundation

public struct QuestionnaireAnswers: Equatable, Hashable {
    public var id: String
    public var categoriesIds: [Int]
    public var answers: [CreateQuestionnaireAnswer]

    public init(id: String, categoriesIds: [Int], answers: [CreateQuestionnaireAnswer]) {
        self.id = id
        self.categoriesIds = categoriesIds
        self.answers = answers
    }
}

