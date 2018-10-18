source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!

plugin 'cocoapods-art', :sources => [
'onegini',
'onegini-snapshot'
]

target 'OneginiExampleAppSwift' do
    use_frameworks!
    pod 'OneginiSDKiOS', '9.0.0'
    pod 'Swinject', '2.4.1'
    pod 'BetterSegmentedControl', '~> 0.9'
    pod 'TransitionButton', '0.4.0'
    pod 'SkyFloatingLabelTextField', '~> 3.0'

  target 'OneginiExampleAppSwiftTests' do
     inherit! :search_paths
    # Pods for testing
  end

  target 'OneginiExampleAppSwiftUITests' do
     inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
    end
end
