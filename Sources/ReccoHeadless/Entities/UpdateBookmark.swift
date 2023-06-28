import Foundation

public struct UpdateBookmark: Equatable, Hashable {
    public var contentId: ContentId
    public var contentType: ContentType
    public var bookmarked: Bool
    
    public init(contentId: ContentId, contentType: ContentType, bookmarked: Bool) {
        self.contentId = contentId
        self.bookmarked = bookmarked
        self.contentType = contentType
    }
}
