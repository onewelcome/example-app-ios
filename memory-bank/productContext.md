# Product Context: iOS Example App

## Why This Project Exists

The iOS Example App serves as a comprehensive demonstration and reference implementation for developers integrating the OneWelcome (formerly Onegini) iOS SDK into their applications. It bridges the gap between SDK documentation and real-world implementation.

## Problems It Solves

### For Developers
1. **Integration Complexity**: Reduces the learning curve for OneWelcome SDK integration by providing working examples
2. **Best Practices**: Demonstrates secure authentication patterns and proper SDK usage
3. **Time to Market**: Accelerates development by providing reusable code patterns
4. **Architecture Guidance**: Shows how to structure an app with complex authentication flows

### For Organizations
1. **Security Compliance**: Demonstrates compliant implementation of secure authentication
2. **Risk Mitigation**: Reduces implementation errors through proven patterns
3. **Evaluation**: Allows teams to evaluate SDK capabilities before full integration

## How It Should Work

### User Experience Flow

#### First-Time User
1. **Welcome Screen**: User sees available authentication options
2. **Registration**: User creates an account with PIN or biometric authentication
3. **Dashboard**: After registration, user accesses the main dashboard
4. **Feature Exploration**: User can explore various authentication features

#### Returning User
1. **Automatic Detection**: App recognizes registered users
2. **Authentication**: User authenticates with PIN, biometric, or other configured methods
3. **Dashboard Access**: Quick access to all features

### Core User Journeys

#### 1. User Registration
- Select registration method (username/password, browser IDP, etc.)
- Create PIN or enable biometric authentication
- Complete registration process
- Automatic login to dashboard

#### 2. User Authentication
- Select user profile (if multiple users)
- Authenticate using configured method (PIN, biometric)
- Access dashboard and features

#### 3. Mobile Authentication
- Receive push notification for authentication request
- Review authentication details
- Accept or deny the request
- Provide PIN/biometric confirmation

#### 4. Feature Management
- Navigate to profile/settings
- Register/deregister authenticators
- Change PIN
- View device list
- Disconnect/logout

#### 5. App-to-Web Single Sign-On
- Initiate web session from app
- Seamless authentication transfer
- Access web resources with app credentials

## User Experience Goals

### Primary Goals
1. **Clarity**: Every feature should be clearly accessible and understandable
2. **Security Visibility**: Users should understand when and why authentication is required
3. **Smooth Flow**: Minimal friction in authentication processes
4. **Error Recovery**: Clear error messages with actionable recovery steps

### Design Principles
1. **Progressive Disclosure**: Show features as users need them
2. **Immediate Feedback**: Provide real-time status updates (loading states, success/error messages)
3. **Consistency**: Uniform authentication patterns across features
4. **Trust Building**: Visual cues for security operations

### Success Metrics
- Users can complete registration in < 2 minutes
- Authentication succeeds on first attempt > 95% of the time
- Error messages are actionable and clear
- Developers can understand and implement similar flows from the example

## Feature Priorities

### Must Have (Core Features)
1. User registration and login
2. PIN authentication
3. Biometric authentication
4. User profile management
5. Basic error handling

### Should Have (Important Features)
1. Mobile authentication with push
2. Multiple authenticator support
3. Device management
4. App-to-Web SSO
5. QR code authentication

### Nice to Have (Advanced Features)
1. Widget support for implicit data
2. Advanced error recovery flows
3. Custom authenticators
4. Comprehensive logging

## Target User Personas

### Primary: Mobile App Developer
- **Goal**: Integrate secure authentication into their app
- **Pain Point**: Complex security requirements, SDK learning curve
- **Need**: Working examples, clear code patterns, best practices

### Secondary: Security Engineer
- **Goal**: Evaluate OneWelcome SDK security features
- **Pain Point**: Need to see real-world implementation
- **Need**: Comprehensive feature coverage, security patterns

### Tertiary: Product Manager
- **Goal**: Understand SDK capabilities for planning
- **Pain Point**: Technical documentation too detailed
- **Need**: Visual demonstration of features and flows
