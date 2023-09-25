import Foundation
import ReccoHeadless

final class ArticleDetailViewModel: ObservableObject {
    private let articleRepo: ArticleRepository
    private let contentRepo: ContentRepository
    private let contentId: ContentId
    private let updateContentSeen: (ContentId) -> Void
    private let onBookmarkChanged: (Bool) -> Void
    private let nav: ReccoCoordinator
    private let logger: Logger

    let imageUrl: URL?
    let heading: String

	@Published var isLoading: Bool = true
    @Published var article: AppUserArticle?
    @Published var initialLoadError: Error?
    @Published var actionError: Error?

    init(
        loadedContent: (ContentId, String, URL?, (ContentId) -> Void, (Bool) -> Void),
        articleRepo: ArticleRepository,
        contentRepo: ContentRepository,
        nav: ReccoCoordinator,
        logger: Logger
    ) {
        self.articleRepo = articleRepo
        self.contentRepo = contentRepo
        self.contentId = loadedContent.0
        self.imageUrl = loadedContent.2
        self.heading = loadedContent.1
        self.updateContentSeen = loadedContent.3
        self.onBookmarkChanged = loadedContent.4
        self.nav = nav
        self.logger = logger
    }

    @MainActor
    func initialLoad() async {
        do {
            let article = try await articleRepo.getArticle(with: contentId)
            self.article = article
            self.article?.status = .viewed
            self.updateContentSeen(article.id)
        } catch {
            logger.log(error)
            initialLoadError = error
        }

        isLoading = false
    }

    @MainActor
    func toggleBookmark() async {
        guard let article = article else { return }

        do {
            try await contentRepo.setBookmark(.init(
                contentId: article.id,
                contentType: .articles,
                bookmarked: !article.bookmarked
            ))

            self.article?.bookmarked.toggle()
            self.onBookmarkChanged(!article.bookmarked)
        } catch {
            logger.log(error)
            actionError = error
        }

        isLoading = false
    }

    @MainActor
    func rate(_ rating: ContentRating) async {
        guard let article = article else { return }

        do {
            try await contentRepo.setRating(.init(
                contentId: article.id,
                contentType: .articles,
                rating: rating
            ))

            self.article?.rating = rating
        } catch {
            logger.log(error)
            actionError = error
        }

        isLoading = false
    }

    func dismiss() {
        nav.navigate(to: .dismiss)
    }

    func back() {
        nav.navigate(to: .back)
    }
}
