import Foundation

public enum NumericQuestionFormat: String, Codable, CaseIterable {
    case humanHeight
    case humanWeight
    case integer
    case decimal
}

public struct NumericQuestion: Equatable, Hashable {
    public var maxValue: Int
    public var minValue: Int
    public var format: NumericQuestionFormat

    public init(maxValue: Int, minValue: Int, format: NumericQuestionFormat) {
        self.maxValue = maxValue
        self.minValue = minValue
        self.format = format
    }
}
