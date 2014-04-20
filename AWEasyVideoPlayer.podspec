Pod::Spec.new do |spec|
  spec.name                  = 'AWEasyVideoPlayer'
  spec.version               = '1.0.0'
  spec.license               = { :type => 'MIT' }
  spec.homepage              = 'https://github.com/awojnowski/AWEasyVideoPlayer'
  spec.authors               = { 'Aaron Wojnowski' => 'aaronwojnowski@gmail.com' }
  spec.summary               = 'Easy Vine and Instagram style video player.'
  spec.source                = { :git => 'https://github.com/awojnowski/AWEasyVideoPlayer.git', :tag => '1.0.0'}
  spec.source_files          = 'AWEasyVideoPlayer/*'
  spec.ios.deployment_target = '7.0'
  spec.ios.frameworks        = 'AVFoundation', 'Foundation', 'UIKit'
  spec.requires_arc          = true
end