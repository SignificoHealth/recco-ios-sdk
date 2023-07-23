@testable import ReccoHeadless

final class Mocks {
    static let article = AppUserArticle(
        id: ContentId(
            itemId: "itemId",
            catalogId: "catalogId"
        ),
        rating: .notRated,
        status: .viewed,
        headline: "headline",
        bookmarked: false
    )

    static let appUserRecommendation = AppUserRecommendation(
        id: ContentId(
            itemId: "itemId",
            catalogId: "catalogId"
        ),
        type: .articles,
        rating: .like,
        status: .viewed,
        headline: "headline"
    )

    static let appUserRecommendations: [AppUserRecommendation] = (1...10).map { index in
        return AppUserRecommendation(
            id: ContentId(
                itemId: "item-\(index)",
                catalogId: "catalog-\(index)"
            ),
            type: .articles,
            rating: .like,
            status: .viewed,
            headline: "headline-\(index)"
        )
    }

}
