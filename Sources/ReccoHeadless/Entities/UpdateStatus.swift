import Foundation

public struct UpdateStatus: Equatable, Hashable {
    public var contentId: ContentId
    public var contentType: ContentType
    public var status: ContentStatus

    public init(contentId: ContentId, contentType: ContentType, status: ContentStatus) {
        self.contentId = contentId
        self.contentType = contentType
        self.status = status
    }
}
