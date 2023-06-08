import Foundation
import SFEntities
import SFApi
import SFCore

public protocol AuthRepository {
    func login(clientUserId: String) async throws
    func logout() async throws
}

public class LiveAuthRepository: AuthRepository {
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
        
        try keychain.save(key: .currentUserId, AppUser(id: clientUserId))
        try keychain.save(key: .currentPat, PAT(dto: dto))
        
        SFApi.logedIn(newBearer: dto.accessToken)
    }
    
    public func logout() async throws {
        struct NoUserOrPatStored: Error {}
        
        let currentUserId: AppUser? = try keychain.read(key: .currentUserId)
        let currentPat: PAT? = try keychain.read(key: .currentPat)
        
        guard let currentUserId = currentUserId,
              let currentPat = currentPat else {
            throw NoUserOrPatStored()
        }

        try await AuthenticationAPI.logout(
            authorization: "Bearer \(clientSecret)",
            clientUserId: currentUserId.id,
            pATReferenceDeleteDTO: .init(tokenId: currentPat.tokenId)
        )
    }
}
