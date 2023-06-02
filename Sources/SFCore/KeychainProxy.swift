// https://gist.github.com/LeeKahSeng/2452e90a57a5324de367907a36d88a49

import Foundation

public enum KeychainKey: String {
    case currentUserId = "currentUserId"
    case currentPat = "currentPat"
}

public final class KeychainProxy {
    private let service: String

    static let standard = KeychainProxy(
        service: "SignificoSF"
    )
    
    private init(service: String) {
        self.service = service
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
}
