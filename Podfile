source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!

plugin 'cocoapods-art', :sources => ['cocoapods-beta']

def oneginiSDKiOS
  pod 'OneginiSDKiOS', '~> 13.0.0-BETA-dev'
end

def externalRegularDependencies
  pod 'Swinject', '2.8.1'
  pod 'BetterSegmentedControl', '~> 2.0.0'
  pod 'TransitionButton', '0.5.3'
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'SwiftLint', '~> 0.50'
end

target 'WidgetExtension' do
	oneginiSDKiOS
end

target 'OneWelcomeExampleApp' do
  oneginiSDKiOS
  externalRegularDependencies
end

target 'OneWelcomeExampleAppDebug' do
  oneginiSDKiOS
  externalRegularDependencies
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end

