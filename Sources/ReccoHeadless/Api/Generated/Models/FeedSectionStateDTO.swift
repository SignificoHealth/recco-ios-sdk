//
// FeedSectionStateDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal enum FeedSectionStateDTO: String, Codable, CaseIterable {
    case lock = "lock"
    case unlock = "unlock"
    case partiallyUnlock = "partially_unlock"
}
