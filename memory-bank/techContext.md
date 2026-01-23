# Tech Context: iOS Example App

## Technology Stack

### Core Technologies

#### Language
- **Swift** (primary language)
- **Objective-C** (bridge for SDK configuration)
  - `OneginiConfigModel.h/m` - Configuration files
  - `SecurityController.h/m` - Debug security configuration
  - Bridging header: `OneWelcomeExampleApp-Bridging-Header.h`

#### Platform
- **iOS** (mobile platform)
- Minimum iOS version determined by SDK requirements
- Universal app (iPhone/iPad support)

### Primary Dependencies

#### OneWelcome iOS SDK
- **Purpose**: Secure authentication and identity management
- **Integration**: Swift Package Manager (SPM)
- **Repository**: Private Artifactory (`https://repo.onewelcome.com`)
- **Current Version**: SDK 13.x (recently updated to 13.0.9+)
- **Key Features Used**:
  - User registration and authentication
  - PIN and biometric authentication
  - Mobile authentication (push)
  - Token management
  - App-to-Web SSO
  - Custom authenticators

#### UI Frameworks

**BetterSegmentedControl.xcframework**
- **Purpose**: Segmented control UI component
- **Usage**: Tab selection, option switching
- **Type**: XCFramework (supports arm64 + simulator)

**SkyFloatingLabelTextField.xcframework**
- **Purpose**: Material Design-style text fields with floating labels
- **Usage**: Form inputs, credential entry
- **Type**: XCFramework

**TransitionButton.xcframework**
- **Purpose**: Animated buttons with loading states
- **Usage**: Submit buttons with visual feedback
- **Type**: XCFramework (Note: duplicate "TransitionButton 2.xcframework" exists)

#### Dependency Injection

**Swinject.xcframework**
- **Purpose**: Dependency injection container
- **Usage**: 
  - Component registration in Assembly classes
  - Resolver pattern for dependency resolution
  - Enables loose coupling and testability
- **Type**: XCFramework

### Build Configurations

#### 1. Debug Configuration
- **Location**: `Configuration/Debug/`
- **Purpose**: Development and testing
- **Files**:
  - `OneginiConfigModel.h/m` - SDK configuration
  - `SecurityController.h/m` - Debug security settings
- **Features**: 
  - Development token server
  - Enhanced logging
  - Less strict security for testing

#### 2. Production Configuration
- **Location**: `Configuration/Production/`
- **Purpose**: Release builds
- **Files**:
  - `OneginiConfigModel.h/m` - Production SDK configuration
- **Features**:
  - Production token server
  - Minimal logging
  - Full security enforcement

#### 3. SDK Showcase Configuration
- **Location**: `Configuration/SDK Showcase/`
- **Purpose**: SDK demonstration
- **Features**: Showcases all SDK capabilities

### Project Structure

```
example-app-ios/
├── OneWelcomeExampleApp/           # Main app target
│   ├── AppDelegate.swift           # App entry point
│   ├── AppRouter.swift             # Navigation coordinator
│   ├── Assembly/                   # DI configuration
│   ├── ViewControllers/            # UI layer
│   ├── Presenters/                 # Presentation layer
│   ├── Interactors/                # Business logic layer
│   ├── Entity/                     # Data models
│   ├── ErrorMappings/              # Error transformation
│   ├── Extensions/                 # Swift extensions
│   ├── Assets.xcassets/            # Images & colors
│   └── SupportingFiles/            # Info.plist, etc.
├── widget/                         # Widget extension
├── Configuration/                  # Build configurations
├── *.xcframework/                  # Binary frameworks
├── SPM/                           # Swift Package Manager
└── OneWelcomeExampleApp.xcodeproj/ # Xcode project
```

## Development Setup

### Prerequisites

1. **Xcode**: Latest stable version (iOS SDK)
2. **OneWelcome Artifactory Access**: Required for SDK download
3. **Cocoapods Repository Access**: For dependency management setup
4. **Git**: Version control

### Installation Steps

1. **Configure Artifactory Access**
   - Obtain credentials for `https://repo.onewelcome.com`
   - Follow App Developer Quickstart guide

2. **Setup SPM Registry**
   ```bash
   swift package-registry set --global \
     https://repo.onewelcome.com/artifactory/api/swift/swift-snapshot-local \
     --netrc
   ```

3. **Clone Repository**
   ```bash
   git clone git@github.com:onewelcome/example-app-ios.git
   cd example-app-ios
   ```

4. **Open in Xcode**
   ```bash
   open OneWelcomeExampleApp.xcodeproj
   ```

5. **Build & Run**
   - Select target device/simulator
   - Build configuration (Debug/Production/SDK Showcase)
   - Run (⌘R)

### Token Server Configuration

#### Default Configuration
- App comes pre-configured with token server
- Configuration stored in `OneginiConfigModel.m` files

#### Changing Configuration
- Use **OneWelcome SDK Configurator** tool
- Repository: `https://github.com/onewelcome/sdk-configurator`
- Generates updated configuration files

## Technical Constraints

### SDK Constraints
1. **Network Dependency**: Requires connectivity to token server
2. **Certificate Pinning**: Production builds enforce certificate validation
3. **Platform Requirements**: iOS version must meet SDK minimums
4. **Binary Size**: XCFrameworks add to app size

### Architecture Constraints
1. **DI Container**: All components must be registered in assemblies
2. **Protocol-Based**: Heavy reliance on protocol conformance
3. **Navigation Flow**: Centralized through AppRouter
4. **Error Handling**: Must use AppError mapping pattern

### Security Constraints
1. **Keychain Access**: Required for secure storage
2. **Biometric Availability**: Dependent on device hardware
3. **Push Notifications**: Requires proper entitlements and certificates
4. **Data Protection**: iOS data protection levels enforced

## Code Quality Tools

### SwiftLint
- **Configuration**: `.swiftlint.yml`
- **Purpose**: Code style enforcement
- **Usage**: Runs during build phase
- **Rules**: Custom rules defined in config

### Code Ownership
- **Configuration**: `CODEOWNERS`
- **Purpose**: Define code review responsibilities

## Entitlements

### Main App Entitlements
- **File**: `OneWelcomeExampleApp/OneWelcomeExampleApp.entitlements`
- **Capabilities**:
  - Keychain access groups
  - Associated domains (for App-to-Web SSO)
  - Push notifications

### Widget Extension Entitlements
- **Debug**: `WidgetExtension.entitlements`
- **Release**: `WidgetExtensionRelease.entitlements`
- **Capabilities**:
  - App groups (for data sharing)
  - Keychain access groups

## Widget Extension

### Purpose
Display implicit data in iOS widgets

### Implementation
- **Location**: `widget/`
- **Files**:
  - `Widget.swift` - Widget definition
  - `ImplicitDataView.swift` - UI view
  - `Startup.swift` - Initialization
  - `Info.plist` - Configuration

### Integration
- Updates triggered on app background (`applicationDidEnterBackground`)
- Uses `WidgetKit` framework
- Shares data via app groups

## Dependency Management

### Swift Package Manager (SPM)
- **Location**: `SPM/`
- **Configuration**: `Package.swift`
- **Resolved**: `Package.resolved` (locked versions)
- **Sources**: `SPM/Sources/` contains XCFrameworks

### XCFrameworks Distribution
Frameworks included both as:
1. Root-level XCFrameworks (for traditional linking)
2. SPM/Sources XCFrameworks (for SPM)

**Included Frameworks**:
- BetterSegmentedControl.xcframework
- SkyFloatingLabelTextField.xcframework
- Swinject.xcframework
- TransitionButton.xcframework
- OneginiSDKiOS.xcframework (SDK itself)

## Build System

### Xcode Project
- **File**: `OneWelcomeExampleApp.xcodeproj/project.pbxproj`
- **Schemes**: Defined in `xcshareddata/xcschemes/`
- **Workspace**: `project.xcworkspace/`

### Build Phases
1. Compile Sources
2. Link Binary with Libraries (XCFrameworks)
3. SwiftLint (if configured)
4. Copy Bundle Resources
5. Embed Frameworks

## Testing Infrastructure

### Unit Tests
- Location: Would be in test targets (not visible in current structure)
- Framework: XCTest
- Mocking: Protocol-based for easy mocking

### UI Tests
- Requires configured token server
- Tests full authentication flows
- Device/simulator testing

## Debugging Tools

### Logging
- Development: Verbose SDK logging enabled
- Production: Minimal logging

### Breakpoints
- Protocol methods for flow tracking
- Completion handlers for async debugging
- SDK callback points

## Version Control

### Git Configuration
- **Repository**: `git@github.com:onewelcome/example-app-ios.git`
- **Current Branch**: `OAD-404` (feature branch)
- **Main Branch**: `master`
- **Ignore**: `.gitignore` configured for iOS/Swift projects

### Recent Updates
- Latest commit: `9126f6e` - "Switched to SDKDependencies 2.0.0"
- SDK version bumped to 13.x series
- Browser IDP support added (SDKIOS-1175)

## Performance Considerations

### App Size
- XCFrameworks contribute significant size
- Multiple architectures (arm64, x86_64-simulator)
- Asset catalog optimization important

### Runtime Performance
- DI resolution: Cached after first resolution
- SDK operations: Network-dependent
- UI: Auto Layout performance considerations

## Deployment

### App Store Distribution
- Requires production configuration
- Proper entitlements and provisioning
- SDK license compliance

### TestFlight/Ad-Hoc
- Can use debug or production configuration
- Push notification certificates required
- Token server accessibility needed

## Tool Usage Patterns

### Common Development Commands

```bash
# Build from command line
xcodebuild -project OneWelcomeExampleApp.xcodeproj \
  -scheme OneWelcomeExampleApp \
  -configuration Debug \
  build

# Run SwiftLint
swiftlint

# Clean build artifacts
rm -rf DerivedData/

# Update SPM dependencies
swift package update
```

## License

**Apache License 2.0**
- File: `LICENSE.txt`
- All source files include license header
- Open source but references proprietary SDK
