import Foundation

public struct UpdateRating: Equatable, Hashable {
    public var contentId: ContentId
    public var contentType: ContentType
    public var rating: ContentRating

    public init(contentId: ContentId, contentType: ContentType, rating: ContentRating) {
        self.contentId = contentId
        self.contentType = contentType
        self.rating = rating
    }
}

