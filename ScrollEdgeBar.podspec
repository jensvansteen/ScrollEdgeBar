Pod::Spec.new do |s|
  s.name         = "ScrollEdgeBar"
  s.version      = "0.1.0"
  s.summary      = "iOS 26+ scroll edge bar with glass blur effect"
  s.homepage     = "https://github.com/jensvansteen/ScrollEdgeBar"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = "Jens Van Steen"

  s.platforms    = { :ios => "15.1" }
  s.source       = { :git => "https://github.com/jensvansteen/ScrollEdgeBar.git", :tag => "#{s.version}" }

  s.source_files = "Sources/ScrollEdgeBar/**/*.{swift}"
  s.swift_version = "6.2"
end
