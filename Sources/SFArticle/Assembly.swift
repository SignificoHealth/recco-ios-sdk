import SFCore
import SFEntities

public final class ArticleAssembly: SFAssembly {
    public init() {}
    public func assemble(container: SFContainer) {
        container.register(type: ArticleDetailViewModel.self) { (r: SFResolver, tuple: (ContentId, String, URL?)) in
            ArticleDetailViewModel(
                loadedContent: tuple,
                articleRepo: r.get(),
                contentRepo: r.get()
            )
        }
    }
}

#if DEBUG
import SwiftUI
import SFRepo
func withAssembly<Content>(@ViewBuilder content: @escaping (SFResolver) -> Content) -> Assembling<Content> {
    Assembling(RepositoryAssembly(clientSecret: ""), CoreAssembly(), ArticleAssembly(), content: content)
}
#endif
