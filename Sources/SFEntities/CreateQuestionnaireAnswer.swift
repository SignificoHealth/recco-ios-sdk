import Foundation

public enum QuestionnaireType: String, Hashable, CaseIterable {
    case multichoice
    case numeric
}

public enum EitherAnswerType: Hashable, Equatable {
    case numeric(Double?)
    case multiChoice([Int]?)
}

extension EitherAnswerType {
    public var numeric: Double? {
        if case let .numeric(value) = self {
            return value
        } else { return nil }
    }
    
    public var multichoice: [Int]? {
        if case let .multiChoice(value) = self {
            return value
        } else { return nil }
    }
}

public struct CreateQuestionnaireAnswer: Equatable, Hashable {
    public var value: EitherAnswerType
    public var questionId: String
    public var type: QuestionnaireType

    public init(value: EitherAnswerType, questionId: String, type: QuestionnaireType) {
        self.value = value
        self.questionId = questionId
        self.type = type
    }
}

