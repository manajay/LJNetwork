Pod::Spec.new do |s|
  s.name             = 'LJNetwork'
  s.version          = '1.0.0'
  s.summary      	 = "An HTTP networking library"
  s.description      = "An HTTP networking library written in Swift"
  s.homepage         = 'https://github.com/manajay/LJNetwork'
  s.license          = "MIT"
  s.author           = { 'manajay' => 'manajay.dlj@gmail.com' }
  s.source           = { :git => 'https://github.com/manajay/LJNetwork.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/manajay'
  s.ios.deployment_target = '10.0'
  s.source_files = 'LJNetwork/LJNetwork/**/*'
  s.dependency 'Alamofire', '~> 4.7' 
  s.dependency 'ReachabilitySwift', '~> 3' 
  s.dependency 'SwiftyJSON' 
  s.dependency 'SVProgressHUD'
end

