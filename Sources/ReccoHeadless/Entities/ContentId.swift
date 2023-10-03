import Foundation

public struct ContentId: Equatable, Hashable {
    public var itemId: String
    public var catalogId: String

    public init(itemId: String, catalogId: String) {
        self.itemId = itemId
        self.catalogId = catalogId
    }
}
