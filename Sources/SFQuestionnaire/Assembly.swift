import SFCore
import SFEntities
import SwiftUI
import SFRepo

public final class QuestionnaireAssembly: SFAssembly {
    public init() {}
    public func assemble(container: SFContainer) {
        container.register(type: QuestionnaireViewModel.self) { r, topic in
            QuestionnaireViewModel(topic: topic, repo: r.get())
        }
    }
}

func withAssembly<Content>(@ViewBuilder content: @escaping (SFResolver) -> Content) -> Assembling<Content> {
    Assembling(RepositoryAssembly(clientSecret: ""), CoreAssembly(), QuestionnaireAssembly(), content: content)
}
