//
//  File.swift
//
//
//  Created by Adrián R on 30/1/24.
//

import Foundation

public enum MediaType {
    case audio
    case video
}

public struct AppUserMedia: Hashable, Equatable {
    internal init(type: MediaType, id: ContentId, rating: ContentRating, status: ContentStatus, bookmarked: Bool, headline: String, description: String? = nil, category: String, disclaimer: String? = nil, warning: String? = nil, dynamicImageResizingUrl: URL? = nil, imageAlt: String? = nil, mediaUrl: URL, length: Int? = nil) {
        self.type = type
        self.id = id
        self.rating = rating
        self.status = status
        self.bookmarked = bookmarked
        self.headline = headline
        self.description = description
        self.category = category
        self.disclaimer = disclaimer
        self.warning = warning
        self.dynamicImageResizingUrl = dynamicImageResizingUrl
        self.imageAlt = imageAlt
        self.mediaUrl = mediaUrl
        self.length = length
    }

    public var type: MediaType
    public var id: ContentId
    public var rating: ContentRating
    public var status: ContentStatus
    public var bookmarked: Bool
    public var headline: String
    public var description: String?
    public var category: String
    public var disclaimer: String?
    public var warning: String?
    public var dynamicImageResizingUrl: URL?
    public var imageAlt: String?
    public var mediaUrl: URL
    /** The estimated duration in seconds to read this article */
    public var length: Int?
}
