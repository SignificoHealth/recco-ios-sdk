import Foundation

public enum ContentType: String, Codable, CaseIterable {
    case articles = "articles"
}

public struct AppUserRecommendation: Equatable, Hashable {
    public var id: ContentId
    public var type: ContentType
    public var rating: ContentRating
    public var status: ContentStatus
    public var headline: String
    public var lead: String?
    public var imageUrl: URL?
    public var imageAlt: String?

    public init(id: ContentId, type: ContentType, rating: ContentRating, status: ContentStatus, headline: String, lead: String? = nil, imageUrl: URL? = nil, imageAlt: String? = nil) {
        self.id = id
        self.type = type
        self.rating = rating
        self.status = status
        self.headline = headline
        self.lead = lead
        self.imageUrl = imageUrl
        self.imageAlt = imageAlt
    }
}
