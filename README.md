[![Swift](https://img.shields.io/badge/Swift-5.0+-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.0+-Orange?style=flat-square)
[![Objective C](https://img.shields.io/badge/Obj-C-orange?style=flat-square)](https://img.shields.io/badge/Obj-C-Orange?style=flat-square)
[![iOS](https://img.shields.io/badge/iOS-Platform-blue?style=flat-square)](https://img.shields.io/badge/iOS-Platform-Blue?style=flat-square)
[![tvOS](https://img.shields.io/badge/tvOS-Platform-blue?style=flat-square)](https://img.shields.io/badge/tvOS-Platform-Blue?style=flat-square)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-Support-yellow?style=flat-square)](https://img.shields.io/badge/CocoaPods-Support-Yellow?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-Support-yellow?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-Support-Yellow?style=flat-square)

# AKKeychainManager

AKKeychainManager manages the keychain services.<br>
  - It works on Swift and Objective C projects.<br>
  - It supports iOS and tvOS.<br>
  - It can be integrated via Cocoa Pods and Swift Package Manager.<br>

## Installation

AKKeychainManager can be installed using [CocoaPods](https://cocoapods.org). Add the following lines to your Podfile:
```ruby
pod 'AKKeychainManager'
```

You can also install it using [swift package manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) as well.
```swift
dependencies: [
    .package(url: "https://github.com/AmrKoritem/AKKeychainManager.git", .upToNextMajor(from: "2.0.0"))
]
```

## Usage

You can specify the service name and account name for your saved entries, and get a thrown error in case of failure using:
```swift
    // Save a new entry
    try AKKeychainManager.shared.save(service: "service-key", account: "account-key", value: "to be saved")
    // Update an already saved entry
    try AKKeychainManager.shared.update(service: "service-key", account: "account-key", value: "to be saved")
    // Load an already saved entry
    try AKKeychainManager.shared.load(service: "service-key", account: "account-key")
    // Remove an already saved entry
    try AKKeychainManager.shared.remove(service: "service-key", account: "account-key")
```

However you can use a simplified version of the above methods as follows:
```swift
    // Save a new entry
    AKKeychainManager.shared.save(key: "key", value: "to be saved")
    // Update an already saved entry
    AKKeychainManager.shared.update(key: "key", value: "to be saved")
    // Load an already saved entry
    AKKeychainManager.shared.load(key: "key")
    // Remove an already saved entry
    AKKeychainManager.shared.remove(key: "key")
```

## Examples

You can check the example project here to see AKKeychainManager in action 🥳.<br>
You can check a full set of examples [here](https://github.com/AmrKoritem/AKLibrariesExamples) as well.

## Contribution 🎉

All contributions are welcome. Feel free to check the [Known issues](https://github.com/AmrKoritem/AKKeychainManager#known-issues) and [Future plans](https://github.com/AmrKoritem/AKKeychainManager#future-plans) sections if you don't know where to start. And of course feel free to raise your own issues and create PRs for them 💪

## Known issues 🫣

Thankfully, there are no known issues at the moment.

## Future plans 🧐

1 - Add methods for keychain encryption.

## Find me 🥰

[LinkedIn](https://www.linkedin.com/in/amr-koritem-976bb0125/)

## License

Please check the license file.
