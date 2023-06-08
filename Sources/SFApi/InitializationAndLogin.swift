//
//  File.swift
//  
//
//  Created by Adrián R on 30/5/23.
//

import Foundation

public func initialize(
    clientSecret: String,
    baseUrl: String
) {
    OpenAPIClientAPI.requestBuilderFactory = BearerRequestBuilderFactory()
    OpenAPIClientAPI.basePath = baseUrl
    BearerTokenHandler.clientSecret = "Bearer \(clientSecret)"
    OpenAPIClientAPI.customHeaders["Accept-Language"] = "en-US"
}

public func clientIdChanged(_ newValue: String?) {
    BearerTokenHandler.clientId = newValue
}

public func logedIn(newBearer: String) {
    BearerTokenHandler.bearerToken = newBearer
}

public func logedOut() {
    BearerTokenHandler.bearerToken = nil
}
