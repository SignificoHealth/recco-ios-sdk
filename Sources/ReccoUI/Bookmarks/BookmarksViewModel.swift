import Foundation
import ReccoHeadless

final class BookmarksViewModel: ObservableObject {
    private let recRepo: RecommendationRepository
    private let nav: ReccoCoordinator

    @Published var isLoading = true
    @Published var items: [AppUserRecommendation] = []
    @Published var error: Error?

    init(
        recRepo: RecommendationRepository,
        nav: ReccoCoordinator
    ) {
        self.recRepo = recRepo
        self.nav = nav
    }

    func goToDetail(of item: AppUserRecommendation) {
        nav.navigate(to: .article(
            id: item.id,
            headline: item.headline,
            imageUrl: item.imageUrl,
            seenContent: { [unowned self] id in
                markContentAsSeen(id: id)
            },
            onBookmarkedChange: { [unowned self] bookmarked in
                if !bookmarked {
                    Task {
                        await getBookmarks()
                    }
                }
            }
        ))
    }

    func dismiss() {
        nav.navigate(to: .dismiss)
    }

    @MainActor
    func getBookmarks() async {
        do {
            let items = try await recRepo.getBookmarks()
            self.items = items
        } catch {
            self.error = error
        }

        isLoading = false
    }

    // MARK: Private

    private func markContentAsSeen(id: ContentId) {
        for (idx, item) in items.filter({ item in item.status != .viewed }).enumerated() where item.id == id {
			items[idx].status = .viewed
        }
    }
}
