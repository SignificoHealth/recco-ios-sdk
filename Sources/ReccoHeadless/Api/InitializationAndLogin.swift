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
        OpenAPIClientAPI.customHeaders["Accept-Language"] = "en-US"
        OpenAPIClientAPI.customHeaders["Client-Platform"] = "iOS"
        BearerTokenHandler.keychain = keychain
        
        let clientId: String? = try? keychain.read(key: .clientUserId)
        clientId.map(clientIdChanged)
    }
    
    static public func clientIdChanged(_ newValue: String?) {
        BearerTokenHandler.clientId = newValue
    }
    
    static public func logedIn(newBearer: String) {
        BearerTokenHandler.bearerToken = newBearer
    }
    
    static public func logedOut() {
        BearerTokenHandler.bearerToken = nil
    }
}
