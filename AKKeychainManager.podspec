Pod::Spec.new do |s|

s.name = "AKKeychainManager"
s.summary = "AKKeychainManager manages the keychain services."
s.requires_arc = true

s.version = "2.0.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Amr Koritem" => "amr.koritem92@gmail.com" }
s.homepage = "https://github.com/AmrKoritem/AKKeychainManager"
s.source = { :git => "https://github.com/AmrKoritem/AKKeychainManager.git",
             :tag => "v#{s.version}" }

s.framework = "UIKit"
s.source_files = "Sources/AKKeychainManager/**/*.{swift}"
s.swift_version = "5.0"
s.ios.deployment_target = '13.0'
s.tvos.deployment_target = '13.0'

end
