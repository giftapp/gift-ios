platform :ios, '9.0'
use_frameworks!

target 'gift' do

  # DI
  pod 'Typhoon', '~> 3.5.1'

  # Async syntax
  # pod 'AsyncSwift', '~> 1.7.2'

  # Log
  # pod 'XCGLogger', '~> 3.3'
  pod 'XCGLogger', :git => 'https://github.com/DaveWoodCom/XCGLogger.git', :branch => 'swift_2.3'

  # Networking
  # pod 'Alamofire', '~> 4.0.0'
  pod 'Alamofire', '~> 3.5.0'

  # JSON mapping
  pod 'AlamofireObjectMapper', '~> 3.0.0'

  # Layout
  pod 'Cartography', '~> 0.7.0'

  # Keychain access
  # pod 'Locksmith', '~> 3.0.0'
  pod 'Locksmith', :git => 'https://github.com/matthewpalmer/Locksmith.git', :branch => 'swift-2.3'

  # Facebook
  pod 'Bolts', '~> 1.8.4'
  pod 'FBSDKCoreKit', '~> 4.15.1'
  pod 'FBSDKShareKit', '~> 4.15.1'
  pod 'FBSDKLoginKit', '~> 4.15.1'

  # Date manipulations
  pod 'SwiftDate', '~> 3.0.8'                                       # not used yet

  # Image picker
  pod 'ImagePicker', '~> 1.4.0'                                     # not used yet

  # Image cache
  # pod 'Kingfisher', '~> 3.0.1'                                      # not used yet
  pod 'Kingfisher', :git => 'https://github.com/onevcat/Kingfisher.git', :branch => 'swift2.3'                                      # not used yet

  # Image processing
  # pod 'Toucan', '~> 0.5.0'                                          # not used yet

  # UI
  pod 'TextAttributes', '~> 0.3.1' # Attributed strings             # not used yet
  # pod 'RAMAnimatedTabBarController', '~> 1.5.3' # Animated tab bar  # not used yet
  pod 'PMAlertController', '~> 1.1.0' # Alert controller
  pod 'NVActivityIndicatorView', '~> 2.7' # Activity indicator
  # pod 'MZTimerLabel', '~> 0.5.4' # Countdown UILabel                # not used yet

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
    end
  end
end

