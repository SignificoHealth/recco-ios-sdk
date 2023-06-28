import Foundation

public struct Questionnaire: Equatable, Hashable {
    public var id: String
    public var categoriesIds: [Int]
    public var questions: [Question]

    public init(id: String, categoriesIds: [Int], questions: [Question]) {
        self.id = id
        self.categoriesIds = categoriesIds
        self.questions = questions
    }
}

