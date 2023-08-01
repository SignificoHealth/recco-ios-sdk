Pod::Spec.new do |spec|
  spec.name          = 'ReccoHeadless'
  spec.version       = '1.0.0'
  spec.license       = { :type => 'Significo 2023 ©' }
  spec.homepage      = 'https://github.com/viluahealthcare/recco-ios-sdk'
  spec.authors       = { 'Significo' => 'recco@significo.com' }
  spec.summary       = 'Recco description'
  spec.source        = { :git => 'https://github.com/viluahealthcare/recco-ios-sdk.git', :branch => 'develop' }
  spec.module_name   = 'ReccoHeadless'
  
  spec.swift_version = '5.7'
  spec.ios.deployment_target  = '14.0'
  spec.source_files       = 'Sources/ReccoHeadless/**/*.swift'
end
