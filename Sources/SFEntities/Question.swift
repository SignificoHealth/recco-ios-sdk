import Foundation

public struct Question: Equatable, Hashable {
    public var id: String
    public var index: Int
    public var text: String
    public var type: QuestionnaireType
    public var multiChoice: MultiChoiceQuestion?
    public var numeric: NumericQuestion?

    public init(id: String, index: Int, text: String, type: QuestionnaireType, multiChoice: MultiChoiceQuestion? = nil, numeric: NumericQuestion? = nil) {
        self.id = id
        self.index = index
        self.text = text
        self.type = type
        self.multiChoice = multiChoice
        self.numeric = numeric
    }
}

