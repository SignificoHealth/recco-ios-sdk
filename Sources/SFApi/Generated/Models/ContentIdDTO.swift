//
// ContentIdDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ContentIdDTO: Codable, JSONEncodable, Hashable {

    public var itemId: String
    public var catalogId: String

    public init(itemId: String, catalogId: String) {
        self.itemId = itemId
        self.catalogId = catalogId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case itemId
        case catalogId
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(itemId, forKey: .itemId)
        try container.encode(catalogId, forKey: .catalogId)
    }
}

