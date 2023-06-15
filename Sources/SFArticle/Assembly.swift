import SFCore
import SFEntities
import SwiftUI
import SFRepo

public final class ArticleAssembly: SFAssembly {
    public init() {}
    public func assemble(container: SFContainer) {
        container.register(type: ArticleDetailViewModel.self) { (r: SFResolver, tuple: (ContentId, String, URL?, (ContentId) -> Void)) in
            ArticleDetailViewModel(
                loadedContent: tuple,
                articleRepo: r.get(),
                contentRepo: r.get()
            )
        }
    }
}

func withAssembly<Content>(@ViewBuilder content: @escaping (SFResolver) -> Content) -> Assembling<Content> {
    Assembling(RepositoryAssembly(clientSecret: ""), CoreAssembly(), ArticleAssembly(), content: content)
}
