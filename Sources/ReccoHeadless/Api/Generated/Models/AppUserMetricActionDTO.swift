//
// AppUserMetricActionDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal enum AppUserMetricActionDTO: String, Codable, CaseIterable {
    case login = "login"
    case duration = "duration"
    case view = "view"
    case hostAppOpen = "host_app_open"
    case reccoSdkOpen = "recco_sdk_open"
}
