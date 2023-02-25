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

public protocol AKKeychainManagerProtocol {
    func update(service: String, account: String, data: Data) throws
    func remove(service: String, account: String) throws
    func save(service: String, account: String, data: Data) throws
    func load(service: String, account: String) throws -> String
}

public extension AKKeychainManagerProtocol {
    func update(service: String, account: String, data: String) throws {
        guard let dataFromString = data.data(using: .utf8, allowLossyConversion: false) else {
            throw KeychainError.dataEncoding
        }
        try update(service: service, account: account, data: dataFromString)
    }

    func save(service: String, account: String, data: String) throws {
        guard let dataFromString = data.data(using: .utf8, allowLossyConversion: false) else {
            throw KeychainError.dataEncoding
        }
        try save(service: service, account: account, data: dataFromString)
    }
}

public class AKKeychainManager: AKKeychainManagerProtocol {
    public static let shared = AKKeychainManager()

    private init() {}

    public func update(service: String, account: String, data: Data) throws {
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

        let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue: data] as CFDictionary)

        guard status != errSecSuccess,
              let err = SecCopyErrorMessageString(status, nil) else { return }
        let errorMessage = "KeychainError: Update failed: \(err)"
        print(errorMessage)
        throw KeychainError.updateFailed(message: errorMessage)
    }

    public func remove(service: String, account: String) throws {
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
        let errorMessage = "KeychainError: Remove failed: \(err)"
        print(errorMessage)
        throw KeychainError.removeFailed(message: errorMessage)
    }

    public func save(service: String, account: String, data: Data) throws {
        // Instantiate a new default keychain query
        let keychainQuery = NSMutableDictionary(
            objects: [
                kSecClassGenericPasswordValue,
                service,
                account,
                data
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
        let errorMessage = "KeychainError: Save failed: \(err)"
        print(errorMessage)
        throw KeychainError.saveFailed(message: errorMessage)
    }

    public func load(service: String, account: String) throws -> String {
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
            let errorMessage = "KeychainError: Nothing was retrieved from the keychain. Status code \(status)"
            print(errorMessage)
            throw KeychainError.loadFailed(message: errorMessage)
        }
        guard let retrievedData = dataTypeRef as? Data else {
            let errorMessage = "KeychainError: Load failed"
            print(errorMessage)
            throw KeychainError.loadFailed(message: errorMessage)
        }
        guard let str = String(data: retrievedData, encoding: .utf8) else {
            throw KeychainError.dataDecoding
        }
        return str
    }
}
