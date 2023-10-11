import Foundation

public struct AppUser: Equatable, Hashable, Codable {
    public init(id: String, isOnboardingQuestionnaireCompleted: Bool) {
        self.id = id
        self.isOnboardingQuestionnaireCompleted = isOnboardingQuestionnaireCompleted
        
    }

    public var id: String
    public var isOnboardingQuestionnaireCompleted: Bool
}
