source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!
#use_modular_headers!

plugin 'cocoapods-art', :sources => ['onegini']

def oneginiSDKiOS
#    pod 'OneginiSDKiOS', '12.0.0'
#    pod 'OneginiSDKiOS', :git => 'https://github.com/onewelcome/sdk-ios.git', :branch => 'SwiftAPI'
    pod 'OneginiSDKiOS', :path => '/Users/szymon/Projects/onegini-msp-sdk-ios'
#pod 'OneginiSDKiOS', :path => '/Users/szymon/Projects/onegini-msp-sdk-ios'
#pod 'OneginiSDKiOS', :path => '/Users/szymon/Projects/onegini-msp-sdk-ios/output/OneginiSDKiOS/OneginiSDKiOS.podspec'

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
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
        if target.name == 'OneginiSDKiOS'
            target.resources_build_phase.files_references.each do |file|
                target.frameworks_build_phase.add_file_reference(file)
                target.resources_build_phase.remove_file_reference(file)
            end
        end
    end
end
