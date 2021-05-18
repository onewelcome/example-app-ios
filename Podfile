source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.1'
inhibit_all_warnings!

plugin 'cocoapods-art', :sources => [
'onegini'
]

target 'WidgetExtension' do
  pod 'OneginiSDKiOS', '10.0.0'
end

target 'OneginiExampleAppSwift' do
    pod 'OneginiSDKiOS', '10.0.0'
    pod 'Swinject', '2.4.1'
    pod 'BetterSegmentedControl', '~> 0.9'
    pod 'TransitionButton', '0.5.1'
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
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.1'
        end
    end
end
