//
//  AKKeychainManager.swift
//  AKKeychainManager
//
//  Created by Amr Koritem on 13/02/2023.
//

import Foundation
import Security

let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

protocol AKKeychainManagerProtocol {
    func update(service: String, account: String, data: String)
    func remove(service: String, account: String)
    func save(service: String, account: String, data: String)
    func load(service: String, account:String) -> String?
}

public class AKKeychainManager {
    public static let shared = AKKeychainManager()

    private init() {}

    public func update(service: String, account: String, data: String) {
        guard let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return }

        // Instantiate a new default keychain query
        let keychainQuery = NSMutableDictionary(
            objects: [
                kSecClassGenericPasswordValue,
                service,
                account
            ],
            forKeys: [
                kSecClassValue,
                kSecAttrServiceValue,
                kSecAttrAccountValue
            ]
        )

        let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue:dataFromString] as CFDictionary)

        guard status != errSecSuccess,
              let err = SecCopyErrorMessageString(status, nil) else { return }
        print("Read failed: \(err)")
    }

    public func remove(service: String, account: String) {
        // Instantiate a new default keychain query
        let keychainQuery = NSMutableDictionary(
            objects: [
                kSecClassGenericPasswordValue,
                service,
                account,
                kCFBooleanTrue!
            ],
            forKeys: [
                kSecClassValue,
                kSecAttrServiceValue,
                kSecAttrAccountValue,
                kSecReturnDataValue
            ]
        )

        // Delete any existing items
        let status = SecItemDelete(keychainQuery as CFDictionary)
        guard status != errSecSuccess,
              let err = SecCopyErrorMessageString(status, nil) else { return }
        print("Remove failed: \(err)")
    }

    public func save(service: String, account: String, data: String) {
        guard let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return }
        // Instantiate a new default keychain query
        let keychainQuery = NSMutableDictionary(
            objects: [
                kSecClassGenericPasswordValue,
                service,
                account,
                dataFromString
            ],
            forKeys: [
                kSecClassValue,
                kSecAttrServiceValue,
                kSecAttrAccountValue,
                kSecValueDataValue
            ]
        )

        // Add the new keychain item
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        guard status != errSecSuccess,
              let err = SecCopyErrorMessageString(status, nil) else { return }
        print("Write failed: \(err)")
    }

    public func load(service: String, account:String) -> String? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery = NSMutableDictionary(
            objects: [
                kSecClassGenericPasswordValue,
                service,
                account,
                kCFBooleanTrue!,
                kSecMatchLimitOneValue
            ],
            forKeys: [
                kSecClassValue,
                kSecAttrServiceValue,
                kSecAttrAccountValue,
                kSecReturnDataValue,
                kSecMatchLimitValue
            ]
        )

        var dataTypeRef :AnyObject?
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)

        guard status == errSecSuccess else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
            return nil
        }
        guard let retrievedData = dataTypeRef as? Data else { return nil }
        return String(data: retrievedData, encoding: String.Encoding.utf8)
    }
}
