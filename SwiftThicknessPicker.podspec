Pod::Spec.new do |s|
s.name         = "SwiftThicknessPicker"
s.version      = "0.6.1"
s.summary      = "Swift Thickness Picker"
s.description  = "A simple iOS Thickness Picker"
s.homepage     = "https://github.com/maximbilan/SwiftThicknessPicker"
s.license      = { :type => "MIT" }
s.author       = { "Maxim Bilan" => "maximb.mail@gmail.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/maximbilan/SwiftThicknessPicker.git", :tag => s.version.to_s }
s.source_files = "Classes", "SwiftThicknessPicker/Sources/**/*.{swift}"
s.requires_arc = true
end