//
//  KeychainError.swift
//  AKKeychainManager
//
//  Created by Amr Koritem on 25/02/2023.
//

import Foundation

public enum KeychainError: Error {
    case dataEncoding, dataDecoding
    case updateFailed(message: String)
    case removeFailed(message: String)
    case saveFailed(message: String)
    case loadFailed(message: String)

    public var localizedDescription: String {
        switch self {
        case .dataEncoding:
            return "KeychainError: Data encoding failed"
        case .dataDecoding:
            return "KeychainError: Data decoding failed"
        case .updateFailed(let message):
            return message
        case .removeFailed(let message):
            return message
        case .saveFailed(let message):
            return message
        case .loadFailed(let message):
            return message
        }
    }
}
