//
//  File.swift
//  
//
//  Created by Adrián R on 8/6/23.
//

import Foundation
import SFApi
import SFEntities

protocol StatusDTO: RawRepresentable where RawValue == String {}
protocol RatingDTO: RawRepresentable where RawValue == String {}
protocol TypeDTO: RawRepresentable where RawValue == String {}

extension ContentId {
    init(dto: ContentIdDTO) {
        self.init(itemId: dto.itemId, catalogId: dto.catalogId)
    }
}


extension AppUserRecommendationDTO.TypeDTO: TypeDTO {}
extension ContentType {
    struct ContentTypeShouldNotBeNilError: Error {}
    init(dto: any TypeDTO) throws {
        let new = ContentType(rawValue: dto.rawValue)
        if let new = new {
            self = new
        } else {
            throw ContentTypeShouldNotBeNilError()
        }
    }
}

extension AppUserRecommendationDTO.RatingDTO: RatingDTO {}
extension AppUserArticleDTO.RatingDTO: RatingDTO {}

extension ContentRating {
    struct ContentRatingShouldNotBeNilError: Error {}
    init(dto: any RatingDTO) throws {
        let new = ContentRating(rawValue: dto.rawValue)
        if let new = new {
            self = new
        } else {
            throw ContentRatingShouldNotBeNilError()
        }
    }
}

extension AppUserArticleDTO.StatusDTO: StatusDTO {}
extension AppUserRecommendationDTO.StatusDTO: StatusDTO {}

extension ContentStatus {
    struct ContentStatusShouldNotBeNilError: Error {}
    init(dto: any StatusDTO) throws {
        let new = ContentStatus(rawValue: dto.rawValue)
        if let new = new {
            self = new
        } else {
            throw ContentStatusShouldNotBeNilError()
        }
    }
}

extension AppUserArticle {
    init(dto: AppUserArticleDTO) throws {
        self.init(
            id: .init(dto: dto.id),
            rating: try .init(dto: dto.rating),
            status: try .init(dto: dto.status),
            headline: dto.headline,
            bookmarked: dto.bookmarked,
            lead: dto.lead,
            imageUrl: dto.imageUrl.flatMap(URL.init),
            articleBodyHtml: dto.articleBodyHtml
        )
    }
}

extension ContentIdDTO {
    init(entity: ContentId) {
        self.init(itemId: entity.itemId, catalogId: entity.catalogId)
    }
}
