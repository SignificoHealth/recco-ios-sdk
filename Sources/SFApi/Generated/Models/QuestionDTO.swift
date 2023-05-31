//
// QuestionDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct QuestionDTO: Codable, JSONEncodable, Hashable {

    public enum TypeDTO: String, Codable, CaseIterable {
        case multichoice = "multichoice"
        case numeric = "numeric"
    }
    public var id: String
    public var index: Int
    public var text: String
    public var type: TypeDTO
    public var multiChoice: MultiChoiceQuestionDTO?
    public var numeric: NumericQuestionDTO?

    public init(id: String, index: Int, text: String, type: TypeDTO, multiChoice: MultiChoiceQuestionDTO? = nil, numeric: NumericQuestionDTO? = nil) {
        self.id = id
        self.index = index
        self.text = text
        self.type = type
        self.multiChoice = multiChoice
        self.numeric = numeric
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case index
        case text
        case type
        case multiChoice
        case numeric
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(index, forKey: .index)
        try container.encode(text, forKey: .text)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(multiChoice, forKey: .multiChoice)
        try container.encodeIfPresent(numeric, forKey: .numeric)
    }
}

