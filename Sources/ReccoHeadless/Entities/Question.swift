import Foundation

public enum EitherQuestionType: Hashable, Equatable {
    case numeric(NumericQuestion)
    case multiChoice(MultiChoiceQuestion)
}

public struct Question: Equatable, Hashable {
    struct NoNumericQuestion: Error {}
    struct NoMultichoiceQuestion: Error {}
    
    public var questionnaireId: String
    public var id: String
    public var index: Int
    public var text: String
    public var type: QuestionType
    public var value: EitherQuestionType
    public var answer: EitherAnswerType
    
    public init(id: String, questionnaireId: String, index: Int, text: String, type: QuestionType, multiChoice: MultiChoiceQuestion? = nil, numeric: NumericQuestion? = nil, numericAnswer: Double? = nil, multichoiceAnswer: [Int]? = nil) throws {
        self.id = id
        self.index = index
        self.text = text
        self.type = type
        self.questionnaireId = questionnaireId
        
        switch type {
        case .numeric:
            guard let numeric else { throw NoNumericQuestion() }
            self.value = .numeric(numeric)
            self.answer = .numeric(numericAnswer)
        case .multichoice:
            guard let multiChoice else { throw NoMultichoiceQuestion() }
            self.value = .multiChoice(multiChoice)
            self.answer = .multiChoice(multichoiceAnswer)
        }
    }
}

extension MultiChoiceQuestion {
    public var isSingleChoice: Bool {
        return maxOptions == 1
    }
}

extension Question {
    public var isSingleChoice: Bool {
        switch value {
        case .numeric:
            return false
        case let .multiChoice(multi):
            return multi.isSingleChoice
        }
    }
}

