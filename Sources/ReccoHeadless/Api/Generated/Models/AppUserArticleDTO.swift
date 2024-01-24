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
    internal var dynamicImageResizingUrl: String?
    internal var imageAlt: String?
    internal var audioUrl: String?
    internal var articleBodyHtml: String?
    /** The estimated duration in seconds to read this article */
    internal var length: Int?

    internal init(id: ContentIdDTO, rating: RatingDTO, status: StatusDTO, bookmarked: Bool, headline: String, lead: String? = nil, imageUrl: String? = nil, dynamicImageResizingUrl: String? = nil, imageAlt: String? = nil, audioUrl: String? = nil, articleBodyHtml: String? = nil, length: Int? = nil) {
        self.id = id
        self.rating = rating
        self.status = status
        self.bookmarked = bookmarked
        self.headline = headline
        self.lead = lead
        self.imageUrl = imageUrl
        self.dynamicImageResizingUrl = dynamicImageResizingUrl
        self.imageAlt = imageAlt
        self.audioUrl = audioUrl
        self.articleBodyHtml = articleBodyHtml
        self.length = length
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case rating
        case status
        case bookmarked
        case headline
        case lead
        case imageUrl
        case dynamicImageResizingUrl
        case imageAlt
        case audioUrl
        case articleBodyHtml
        case length
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
        try container.encodeIfPresent(dynamicImageResizingUrl, forKey: .dynamicImageResizingUrl)
        try container.encodeIfPresent(imageAlt, forKey: .imageAlt)
        try container.encodeIfPresent(audioUrl, forKey: .audioUrl)
        try container.encodeIfPresent(articleBodyHtml, forKey: .articleBodyHtml)
        try container.encodeIfPresent(length, forKey: .length)
    }
}

