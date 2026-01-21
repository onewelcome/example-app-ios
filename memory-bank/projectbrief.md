# Project Brief: iOS Example App

## Overview
The iOS Example App is a demonstration application showcasing the OneWelcome (formerly Onegini) iOS SDK integration for secure authentication and resource access.

## Primary Purpose
- Demonstrate OneWelcome iOS SDK capabilities
- Provide a reference implementation for app developers
- Showcase secure authentication flows and best practices
- Serve as a starting point for developers integrating the OneWelcome SDK

## Core Requirements

### Functional Requirements
1. **User Authentication**
   - User registration with PIN/biometric authentication
   - User login with multiple authentication methods
   - Support for multiple user profiles
   - Identity provider integration (including Browser IDP)

2. **Security Features**
   - PIN-based authentication
   - Biometric authentication support
   - Secure token management
   - Mobile authentication (push notifications)
   - Device management

3. **User Management**
   - User profile management
   - Multi-user support
   - User disconnect/logout
   - Authenticator registration/deregistration

4. **Advanced Features**
   - Mobile authentication with push notifications
   - App-to-Web Single Sign-On
   - QR code authentication
   - Implicit data fetching
   - ID token retrieval
   - Device list management
   - Widget support for implicit data

### Technical Requirements
1. iOS application using Swift
2. OneWelcome iOS SDK integration
3. Dependency injection using Swinject
4. VIPER-like architecture (View-Interactor-Presenter-Entity-Router)
5. Support for multiple build configurations (Debug, Production, SDK Showcase)

## Success Criteria
- Fully functional demonstration of all OneWelcome SDK features
- Clear code structure that developers can reference
- Stable authentication flows
- Proper error handling and user feedback
- Compliance with OneWelcome security standards

## Target Audience
- iOS developers integrating OneWelcome SDK
- Security engineers evaluating the SDK
- Product teams planning secure authentication implementations

## Constraints
- Must use OneWelcome iOS SDK (accessed via SPM)
- Requires access to OneWelcome Artifactory repository
- Needs properly configured token server
- Follows Apache 2.0 License
