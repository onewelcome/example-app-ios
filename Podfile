source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!

plugin 'cocoapods-art', :sources => ['onegini']

def oneginiSDKiOS
   pod 'OneginiSDKiOS', '~> 12.0.0'
end

target 'WidgetExtension' do
	oneginiSDKiOS
end

target 'OneginiExampleAppSwift' do
  oneginiSDKiOS
  pod 'Swinject', '2.8.1'
  pod 'BetterSegmentedControl', '~> 2.0.0'
  pod 'TransitionButton', '0.5.3'
  pod 'SkyFloatingLabelTextField', '~> 3.0'

	target 'OneginiExampleAppSwiftTests' do
		inherit! :search_paths
  end

  target 'OneginiExampleAppSwiftUITests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
