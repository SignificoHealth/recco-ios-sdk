import Foundation

public struct AppUserArticle: Equatable, Hashable {
    public init(bookmarked: Bool, id: ContentId, rating: ContentRating, status: ContentStatus, headline: String, lead: String? = nil, imageUrl: URL? = nil, audioUrl: URL? = nil, articleBodyHtml: String? = nil, imageAlt: String? = nil, length: Int? = nil) {
        self.bookmarked = bookmarked
        self.id = id
        self.rating = rating
        self.status = status
        self.headline = headline
        self.lead = lead
        self.imageUrl = imageUrl
        self.audioUrl = audioUrl
        self.articleBodyHtml = articleBodyHtml
        self.imageAlt = imageAlt
        self.length = length
    }

    public var bookmarked: Bool
    public var id: ContentId
    public var rating: ContentRating
    public var status: ContentStatus
    public var headline: String
    public var lead: String?
    public var imageUrl: URL?
    public var audioUrl: URL?
    public var articleBodyHtml: String?
    public var imageAlt: String?
    public var length: Int?
}
