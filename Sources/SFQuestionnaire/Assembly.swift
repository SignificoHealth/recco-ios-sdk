import SFCore
import SFEntities
import SwiftUI
import SFRepo

public final class QuestionnaireAssembly: SFAssembly {
    public init() {}
    public func assemble(container: SFContainer) {
        container.register(type: QuestionnaireCoordinator.self) { r in
            QuestionnaireCoordinator(window: r.get())
        }
        
        container.register(type: TopicQuestionnaireViewModel.self) { (r: SFResolver, tuple: (SFTopic, (SFTopic) -> Void)) in
            TopicQuestionnaireViewModel(
                topic: tuple.0,
                unlocked: tuple.1,
                nav: r.get(),
                repo: r.get()
            )
        }
        
        container.register(type: OnboardingQuestionnaireViewModel.self) { r, next in
            OnboardingQuestionnaireViewModel(
                nextScreen: next,
                repo: r.get()
            )
        }
    }
}

func withAssembly<Content>(@ViewBuilder content: @escaping (SFResolver) -> Content) -> Assembling<Content> {
    Assembling(RepositoryAssembly(clientSecret: ""), CoreAssembly(), QuestionnaireAssembly(), content: content)
}
