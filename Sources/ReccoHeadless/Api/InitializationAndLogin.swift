import Foundation

public enum Api {
    public static func initialize(
        clientSecret: String,
        baseUrl: String,
        keychain: KeychainProxy
    ) {
        OpenAPIClientAPI.requestBuilderFactory = BearerRequestBuilderFactory()
        OpenAPIClientAPI.basePath = baseUrl
        BearerTokenHandler.clientSecret = "Bearer \(clientSecret)"
        OpenAPIClientAPI.customHeaders["Accept-Language"] = Locale.current.identifier.contains("de") ? "de-DE" : "en-US"
        OpenAPIClientAPI.customHeaders["Client-Platform"] = "iOS"
        BearerTokenHandler.keychain = keychain

        let clientId: String? = try? keychain.read(key: .clientUserId)
        clientId.map(setClientId)
    }

    public static func setClientId(_ newValue: String?) {
        BearerTokenHandler.clientId = newValue
    }

    public static func setAccessToken(_ newBearer: String?) {
        BearerTokenHandler.bearerToken = newBearer
    }
}
