import Foundation

public enum ContentType: String, Codable, CaseIterable {
    case articles
    case questionnaire
    case audio
    case video
}

public struct AppUserRecommendation: Equatable, Hashable {
    public init(id: ContentId, type: ContentType, rating: ContentRating, status: ContentStatus, headline: String, imageUrl: URL? = nil, imageAlt: String? = nil, durationSeconds: Int? = nil) {
        self.id = id
        self.type = type
        self.rating = rating
        self.status = status
        self.headline = headline
        self.imageUrl = imageUrl
        self.imageAlt = imageAlt
        self.durationSeconds = durationSeconds
    }

    public var id: ContentId
    public var type: ContentType
    public var rating: ContentRating
    public var status: ContentStatus
    public var headline: String
    public var imageUrl: URL?
    public var imageAlt: String?
    public var durationSeconds: Int?
}
