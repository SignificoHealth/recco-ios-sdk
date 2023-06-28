import Foundation
import Combine

public protocol MeRepo {
    var currentUser: AnyPublisher<AppUser?, Never> { get }
    func getMe() async throws 
}

final class LiveMeRepo: MeRepo {
    let keychain: KeychainProxy
    let _currentUser: CurrentValueSubject<AppUser?, Never>
    
    public var currentUser: AnyPublisher<AppUser?, Never> {
        _currentUser.eraseToAnyPublisher()
    }
    
    init(keychain: KeychainProxy) {
        self.keychain = keychain
        self._currentUser = .init(try? keychain.read(key: .currentUser))
    }
        
    public func getMe() async throws {
        let dto = try await AppUserAPI.callGet()
        let user = AppUser(dto: dto)
        try keychain.save(key: .currentUser, user)
        _currentUser.value = user
    }
}
