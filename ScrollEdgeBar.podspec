Pod::Spec.new do |s|
  s.name         = "ScrollEdgeBar"
  s.version      = "1.2.0"
  s.summary      = "Sticky scroll edge bars with iOS 26 glass blur effect and an iOS 16+ plain fallback"
  s.homepage     = "https://github.com/jensvansteen/ScrollEdgeBar"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = "Jens Van Steen"

  s.platforms    = { :ios => "16.0" }
  s.source       = { :git => "https://github.com/jensvansteen/ScrollEdgeBar.git", :tag => "#{s.version}" }

  s.source_files = "Sources/ScrollEdgeBar/**/*.{swift}"
  s.swift_version = "6.2"
end
