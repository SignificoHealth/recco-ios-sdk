import Foundation

public enum KeychainKey: String, CaseIterable {
    case currentUser = "currentUser"
    case currentPat = "currentPat"
    case clientUserId = "clientId"
}

public final class KeychainProxy {
    private let service: String

    static let standard = KeychainProxy(
        service: "SignificoSF"
    )
    
    private init(service: String) {
        self.service = service
        
        // We need to clear the Keychain on fresh install because Keychain
        // keeps its data even after uninstalling the app
        if !UserDefaults.standard.bool(forKey: "_sfIsKeychainCleared") {
            clearKeychain()
            UserDefaults.standard.set(true, forKey: "_sfIsKeychainCleared")
        }
    }
    
    func save(_ data: Data, account: String) {
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as [CFString : Any] as CFDictionary

        let status = SecItemAdd(query, nil)

        if status == errSecDuplicateItem {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as [CFString : Any] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    func read(account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any] as CFDictionary
        
        SecItemDelete(query)
    }
}

extension KeychainProxy {
    public func remove(
        key: KeychainKey
    ) {
        delete(service: service, account: key.rawValue)
    }
    
    public func save<T>(
        key: KeychainKey,
        _ item: T
    ) throws where T : Codable {
        let data = try JSONEncoder().encode(item)
        save(data, account: key.rawValue)
    }
    
    public func read<T>(key: KeychainKey) throws -> T? where T : Codable {
        guard let data = read(account: key.rawValue) else {
            return nil
        }

        let item = try JSONDecoder().decode(T.self, from: data)
        return item
    }
    
    func clearKeychain() {
        KeychainKey.allCases.forEach { key in
            remove(key: key)
        }
    }
}
