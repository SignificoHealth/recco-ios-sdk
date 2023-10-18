import Foundation

public struct AppUser: Equatable, Hashable, Codable {
    public init(
        id: String,
        isOnboardingQuestionnaireCompleted: Bool,
        appStyle: AppStyle? = nil
    ) {
        self.id = id
        self.isOnboardingQuestionnaireCompleted = isOnboardingQuestionnaireCompleted
        self.appStyle = appStyle
    }

    public var id: String
    public var isOnboardingQuestionnaireCompleted: Bool
    public var appStyle: AppStyle?
}
