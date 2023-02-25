//
//  AKKeychainManager.swift
//  AKKeychainManager
//
//  Created by Amr Koritem on 13/02/2023.
//

import Foundation
import Security

/// Protocol used for unit testing purposes.
public protocol AKKeychainManagerProtocol {
    func update(service: String, account: String, data: Data) throws
    func remove(service: String, account: String) throws
    func save(service: String, account: String, data: Data) throws
    func load(service: String, account: String) throws -> String
}

public extension AKKeychainManagerProtocol {
    /// Update an already saved entry. This method throw an error if the process failed.
    /// - Parameters:
    ///   - service: Service name.
    ///   - account: Account name.
    ///   - data: String to be saved.
    func update(service: String, account: String, data: String) throws {
        guard let dataFromString = data.data(using: .utf8, allowLossyConversion: false) else {
            throw KeychainError.dataEncoding
        }
        try update(service: service, account: account, data: dataFromString)
    }

    /// Save a new entry. This method throw an error if the process failed.
    /// - Parameters:
    ///   - service: Service name.
    ///   - account: Account name.
    ///   - data: String to be saved.
    func save(service: String, account: String, data: String) throws {
        guard let dataFromString = data.data(using: .utf8, allowLossyConversion: false) else {
            throw KeychainError.dataEncoding
        }
        try save(service: service, account: account, data: dataFromString)
    }
    
    /// Update an already saved entry.
    /// - Parameters:
    ///   - key: Key name.
    ///   - data: String to be saved.
    /// - Returns: True if the process was successfull. False otherwise.
    @discardableResult func update(key: String, data: String) -> Bool {
        do {
            try update(service: key, account: key, data: data)
            return true
        } catch {
            return false
        }
    }

    /// Remove an already saved entry.
    /// - Parameters:
    ///   - key: Key name.
    /// - Returns: True if the process was successfull. False otherwise.
    @discardableResult func remove(key: String) -> Bool {
        do {
            try remove(service: key, account: key)
            return true
        } catch {
            return false
        }
    }

    /// Save a new entry.
    /// - Parameters:
    ///   - key: Key name.
    ///   - data: String to be saved.
    /// - Returns: True if the process was successfull. False otherwise.
    @discardableResult func save(key: String, data: String) -> Bool {
        do {
            try save(service: key, account: key, data: data)
            return true
        } catch {
            return false
        }
    }

    /// Load an already saved entry.
    /// - Parameters:
    ///   - key: Key name.
    /// - Returns: The saved string. If the process failed however, nil is returned.
    func load(key: String) -> String? {
        try? load(service: key, account: key)
    }
}

/// Keychain manager that facilitates saving and restoring data from the device keychain.
public class AKKeychainManager: AKKeychainManagerProtocol {
    /// The singleton KeychainManager instance.
    public static let shared = AKKeychainManager()

    private init() {}
    
    /// Update an already saved entry. This method throw an error if the process failed.
    /// - Parameters:
    ///   - service: Service name.
    ///   - account: Account name.
    ///   - data: Data to be saved.
    public func update(service: String, account: String, data: Data) throws {
        // Instantiate a new default keychain query
        let keychainQuery = NSMutableDictionary(
            objects: [
                kSecClassGenericPassword.nsString,
                service,
                account
            ],
            forKeys: [
                kSecClass.nsString,
                kSecAttrService.nsString,
                kSecAttrAccount.nsString
            ]
        )

        let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueData.nsString: data] as CFDictionary)

        guard status != errSecSuccess,
              let err = SecCopyErrorMessageString(status, nil) else { return }
        let errorMessage = "KeychainError: Update failed: \(err)"
        print(errorMessage)
        throw KeychainError.updateFailed(message: errorMessage)
    }

    /// Remove an already saved entry. This method throw an error if the process failed.
    /// - Parameters:
    ///   - service: Service name.
    ///   - account: Account name.
    public func remove(service: String, account: String) throws {
        // Instantiate a new default keychain query
        let keychainQuery = NSMutableDictionary(
            objects: [
                kSecClassGenericPassword.nsString,
                service,
                account,
                kCFBooleanTrue!
            ],
            forKeys: [
                kSecClass.nsString,
                kSecAttrService.nsString,
                kSecAttrAccount.nsString,
                kSecReturnData.nsString
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

    /// Save a new entry. This method throw an error if the process failed.
    /// - Parameters:
    ///   - service: Service name.
    ///   - account: Account name.
    ///   - data: Data to be saved.
    public func save(service: String, account: String, data: Data) throws {
        // Instantiate a new default keychain query
        let keychainQuery = NSMutableDictionary(
            objects: [
                kSecClassGenericPassword.nsString,
                service,
                account,
                data
            ],
            forKeys: [
                kSecClass.nsString,
                kSecAttrService.nsString,
                kSecAttrAccount.nsString,
                kSecValueData.nsString
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

    /// Load an already saved entry. This method throw an error if the process failed.
    /// - Parameters:
    ///   - service: Service name.
    ///   - account: Account name.
    public func load(service: String, account: String) throws -> String {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery = NSMutableDictionary(
            objects: [
                kSecClassGenericPassword.nsString,
                service,
                account,
                kCFBooleanTrue!,
                kSecMatchLimitOne.nsString
            ],
            forKeys: [
                kSecClass.nsString,
                kSecAttrService.nsString,
                kSecAttrAccount.nsString,
                kSecReturnData.nsString,
                kSecMatchLimit.nsString
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
