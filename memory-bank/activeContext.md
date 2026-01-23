# Active Context: iOS Example App

## Current Work Focus

### Primary Focus Area
**Maintenance and SDK Updates** - The project is currently on feature branch `OAD-404`, with recent work focused on updating SDK dependencies to version 13.x and adding new SDK features.

### Recent Changes

#### Latest Updates (January 2026)
1. **SDK Dependencies 2.0.0** (Commit: 9126f6e)
   - Switched to new dependency structure
   - Updated to SDK 13.0.9+

2. **SDK 13.x Migration**
   - Upgraded from previous SDK version to 13.x series
   - Updated compatibility and integration code

3. **Browser IDP Support** (SDKIOS-1175)
   - Added support for Browser Identity Provider in stateless flow
   - New authentication method available to users

4. **Mobile Auth Logout Fix** (EXAMPLEIOS-140)
   - Fixed issue where logout failed when mobile auth failed and user considered logged out
   - Improved error handling in authentication flow

## Next Steps

### Immediate Tasks
1. **Testing Current Changes**
   - Verify SDK 13.x integration works correctly
   - Test Browser IDP flow end-to-end
   - Validate mobile auth logout fix

2. **Branch Management**
   - Complete work on `OAD-404` branch
   - Prepare for merge to master
   - Ensure all changes are documented

### Upcoming Considerations
1. **SDK Compatibility**
   - Monitor for SDK 13.x updates
   - Stay aligned with SDK release notes
   - Test new SDK features as they become available

2. **Feature Enhancements**
   - Continue adding new SDK capabilities
   - Maintain example quality as reference implementation

3. **Code Maintenance**
   - Keep dependencies up to date
   - Maintain SwiftLint compliance
   - Update documentation as needed

## Active Decisions and Considerations

### SDK Version Strategy
**Decision**: Stay current with SDK releases (13.x series)
- **Rationale**: Example app must demonstrate latest SDK capabilities
- **Impact**: May require periodic refactoring
- **Trade-off**: More maintenance vs. better reference value

### Browser IDP Integration
**Decision**: Support stateless Browser IDP flow
- **Implementation**: Added in recent commits
- **Status**: Newly integrated, needs validation
- **User Impact**: New authentication option available

### Build Configuration Approach
**Decision**: Maintain multiple configurations (Debug, Production, SDK Showcase)
- **Rationale**: Different use cases need different setups
- **Maintenance**: Requires keeping all configs in sync
- **Benefit**: Flexibility for developers

### Dependency Management
**Decision**: Use SPM as primary dependency manager
- **Previous**: Mix of manual XCFramework + SPM
- **Current**: SPM-first with XCFramework fallback
- **Benefit**: Better version management, easier updates

## Important Patterns and Preferences

### Code Organization
1. **VIPER Architecture**: Strictly maintained across all features
2. **Protocol-Based**: All component interactions through protocols
3. **Dependency Injection**: Swinject for all dependencies
4. **Error Mapping**: Centralized error transformation

### Code Style
1. **SwiftLint**: Enforced via `.swiftlint.yml`
2. **Naming Conventions**: 
   - Protocols end with `Protocol` suffix
   - Interactors handle SDK communication
   - Presenters orchestrate flow
3. **Comments**: Apache license header on all files

### Testing Approach
1. **Protocol Mocking**: Enables unit testing
2. **Integration Testing**: Full flow testing preferred
3. **Real Device Testing**: Required for biometric/push features

### Git Workflow
1. **Feature Branches**: Named for ticket/feature (e.g., `OAD-404`, `SDKIOS-1175`)
2. **Commit Messages**: Reference ticket numbers
3. **Pull Requests**: Required for master merges

## Learnings and Project Insights

### Architecture Learnings

#### 1. VIPER Benefits
- **Clean Separation**: Each layer has clear responsibility
- **Testability**: Protocol-based design enables easy mocking
- **Scalability**: New features follow established pattern
- **Challenge**: More files per feature, requires discipline

#### 2. Centralized Navigation
- **AppRouter Pattern**: Single source of truth for navigation
- **Benefit**: Consistent navigation behavior
- **Benefit**: Easy to manage complex flows
- **Learning**: Router can become large; consider splitting if needed

#### 3. Error Handling Strategy
- **Domain Mapping**: SDK errors → Domain errors → AppError
- **Benefit**: Consistent error presentation
- **Benefit**: Decoupled from SDK error structure
- **Learning**: Keep mappings updated with SDK changes

### SDK Integration Learnings

#### 1. Challenge-Response Pattern
- **SDK Design**: Most operations use challenge-response
- **Implementation**: Requires callback management
- **Learning**: State management crucial for complex flows
- **Pattern**: Interactor manages state, Presenter coordinates UI

#### 2. Configuration Management
- **Objective-C Bridge**: Still needed for configuration
- **Learning**: Keep Objective-C minimal, migrate to Swift when possible
- **Trade-off**: Bridging adds complexity but enables legacy support

#### 3. Multi-User Support
- **SDK Capability**: Supports multiple registered users
- **Implementation**: Welcome screen user selection
- **Learning**: State persistence managed by SDK, not app

### Development Workflow Learnings

#### 1. Token Server Dependency
- **Requirement**: All testing needs configured token server
- **Impact**: Can't test fully offline
- **Mitigation**: Use SDK Showcase config for demo purposes
- **Learning**: Keep test server credentials accessible

#### 2. Build Configuration Management
- **Challenge**: Multiple configs can drift
- **Solution**: Regular audits of config differences
- **Learning**: Document config-specific behavior

#### 3. Framework Updates
- **Recent**: SDK 13.x migration required changes
- **Learning**: Test thoroughly after SDK updates
- **Pattern**: Feature branch for major updates

### UI/UX Learnings

#### 1. Security Flow Clarity
- **Need**: Users must understand authentication steps
- **Implementation**: Clear messaging, loading states
- **Learning**: Over-communicate security operations

#### 2. Error Recovery
- **SDK Errors**: Can be cryptic
- **Solution**: User-friendly error mapping
- **Learning**: Provide actionable recovery steps

#### 3. Biometric Integration
- **Challenge**: Not all devices support biometrics
- **Solution**: Graceful fallback to PIN
- **Learning**: Always test on variety of devices

## Current Blockers/Risks

### Potential Risks
1. **SDK Updates**: Breaking changes in future SDK versions
2. **Token Server Access**: Dependency on external service
3. **Certificate Expiration**: Push notification certificates need renewal
4. **Dependency Updates**: Third-party framework compatibility

### Mitigation Strategies
1. **Stay Current**: Regular SDK update monitoring
2. **Documentation**: Maintain setup documentation
3. **Testing**: Comprehensive testing before releases
4. **Backup Configs**: Keep working configurations backed up

## Environment Notes

### Current State
- **Branch**: `OAD-404` (feature branch)
- **SDK Version**: 13.0.9+
- **Configuration**: Multiple (Debug/Production/SDK Showcase)
- **Dependencies**: All managed via SPM

### Development Machine Requirements
- macOS with Xcode
- OneWelcome Artifactory access
- Network access to token server
- Valid signing certificates (for device testing)

## Communication Patterns

### With Product Team
- Feature requests tied to SDK capabilities
- Prioritize reference implementation quality
- Balance completeness vs. maintainability

### With SDK Team
- Report integration issues
- Feedback on SDK usability
- Coordinate on new feature demonstrations

### With Users (Developers)
- Example app is documentation
- Code clarity over cleverness
- Comment complex flows
- Keep README updated

## Memory Bank Maintenance

### When to Update
1. **After Major Feature Additions**: Document new patterns
2. **After SDK Updates**: Update technical constraints
3. **After Architecture Changes**: Update system patterns
4. **Quarterly**: General review and cleanup

### Focus Areas
- **activeContext.md**: Update most frequently (current work)
- **progress.md**: Update after milestones
- **techContext.md**: Update after dependency changes
- **systemPatterns.md**: Update after architectural decisions
- **productContext.md**: Rarely changes (stable product vision)
- **projectbrief.md**: Rarely changes (stable requirements)
