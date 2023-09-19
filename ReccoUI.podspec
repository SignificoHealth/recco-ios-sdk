Pod::Spec.new do |spec|
  spec.name          = 'ReccoUI'
  spec.version       = '1.0.2'
  spec.license       = { :type => 'Significo 2023 ©' }
  spec.homepage      = 'https://github.com/sf-recco/ios-sdk'
  spec.authors       = { 'Significo' => 'recco@significo.com' }
  spec.summary       = 'Recco iOS SDK. This UI version allows the consumer an easier integration.'
  spec.source        = { :git => 'https://github.com/sf-recco/ios-sdk.git', :tag => spec.version }
  spec.module_name   = 'ReccoUI'
  
  spec.swift_version = '5.7'
  spec.ios.deployment_target  = '14.0'
  spec.source_files       = 'Sources/ReccoUI/**/*.swift'
  spec.resource_bundles = {
    'Recco_ReccoUI' => [
      'Sources/ReccoUI/Resources/Haptics/*.ahap',
      'Sources/ReccoUI/Resources/LocalResources/*'
    ]
  }

  spec.dependency 'ReccoHeadless'
  spec.dependency 'Kingfisher'
end
