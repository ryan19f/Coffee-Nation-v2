//
//  KeychainHelper.swift
//  Coffee Nation
//
//  Created by student on 4/16/25.
//

import Foundation
import Security

class KeychainHelper {
    static func save(_ key: String, _ data: Data) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query) // Overwrite if exists
        SecItemAdd(query, nil)
    }

    static func load(_ key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return result as? Data
    }

    static func delete(_ key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        SecItemDelete(query)
    }
}
