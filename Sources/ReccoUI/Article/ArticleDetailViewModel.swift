import Foundation
import ReccoHeadless

final class ArticleDetailViewModel: ObservableObject {
    private let articleRepo: ArticleRepository
    private let contentRepo: ContentRepository
    private let contentId: ContentId
    private let updateContentSeen: (ContentId) -> Void
    private let nav: ReccoCoordinator
    
    let imageUrl: URL?
    let heading: String
    
    @Published var isLoading: Bool = true
    @Published var article: AppUserArticle?
    @Published var initialLoadError: Error?
    @Published var actionError: Error?
    
    init(
        loadedContent: (ContentId, String, URL?, (ContentId) -> Void),
        articleRepo: ArticleRepository,
        contentRepo: ContentRepository,
        nav: ReccoCoordinator
    ) {
        self.articleRepo = articleRepo
        self.contentRepo = contentRepo
        self.contentId = loadedContent.0
        self.imageUrl = loadedContent.2
        self.heading = loadedContent.1
        self.updateContentSeen = loadedContent.3
        self.nav = nav
    }
    
    @MainActor
    func initialLoad() async {
        do {
            let article = try await articleRepo.getArticle(with: contentId)
            self.article = article
            self.article?.status = .viewed
            self.updateContentSeen(article.id)
        } catch {
            initialLoadError = error
        }
        
        isLoading = false
    }
    
    func toggleBookmark() {
        guard let article = article else { return }
        
        Task { @MainActor in
            do {
                try await contentRepo.setBookmark(.init(
                    contentId: article.id,
                    contentType: .articles,
                    bookmarked: article.bookmarked
                ))
                
                self.article?.bookmarked.toggle()
            } catch {
                actionError = error
            }
            
            isLoading = false
        }
    }
    
    func rate(_ rating: ContentRating) {
        guard let article = article else { return }
        
        Task { @MainActor in
            do {
                try await contentRepo.setRating(.init(
                    contentId: article.id,
                    contentType: .articles,
                    rating: rating
                ))
                
                self.article?.rating = rating
            } catch {
                actionError = error
            }
            
            isLoading = false
        }
    }
    
    func dismissSDK() {
        nav.navigate(to: .dismiss)
    }
    
    func back() {
        nav.navigate(to: .back)
    }
}
