//
//  DeviceIdentifierPersistance.swift
//  ios-interview
//
//  Created by James Weatherley on 28/10/2026.
//

import Foundation
import Security

struct DeviceIdentifierPersistance {
    
    let keychainService = "net.weatherley.checkout.ios-interview.uuid"
    let keychainAccount = "deviceUUID"
    
    func save(uuid: UUID) {
        
        let data = uuid.uuidString.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        
        // Clear any existing item with this UUID to prevent duplicate errors
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        SecItemDelete(deleteQuery as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Successfully saved data.")
        } else {
            print("Failed to save to Keychain. Error code: \(status)")
            if let errorString = SecCopyErrorMessageString(status, nil) {
                print(errorString)
            }
        }
    }
    
    func fetchUUID() -> UUID? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data else {
            if let errorString = SecCopyErrorMessageString(status, nil) {
                print(errorString)
            }
            return nil
        }
        
        if let uuidString = String(data: data, encoding: .utf8) {
            return UUID(uuidString: uuidString)
        }
        
        return nil
    }
}
