import Foundation

public struct MultiChoiceAnswerOption: Equatable, Hashable {
    public var id: Int
    public var text: String

    public init(id: Int, text: String) {
        self.id = id
        self.text = text
    }
}

