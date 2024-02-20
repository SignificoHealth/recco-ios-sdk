//
// StyleDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct StyleDTO: Codable, JSONEncodable, Hashable {

    internal var id: UUID
    internal var name: String
    internal var darkColors: ColorsDTO
    internal var lightColors: ColorsDTO
    internal var iosFont: IOSFontDTO
    internal var androidFont: AndroidFontDTO
    internal var webFont: WebFontDTO
    internal var isPredefined: Bool

    internal init(id: UUID, name: String, darkColors: ColorsDTO, lightColors: ColorsDTO, iosFont: IOSFontDTO, androidFont: AndroidFontDTO, webFont: WebFontDTO, isPredefined: Bool) {
        self.id = id
        self.name = name
        self.darkColors = darkColors
        self.lightColors = lightColors
        self.iosFont = iosFont
        self.androidFont = androidFont
        self.webFont = webFont
        self.isPredefined = isPredefined
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case darkColors
        case lightColors
        case iosFont
        case androidFont
        case webFont
        case isPredefined
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(darkColors, forKey: .darkColors)
        try container.encode(lightColors, forKey: .lightColors)
        try container.encode(iosFont, forKey: .iosFont)
        try container.encode(androidFont, forKey: .androidFont)
        try container.encode(webFont, forKey: .webFont)
        try container.encode(isPredefined, forKey: .isPredefined)
    }
}

