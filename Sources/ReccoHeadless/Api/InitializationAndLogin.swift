import Foundation

private extension Locale {
    var reccoAPILanguage: String {
        switch (languageCode, regionCode) {
        case ("de", _):
            return "de-DE"
        case ("en", "DE"):
            return "en-DE"
        default:
            return "en-US"
        }
    }
}

public enum Api {
    public static func initialize(
        clientSecret: String,
        baseUrl: String,
        keychain: KeychainProxy
    ) {
        OpenAPIClientAPI.requestBuilderFactory = BearerRequestBuilderFactory()
        OpenAPIClientAPI.basePath = baseUrl
        BearerTokenHandler.clientSecret = "Bearer \(clientSecret)"
        OpenAPIClientAPI.customHeaders["Accept-Language"] = Locale.current.reccoAPILanguage
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
