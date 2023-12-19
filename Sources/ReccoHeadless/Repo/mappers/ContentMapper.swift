//
//  ContentMapper.swift
//
//
//  Created by Adrián R on 8/6/23.
//

import Foundation

extension ContentId {
    init(dto: ContentIdDTO) {
        self.init(itemId: dto.itemId, catalogId: dto.catalogId)
    }
}

extension ContentType {
    struct ContentTypeShouldNotBeNilError: Error {}
    init(dto: ContentTypeDTO) {
        switch dto {
        case .articles:
            self = .articles
        case .questionnaires:
            self = .questionnaire
        }
    }
}

extension ContentRating {
    struct ContentRatingShouldNotBeNilError: Error {}
    init(dto: RatingDTO) {
        switch dto {
        case .like:
            self = .like
        case .dislike:
            self = .dislike
        case .notRated:
            self = .notRated
        }
    }
}

extension ContentStatus {
    struct ContentStatusShouldNotBeNilError: Error {}
    init(dto: StatusDTO) {
        switch dto {
        case .noInteraction:
            self = .noInteraction
        case .viewed:
            self = .viewed
        }
    }
}

extension AppUserArticle {
    init(dto: AppUserArticleDTO) {
        self.init(
            id: .init(dto: dto.id),
            rating: .init(dto: dto.rating),
            status: .init(dto: dto.status),
            headline: dto.headline,
            bookmarked: dto.bookmarked,
            lead: dto.lead,
            imageUrl: dto.dynamicImageResizingUrl.flatMap(URL.init),
            imageAlt: dto.imageAlt,
            articleBodyHtml: dto.articleBodyHtml
        )
    }
}

extension ContentIdDTO {
    init(entity: ContentId) {
        self.init(itemId: entity.itemId, catalogId: entity.catalogId)
    }
}
