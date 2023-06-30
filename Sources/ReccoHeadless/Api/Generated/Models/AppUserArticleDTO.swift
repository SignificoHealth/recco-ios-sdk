//
// AppUserArticleDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct AppUserArticleDTO: Codable, JSONEncodable, Hashable {

    internal var id: ContentIdDTO
    internal var rating: RatingDTO
    internal var status: StatusDTO
    internal var bookmarked: Bool
    internal var headline: String
    internal var lead: String?
    internal var imageUrl: String?
    internal var articleBodyHtml: String?

    internal init(id: ContentIdDTO, rating: RatingDTO, status: StatusDTO, bookmarked: Bool, headline: String, lead: String? = nil, imageUrl: String? = nil, articleBodyHtml: String? = nil) {
        self.id = id
        self.rating = rating
        self.status = status
        self.bookmarked = bookmarked
        self.headline = headline
        self.lead = lead
        self.imageUrl = imageUrl
        self.articleBodyHtml = articleBodyHtml
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case rating
        case status
        case bookmarked
        case headline
        case lead
        case imageUrl
        case articleBodyHtml
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(rating, forKey: .rating)
        try container.encode(status, forKey: .status)
        try container.encode(bookmarked, forKey: .bookmarked)
        try container.encode(headline, forKey: .headline)
        try container.encodeIfPresent(lead, forKey: .lead)
        try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
        try container.encodeIfPresent(articleBodyHtml, forKey: .articleBodyHtml)
    }
}
