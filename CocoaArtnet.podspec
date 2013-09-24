Pod::Spec.new do |s|
  s.name         = "CocoaArtnet"
  s.version      = "0.0.2"
  s.summary      = "DMX Control library for iOS."

  s.description  = <<-DESC
                   An implementation of the ArtNet lighing control protocol for iOS.
                   DESC

  s.homepage     = "https://github.com/philchristensen/CocoaArtnet"

  s.license      = 'MIT'

  s.author       = { "Phil Christensen" => "phil@bubblehouse.org" }
  s.platform     = :ios
  
  s.source       = { :git => "https://github.com/philchristensen/CocoaArtnet.git", :tag => "0.0.2" }
  s.source_files  = 'CocoaArtnet', 'CocoaArtnet/**/*.{h,m}'
  
  s.requires_arc = true
  
  s.dependency 'CocoaAsyncSocket', '~> 0.0.1'
  s.dependency 'YACYAML', '~> 0.0.1'
end
