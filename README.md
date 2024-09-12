# iOS Example App

The iOS Example App is using the Onegini iOS SDK to perform secure authentication and resource calls. Please have a look at the
[App developer quickstart](https://docs.onegini.com/app-developer-quickstart.html) if you want more information about how to get setup with this
example app.

## Installation

### Setup access to the OneWelcome SPM repository
The Example app includes the SDK as SPM private repository. In order to let SPM download it you need to setup your account details so the SDK can be
automatically downloaded:
1. Make sure that you have access to the OneWelcome Artifactory repository (https://repo.onewelcome.com). If not please follow first step of [App developer quickstart](https://docs.onegini.com/app-developer-quickstart.html).
2. Follow [Setting up the project guide](https://developer.onewelcome.com/ios/sdk/setting-up-the-project) in the SDK documentation for
instructions on configuring access to the OneWelcome Cocoapods repository.
3. Set SPM registry with a following command:

`swift package-registry set --global https://repo.onewelcome.com/artifactory/api/swift/swift-snapshot-local --netrc`

## Providing token server configuration
The example app is already configured with the token server out of the box.

### Changing the configuration
If there is a need to change the token server configuration within the example app it is going to be best to do it using the Onegini SDK Configurator. Follow
the steps as described in: `https://github.com/onewelcome/sdk-configurator`
