import Foundation

public struct PAT: Equatable, Hashable {
    public var accessToken: String
    public var expirationDate: Date

    public init(accessToken: String, expirationDate: Date) {
        self.accessToken = accessToken
        self.expirationDate = expirationDate
    }
}

