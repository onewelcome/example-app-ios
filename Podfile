source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!

plugin 'cocoapods-art', :sources => [
'onegini'
]

def oneginiSDKiOS
    pod 'OneginiSDKiOS', '11.0.0'
end

target 'WidgetExtension' do
    oneginiSDKiOS
end

target 'OneginiExampleAppSwift' do
    oneginiSDKiOS
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
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
    end
end
