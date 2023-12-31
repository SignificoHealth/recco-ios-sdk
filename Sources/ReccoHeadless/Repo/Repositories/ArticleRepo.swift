import Foundation

public protocol ArticleRepository {
    func getArticle(with id: ContentId) async throws -> AppUserArticle
}

final class LiveArticleRepository: ArticleRepository {
    init() {}

    func getArticle(with id: ContentId) async throws -> AppUserArticle {
        let dto = try await RecommendationAPI.getArticle(catalogId: id.catalogId)
        return AppUserArticle(dto: dto)
    }
}
