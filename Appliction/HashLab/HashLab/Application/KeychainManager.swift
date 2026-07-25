//
//  KeychainManager.swift
//  HashLab
//
//  Created by Thejas Kasaba on 25/07/26.
//

import Foundation
import Security

private enum KeychainError: Error {
    case unableToSave
    case notFound
    case unexpectedData
    case unhandledError(status: OSStatus)
}

final class KeychainManager {

    static let shared = KeychainManager()
    
    private init(){}
    
    private let service = "com.hashlab.jwt"
    private let account = "accessToken"
    
    

    func saveToken(_ token: String) throws {
        
        deleteToken()
        
        let data = Data(token.utf8)
        
        let query : [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecValueData as String : data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unableToSave
        }
    }

    func readToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { return nil }

        guard let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        return token
    }

    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
