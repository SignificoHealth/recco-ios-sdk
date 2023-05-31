import Foundation

public struct UpdateRating: Equatable, Hashable {
    public var contentId: ContentId
    public var contentType: ContentType
    public var rating: ContentRating
    public var categoriesIds: [Int]

    public init(contentId: ContentId, contentType: ContentType, rating: ContentRating, categoriesIds: [Int]) {
        self.contentId = contentId
        self.contentType = contentType
        self.rating = rating
        self.categoriesIds = categoriesIds
    }
}

