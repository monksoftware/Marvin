Pod::Spec.new do |s|
  
  s.name = "Marvin"
  s.version = "0.4.1"
  
  s.license = 'MIT'
  s.swift_versions = '5.0'
  s.summary = "Marvin, the missing toolkit for your iOS library."
  s.homepage = "http://www.monksoftware.it/"
  
  s.description  = <<-DESC
  Marvin is a toolkit designed to work with EIMe. It contains helper classes for networking.
                   DESC
                   
  s.author = { "Webmonks SRL" => "marvin@monksoftware.it" }
  s.source = { :git => "https://github.com/monksoftware/Marvin.git", :tag => "#{s.version}" }
  
  s.swift_versions = ['5', '5.1']
  s.ios.deployment_target = '9.0'
  
  s.source_files = "Sources/**/*.{swift}"
end
