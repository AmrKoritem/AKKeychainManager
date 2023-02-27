//
//  CFString+Extension.swift
//  AKKeychainManager
//
//  Created by Amr Koritem on 25/02/2023.
//

import Foundation

extension CFString {
    var nsString: NSString {
        NSString(format: self)
    }
}
