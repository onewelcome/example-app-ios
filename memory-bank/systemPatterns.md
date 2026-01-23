# System Patterns: iOS Example App

## Architecture Overview

The iOS Example App follows a **VIPER-like architecture** with dependency injection, creating a clean separation of concerns and testable components.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        AppDelegate                           │
│  - Initializes app                                          │
│  - Starts SDK                                               │
│  - Handles push notifications                               │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│                        AppRouter                             │
│  - Manages navigation flow                                  │
│  - Coordinates between presenters                           │
│  - Handles view transitions                                 │
└─────────────────┬───────────────────────────────────────────┘
                  │
    ┌─────────────┼─────────────┐
    ▼             ▼             ▼
┌─────────┐  ┌─────────┐  ┌─────────┐
│  View   │  │Presenter│  │Interactor│
│Controllers│ │         │  │         │
└─────────┘  └─────────┘  └─────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │ OneWelcome SDK   │
                    └──────────────────┘
```

## VIPER Architecture Components

### 1. View (ViewControllers)
**Responsibility**: UI presentation and user interaction
- Displays data provided by Presenter
- Captures user input and forwards to Presenter
- No business logic
- Uses protocols for Presenter communication

**Location**: `OneWelcomeExampleApp/ViewControllers/`

**Pattern**:
```swift
protocol SomeViewProtocol: AnyObject {
    func updateView(with data: Model)
    func showError(_ error: AppError)
}

class SomeViewController: UIViewController, SomeViewProtocol {
    var presenter: SomePresenterProtocol?
    
    func updateView(with data: Model) {
        // Update UI
    }
}
```

### 2. Interactor
**Responsibility**: Business logic and SDK interaction
- Communicates with OneWelcome SDK
- Performs data operations
- Independent of UI
- Returns results to Presenter via callbacks

**Location**: `OneWelcomeExampleApp/Interactors/`

**Pattern**:
```swift
protocol SomeInteractorProtocol {
    func performAction(completion: @escaping (Result<Data, AppError>) -> Void)
}

class SomeInteractor: SomeInteractorProtocol {
    func performAction(completion: @escaping (Result<Data, AppError>) -> Void) {
        // Call SDK
        // Process results
        // Return via completion
    }
}
```

### 3. Presenter
**Responsibility**: Presentation logic and flow coordination
- Receives user actions from View
- Calls Interactor for business logic
- Formats data for View display
- Coordinates with Router for navigation

**Location**: `OneWelcomeExampleApp/Presenters/`

**Pattern**:
```swift
protocol SomePresenterProtocol {
    func handleUserAction()
}

class SomePresenter: SomePresenterProtocol {
    weak var view: SomeViewProtocol?
    var interactor: SomeInteractorProtocol
    var router: AppRouterProtocol
    
    func handleUserAction() {
        interactor.performAction { [weak self] result in
            switch result {
            case .success(let data):
                self?.view?.updateView(with: data)
            case .failure(let error):
                self?.view?.showError(error)
            }
        }
    }
}
```

### 4. Entity
**Responsibility**: Data models
- Plain data structures
- No business logic
- Used to pass data between layers

**Location**: `OneWelcomeExampleApp/Entity/`

### 5. Router
**Responsibility**: Navigation and screen transitions
- Manages view controller hierarchy
- Handles navigation flow
- Coordinates between different presenters
- Manages alerts and error dialogs

**Location**: `OneWelcomeExampleApp/AppRouter.swift`

## Key Technical Decisions

### Dependency Injection with Swinject

**Why**: Loose coupling, testability, centralized configuration

**Implementation**:
- `AppAssembly`: Central assembly that combines all assemblies
- `ViewControllerAssembly`: Registers all view controllers
- `InteractorAssembly`: Registers all interactors
- `PresenterAssembly`: Registers all presenters
- `RouterAssembly`: Registers router and navigation

**Pattern**:
```swift
class AppAssembly {
    static let shared = AppAssembly()
    let resolver: Resolver
    
    private let assembler = Assembler([
        ViewControllerAssembly(),
        InteractorAssembly(),
        PresenterAssembly(),
        RouterAssembly()
    ])
}
```

**Usage**:
```swift
var navigationController = AppAssembly.shared.resolver.resolve(UINavigationController.self)
```

### Error Handling Pattern

**Centralized Error Mapping**:
- SDK errors mapped to app-specific errors
- Domain-specific error mappings in `ErrorMappings/`
- Consistent error presentation via `AppError`

**Pattern**:
```swift
class AppError: Error {
    let title: String
    let errorDescription: String
    let recoverySuggestion: String
    var shouldLogout = false
}

// Error mapping
class ErrorMapper {
    static func map(_ error: NSError, from domain: ErrorDomain) -> AppError {
        // Domain-specific mapping
    }
}
```

### Authentication Flow Pattern

**Challenge-Response Model**:
1. User initiates action (login, registration)
2. SDK returns challenge (PIN, biometric, custom)
3. App presents appropriate UI for challenge
4. User provides response
5. SDK validates and completes flow

**Implementation**:
- Interactors handle SDK communication
- Presenters manage challenge presentation
- ViewControllers display challenge UI
- Callbacks propagate results through layers

## Design Patterns in Use

### 1. Protocol-Oriented Programming
- Heavy use of protocols for abstraction
- All components interact via protocols
- Enables easy testing and mocking

### 2. Delegate Pattern
- View → Presenter communication
- Router → Presenter coordination
- TabBar delegate for navigation control

### 3. Observer Pattern
- Mobile auth queue for pending requests
- Widget updates on app background

### 4. Factory Pattern (via DI)
- Swinject assemblies act as factories
- Centralized object creation

### 5. Singleton Pattern
- `AppAssembly.shared` for DI container
- Used sparingly for app-wide resources

## Component Relationships

### Navigation Flow
```
AppDelegate
    ↓
StartupPresenter → StartupViewController
    ↓
WelcomePresenter → WelcomeViewController
    ↓ (registration)
RegisterUserPresenter → RegisterUserViewController
    ↓ (PIN setup)
PinViewController
    ↓ (success)
DashboardPresenter → TabBarController
    ├── Dashboard
    ├── Authenticators
    └── Mobile Auth
```

### Data Flow Example (Login)
```
LoginViewController (user taps login)
    ↓
LoginPresenter.handleLogin()
    ↓
LoginInteractor.login()
    ↓
OneWelcome SDK
    ↓ (PIN challenge)
LoginInteractor → LoginPresenter
    ↓
PinViewController (presented)
    ↓ (user enters PIN)
LoginInteractor.providePIN()
    ↓
OneWelcome SDK (validates)
    ↓ (success)
LoginPresenter → AppRouter
    ↓
AppRouter.setupDashboardPresenter()
```

## Critical Implementation Paths

### 1. App Initialization
- `AppDelegate.application(didFinishLaunchingWithOptions:)`
- `oneginiSDKStartup()` → `AppRouter.setupStartupPresenter()`
- SDK starts and determines app state
- Routes to appropriate initial screen

### 2. User Registration
- Welcome → Select registration type → Enter credentials
- SDK validates → PIN creation challenge → Biometric setup (optional)
- Success → Auto-login → Dashboard

### 3. User Authentication
- Welcome → Select user → Login flow initiated
- PIN/Biometric challenge → User authenticates
- Success → Dashboard with user profile

### 4. Mobile Authentication
- Push notification received → `MobileAuthQueue` queued
- User opens notification → `PendingMobileAuthPresenter`
- User reviews request → Accepts/Denies → PIN/Biometric confirmation
- Result sent to server

### 5. Error Recovery
- Error occurs at any layer → Mapped to `AppError`
- Presented via `AppRouter.setupErrorAlert()`
- User sees actionable error with recovery options
- Optional retry or logout if needed

## State Management

### User State
- Managed by OneWelcome SDK
- App queries for authenticated user profile
- No local state persistence for auth data

### Navigation State
- Controlled by AppRouter
- Navigation stack managed via UINavigationController
- Tab bar state for authenticated users

### Mobile Auth State
- `MobileAuthQueue` manages pending requests
- In-memory queue, processed sequentially
- Badge updates for pending count

## Security Considerations

### Secure Data Storage
- SDK handles all secure storage (credentials, tokens)
- No sensitive data in UserDefaults or local files
- Keychain access managed by SDK

### Authentication Validation
- All SDK calls validated server-side
- No client-side auth shortcuts
- Proper certificate pinning in SDK

### Error Information
- Error messages don't leak sensitive data
- Generic errors for security operations
- Detailed logging only in debug builds

## Testing Strategy

### Unit Testing
- Interactors testable in isolation
- Presenters testable with mock interactors
- Protocol-based mocking

### Integration Testing
- Test flows through Presenter → Interactor
- Mock SDK responses

### UI Testing
- Full flow testing on simulators/devices
- Requires configured token server
