import Foundation

public struct UpdateStatusDTO: Equatable, Hashable {
    public var contentId: ContentId
    public var contentType: ContentType
    public var status: ContentStatus
    public var categoriesIds: [Int]

    public init(contentId: ContentId, contentType: ContentType, status: ContentStatus, categoriesIds: [Int]) {
        self.contentId = contentId
        self.contentType = contentType
        self.status = status
        self.categoriesIds = categoriesIds
    }
}

