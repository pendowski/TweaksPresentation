Pod::Spec.new do |s|

  s.name         = "TweaksPresentation"
  s.version      = "0.1.1"
  s.summary      = "Small library based on Tweaks for improving screen sharing or recording presentation with visible touches"

  s.homepage     = "https://github.com/pendowski/TweaksPresentation"

  s.license      = "MIT"

  s.author             = { "Jarek Pendowski" => "jarek@pendowski.com" }
  s.social_media_url   = "http://twitter.com/iloveshw"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/pendowski/TweaksPresentation.git", :tag => "0.1.1" }

  s.source_files  = "TweaksPresentation/*.{h,m}"
  s.requires_arc = true

  s.dependency "Tweaks", "~> 2.0"

end
