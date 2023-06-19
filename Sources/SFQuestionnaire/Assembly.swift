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
        
        container.register(type: QuestionnaireViewModel.self) { (r: SFResolver, tuple: (SFTopic, (SFTopic) -> Void)) in
            QuestionnaireViewModel(
                topic: tuple.0,
                repo: r.get(),
                nav: r.get(),
                unlocked: tuple.1
            )
        }
    }
}

func withAssembly<Content>(@ViewBuilder content: @escaping (SFResolver) -> Content) -> Assembling<Content> {
    Assembling(RepositoryAssembly(clientSecret: ""), CoreAssembly(), QuestionnaireAssembly(), content: content)
}
