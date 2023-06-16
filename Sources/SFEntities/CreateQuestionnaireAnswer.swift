import Foundation

public enum QuestionType: String, Hashable, CaseIterable {
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
    public init(value: EitherAnswerType, questionId: String, type: QuestionType, questionnaireId: String) {
        self.value = value
        self.questionId = questionId
        self.type = type
        self.questionnaireId = questionnaireId
    }
    
    public var value: EitherAnswerType
    public var questionId: String
    public var type: QuestionType
    public var questionnaireId: String
   
}

