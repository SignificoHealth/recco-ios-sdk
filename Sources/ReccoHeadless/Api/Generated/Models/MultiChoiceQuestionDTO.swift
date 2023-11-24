//
// MultiChoiceQuestionDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct MultiChoiceQuestionDTO: Codable, JSONEncodable, Hashable {

    internal var maxOptions: Int
    internal var minOptions: Int
    internal var options: [MultiChoiceAnswerOptionDTO]

    internal init(maxOptions: Int, minOptions: Int, options: [MultiChoiceAnswerOptionDTO]) {
        self.maxOptions = maxOptions
        self.minOptions = minOptions
        self.options = options
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case maxOptions
        case minOptions
        case options
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(maxOptions, forKey: .maxOptions)
        try container.encode(minOptions, forKey: .minOptions)
        try container.encode(options, forKey: .options)
    }
}

