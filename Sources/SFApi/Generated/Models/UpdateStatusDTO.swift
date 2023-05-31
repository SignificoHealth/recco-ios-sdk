//
// UpdateStatusDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct UpdateStatusDTO: Codable, JSONEncodable, Hashable {

    public enum ContentTypeDTO: String, Codable, CaseIterable {
        case articles = "articles"
    }
    public enum StatusDTO: String, Codable, CaseIterable {
        case noInteraction = "no_interaction"
        case viewed = "viewed"
    }
    public var contentId: ContentIdDTO
    public var contentType: ContentTypeDTO
    public var status: StatusDTO
    public var categoriesIds: [Int]

    public init(contentId: ContentIdDTO, contentType: ContentTypeDTO, status: StatusDTO, categoriesIds: [Int]) {
        self.contentId = contentId
        self.contentType = contentType
        self.status = status
        self.categoriesIds = categoriesIds
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case contentId
        case contentType
        case status
        case categoriesIds
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contentId, forKey: .contentId)
        try container.encode(contentType, forKey: .contentType)
        try container.encode(status, forKey: .status)
        try container.encode(categoriesIds, forKey: .categoriesIds)
    }
}

