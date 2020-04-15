source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!

plugin 'cocoapods-art', :sources => [
'onegini',
'onegini-snapshot'
]

target 'OneginiExampleAppSwift' do
    use_frameworks!
    pod 'Dip'
    pod 'OneginiSDKiOS', '9.5.1'
    pod 'Swinject'
    pod 'BetterSegmentedControl', '~> 0.9'

  target 'OneginiExampleAppSwiftUITests' do
     inherit! :search_paths
    # Pods for testing
  end

end

target 'OneginiExampleAppSwiftTests' do
   use_frameworks!
   pod 'Dip'
   pod 'Swinject'
   pod 'BetterSegmentedControl', '~> 0.9'
   pod 'OneginiSDKiOS', '9.5.1'
   pod 'Quick'
   pod 'Nimble'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
    end
end
