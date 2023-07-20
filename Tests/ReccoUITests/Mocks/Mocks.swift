@testable import ReccoHeadless

final class Mocks {
    static let article = AppUserArticle(id: .init(itemId: "itemId", catalogId: "catalogId"), rating: .notRated, status: .viewed, headline: "headline", bookmarked: false)
}
