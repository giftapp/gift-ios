platform :ios, '9.0'
use_frameworks!

target 'gift' do

  # DI
  pod 'Typhoon', '~> 3.5.1'

  # Async syntax
  # pod 'AsyncSwift', '~> 1.7.2'

  # Log
  # pod 'XCGLogger', '~> 4.0.0'
  pod 'XCGLogger', :git => 'https://github.com/DaveWoodCom/XCGLogger.git', :branch => 'swift_3.0'

  # Networking
  pod 'Alamofire', '~> 4.0.0'

  # JSON mapping
  pod 'SwiftyJSON', :git => 'https://github.com/appsailor/SwiftyJSON.git', :branch => 'swift3'

  # Layout
  pod 'SnapKit', '~> 3.0.0'

  # Keychain access
  pod 'Locksmith', '~> 3.0.0'

  # Facebook
  pod 'Bolts', '~> 1.8.4'
  pod 'FBSDKCoreKit', '~> 4.15.1'
  pod 'FBSDKShareKit', '~> 4.15.1'
  pod 'FBSDKLoginKit', '~> 4.15.1'

  # Date manipulations
  # pod 'SwiftDate', '~> 3.0.8'                                       # not used yet
  pod 'SwiftDate', :git => 'https://github.com/malcommac/SwiftDate.git', :branch => 'feature/swift-3.0'

  # Image picker
  # pod 'ImagePicker', '~> 1.4.0'                                     # not used yet
  pod 'ImagePicker', :git => 'https://github.com/hyperoslo/ImagePicker.git', :branch => 'swift-3'

  # Image cache
  pod 'Kingfisher', '~> 3.0.1'                                      # not used yet

  # Image processing
  # pod 'Toucan', '~> 0.5.0'                                          # not used yet

  # UI
  # pod 'TextAttributes', '~> 0.3.1' # Attributed strings             # not used yet
  # pod 'RAMAnimatedTabBarController', '~> 1.5.3' # Animated tab bar  # not used yet
  pod 'PMAlertController', '~> 2.0.0' # Alert controller
  pod 'NVActivityIndicatorView', :git => 'https://github.com/ninjaprox/NVActivityIndicatorView.git' # Activity indicator
  # pod 'MZTimerLabel', '~> 0.5.4' # Countdown UILabel                # not used yet

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

