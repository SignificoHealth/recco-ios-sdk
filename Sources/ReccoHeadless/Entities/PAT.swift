import Foundation

public struct PAT: Equatable, Hashable, Codable {
    public init(accessToken: String, expirationDate: Date, tokenId: String, creationDate: Date) {
        self.accessToken = accessToken
        self.expirationDate = expirationDate
        self.tokenId = tokenId
        self.creationDate = creationDate
    }

    public var accessToken: String
    public var expirationDate: Date
    public var tokenId: String
    public var creationDate: Date
}
