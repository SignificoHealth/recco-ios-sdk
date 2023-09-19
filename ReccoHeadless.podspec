Pod::Spec.new do |spec|
  spec.name          = 'ReccoHeadless'
  spec.version       = '1.0.2'
  spec.license       = { :type => 'Significo 2023 ©' }
  spec.homepage      = 'https://github.com/sf-recco/ios-sdk'
  spec.authors       = { 'Significo' => 'recco@significo.com' }
  spec.summary       = 'Recco iOS SDK. This headless version allows the consumer to provide their own UI.'
  spec.source        = { :git => 'https://github.com/sf-recco/ios-sdk.git', :tag => spec.version }
  spec.module_name   = 'ReccoHeadless'
  
  spec.swift_version = '5.7'
  spec.ios.deployment_target  = '14.0'
  spec.source_files       = 'Sources/ReccoHeadless/**/*.swift'
end
