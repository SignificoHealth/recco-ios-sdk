import Foundation

public enum QuestionnaireType: String, Hashable, CaseIterable {
    case multichoice
    case numeric
}

public struct CreateQuestionnaireAnswer: Equatable, Hashable {
    public var multichoice: [Int]?
    public var numeric: Double?
    public var questionId: String
    public var type: QuestionnaireType

    public init(multichoice: [Int]? = nil, numeric: Double? = nil, questionId: String, type: QuestionnaireType) {
        self.multichoice = multichoice
        self.numeric = numeric
        self.questionId = questionId
        self.type = type
    }
}

