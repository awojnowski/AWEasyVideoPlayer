Pod::Spec.new do |spec|
  spec.name         = 'AWEasyVideoPlayer'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/awojnowski/AWEasyVideoPlayer'
  spec.authors      = { 'Aaron Wojnowski' => 'aaronwojnowski@gmail.com' }
  spec.summary      = 'Easy Vine and Instagram style video player.'
  spec.source       = { :git => 'https://github.com/awojnowski/AWEasyVideoPlayer.git' }
  spec.source_files = 'AWEasyVideoPlayer/*'
  spec.framework    = 'AVFoundation'
  spec.requires_arc = true
end