import Foundation


class KeychainManager {
    
    static let shared = KeychainManager()
    
    @discardableResult
    func saveToken(token: String, account: String) -> Bool {
        let tokenData = Data(token.utf8)
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                       kSecAttrAccount: account,
                                       kSecValueData: tokenData]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getToken(account: String) -> String? {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                       kSecAttrAccount: account,
                                       kSecMatchLimit: kSecMatchLimitOne,
                                       kSecReturnData: kCFBooleanTrue!]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    @discardableResult
    func updateToken(newToken: String, account: String) -> Bool {
        let deletionSuccess = deleteToken(account: account)
        
        if !deletionSuccess && getToken(account: account) != nil {
            return false
        }
        
        return saveToken(token: newToken, account: account)
    }
    
    @discardableResult
    func deleteToken(account: String) -> Bool {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                       kSecAttrAccount: account]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
