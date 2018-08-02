source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!

plugin 'cocoapods-art', :sources => [
'onegini',
'onegini-snapshot'
]

target 'OneginiExampleAppSwift' do
    use_frameworks!
    pod 'OneginiSDKiOS', '8.0.1-SNAPSHOT'
    pod 'Swinject'
    pod 'BetterSegmentedControl', '~> 0.9'

  target 'OneginiExampleAppSwiftTests' do
     inherit! :search_paths
     use_frameworks!
     pod 'Quick'
     pod 'Nimble'
  end

  target 'OneginiExampleAppSwiftUITests' do
     inherit! :search_paths
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
    end
end
