import Foundation

public enum EitherQuestionType: Hashable, Equatable {
    case numeric(NumericQuestion)
    case multiChoice(MultiChoiceQuestion)
}

public struct Question: Equatable, Hashable {
    struct NoNumericQuestion: Error {}
    struct NoMultichoiceQuestion: Error {}
    
    public var id: String
    public var index: Int
    public var text: String
    public var type: QuestionnaireType
    public var question: EitherQuestionType
    
    public init(id: String, index: Int, text: String, type: QuestionnaireType, multiChoice: MultiChoiceQuestion? = nil, numeric: NumericQuestion? = nil) throws {
        self.id = id
        self.index = index
        self.text = text
        self.type = type
        
        switch type {
        case .numeric:
            guard let numeric else { throw NoNumericQuestion() }
            self.question = .numeric(numeric)
        case .multichoice:
            guard let multiChoice else { throw NoMultichoiceQuestion() }
            self.question = .multiChoice(multiChoice)
        }
    }
}

