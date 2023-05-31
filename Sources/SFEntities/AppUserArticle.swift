import Foundation

public struct AppUserArticle: Equatable, Hashable {
    public var id: String
    public var rating: ContentRating
    public var status: ContentStatus
    public var headline: String
    public var lead: String?
    public var imageUrl: String?
    public var articleBodyHtml: String?
}
