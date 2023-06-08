//
//  File.swift
//  
//
//  Created by Adrián R on 8/6/23.
//

import Foundation
import SFEntities
import SFApi

public protocol ArticleRepository {
    func getArticle(with id: ContentId) async throws -> AppUserArticle
}

final class LiveArticleRepository: ArticleRepository {
    init() {}
    
    func getArticle(with id: ContentId) async throws -> AppUserArticle {
        let dto = try await RecommendationAPI.getArticle(
            itemId: id.itemId,
            catalogId: id.catalogId
        )
        return try AppUserArticle(dto: dto)
    }
}
