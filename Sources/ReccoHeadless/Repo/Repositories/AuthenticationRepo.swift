import Foundation




public protocol AuthRepository {
    func login(clientUserId: String) async throws
    func logout() async throws
}

final class LiveAuthRepository: AuthRepository {
    private let keychain: KeychainProxy
    private let clientSecret: String
    
    init(keychain: KeychainProxy, clientSecret: String) {
        self.keychain = keychain
        self.clientSecret = clientSecret
    }
    
    public func login(clientUserId: String) async throws {
        let dto = try await AuthenticationAPI.login(
            authorization: "Bearer \(clientSecret)",
            clientUserId: clientUserId
        )
        
        try keychain.save(key: .currentPat, PAT(dto: dto))
        try keychain.save(key: .clientUserId, clientUserId)
        
        Api.logedIn(newBearer: dto.accessToken)
    }
    
    public func logout() async throws {
        struct NoUserOrPatStored: Error {}
        
        let currentUserId: String? = try keychain.read(key: .clientUserId)
        let currentPat: PAT? = try keychain.read(key: .currentPat)
        
        guard let currentUserId = currentUserId,
              let currentPat = currentPat else {
            throw NoUserOrPatStored()
        }

        try await AuthenticationAPI.logout(
            authorization: "Bearer \(clientSecret)",
            clientUserId: currentUserId,
            pATReferenceDeleteDTO: .init(tokenId: currentPat.tokenId)
        )
        
        keychain.remove(key: .currentPat)
        keychain.remove(key: .currentUser)
        keychain.remove(key: .clientUserId)

        Api.logedOut()
        Api.clientIdChanged(nil)
    }
}
