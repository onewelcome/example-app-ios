source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!

plugin 'cocoapods-art', :sources => [
'onegini'
]

def libs()
    use_frameworks!
    pod 'OneginiSDKiOS', '9.5.1'
    pod 'Swinject', '2.4.1'
    pod 'BetterSegmentedControl', '~> 0.9'
    pod 'TransitionButton', '0.5.1'
    pod 'SkyFloatingLabelTextField', '~> 3.0'
end

def testLibs()
    libs()
    pod 'Quick', '2.2.0'
    pod 'Nimble', '8.0.7'
end

target 'OneginiExampleAppSwift' do
    libs()
end

target 'OneginiExampleAppSwiftTests' do
    testLibs()
end

target 'OneginiExampleAppSwiftUITests' do
    testLibs()
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
    end
end
