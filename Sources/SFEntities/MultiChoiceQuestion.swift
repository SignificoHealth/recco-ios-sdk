import Foundation

public struct MultiChoiceQuestion: Equatable, Hashable {
    public var maxOptions: Int
    public var minOptions: Int
    public var options: [MultiChoiceAnswerOption]

    public init(maxOptions: Int, minOptions: Int, options: [MultiChoiceAnswerOption]) {
        self.maxOptions = maxOptions
        self.minOptions = minOptions
        self.options = options
    }
}

