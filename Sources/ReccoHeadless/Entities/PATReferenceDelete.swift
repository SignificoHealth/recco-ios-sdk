import Foundation

public struct PATReferenceDelete: Equatable, Hashable {
    public var tokenId: String

    public init(tokenId: String) {
        self.tokenId = tokenId
    }
}
