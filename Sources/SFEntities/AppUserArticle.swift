import Foundation

public struct AppUserArticle: Equatable, Hashable {
    public init(id: ContentId, rating: ContentRating, status: ContentStatus, headline: String, bookmarked: Bool, lead: String? = nil, imageUrl: URL? = nil, articleBodyHtml: String? = nil) {
        self.id = id
        self.rating = rating
        self.status = status
        self.headline = headline
        self.lead = lead
        self.imageUrl = imageUrl
        self.articleBodyHtml = articleBodyHtml
        self.bookmarked = bookmarked
    }
    
    public var bookmarked: Bool
    public var id: ContentId
    public var rating: ContentRating
    public var status: ContentStatus
    public var headline: String
    public var lead: String?
    public var imageUrl: URL?
    public var articleBodyHtml: String?
}
