Pod::Spec.new do |s|
  s.name         = "Marvin"
  s.version      = "0.1"
  s.summary      = ""
  s.description  = <<-DESC
    Your description here.
  DESC
  s.homepage     = "https://github.com/monksoftware/Marvin.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Alessio Arsuffi" => "arsuffi@monksoftware.it" }
  s.social_media_url   = ""
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/monksoftware/Marvin.git.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
