#
# Be sure to run `pod lib lint DDSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LJNetwork'
  s.version          = '1.0.0'
  s.summary          = 'An HTTP networking library written in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "An HTTP networking library written in Swift"

  s.homepage         = 'https://github.com/manajay/LJNetwork'
  s.license          = "MIT"
  s.author           = { 'manajay' => 'manajay.dlj@gmail.com' }
  s.source           = { :git => 'https://github.com/manajay/LJNetwork.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/manajay'

  s.ios.deployment_target = '10.0'

  s.source_files = 'LJNetwork/LJNetwork/**/*'
  
#s.resource_bundles = {
#   'LJNetwork' => ['LJNetwork/Assets/*.png']
# }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

