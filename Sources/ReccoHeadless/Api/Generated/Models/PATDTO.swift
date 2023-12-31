//
// PATDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct PATDTO: Codable, JSONEncodable, Hashable {

    internal var accessToken: String
    internal var expirationDate: Date
    internal var tokenId: String
    internal var creationDate: Date

    internal init(accessToken: String, expirationDate: Date, tokenId: String, creationDate: Date) {
        self.accessToken = accessToken
        self.expirationDate = expirationDate
        self.tokenId = tokenId
        self.creationDate = creationDate
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case accessToken
        case expirationDate
        case tokenId
        case creationDate
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(expirationDate, forKey: .expirationDate)
        try container.encode(tokenId, forKey: .tokenId)
        try container.encode(creationDate, forKey: .creationDate)
    }
}

