import Foundation

public enum Api {
    static public func initialize(
        clientSecret: String,
        baseUrl: String,
        keychain: KeychainProxy
    ) {
        OpenAPIClientAPI.requestBuilderFactory = BearerRequestBuilderFactory()
        OpenAPIClientAPI.basePath = baseUrl
        BearerTokenHandler.clientSecret = "Bearer \(clientSecret)"
        OpenAPIClientAPI.customHeaders["Accept-Language"] =  Locale.current.identifier.contains("de") ? "de-DE": "en-US"
        OpenAPIClientAPI.customHeaders["Client-Platform"] = "iOS"
        BearerTokenHandler.keychain = keychain
        
        let clientId: String? = try? keychain.read(key: .clientUserId)
        clientId.map(setClientId)
    }
    
    static public func setClientId(_ newValue: String?) {
        BearerTokenHandler.clientId = newValue
    }

    static public func setAccessToken(_ newBearer: String?) {
        BearerTokenHandler.bearerToken = newBearer
    }
    
}
