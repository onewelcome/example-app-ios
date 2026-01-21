# Memory Bank - iOS Example App

## Purpose

This Memory Bank serves as the complete knowledge base for the iOS Example App project. Since Cline's memory resets between sessions, these files provide all necessary context to understand and work on the project effectively.

## 📚 Core Files (Must Read)

### Reading Order for New Sessions

1. **[projectbrief.md](projectbrief.md)** - START HERE
   - Project overview and requirements
   - Core functionality
   - Success criteria
   - Constraints

2. **[productContext.md](productContext.md)**
   - Why the project exists
   - Problems it solves
   - User experience goals
   - Target personas

3. **[systemPatterns.md](systemPatterns.md)**
   - VIPER architecture details
   - Design patterns used
   - Component relationships
   - Critical implementation paths

4. **[techContext.md](techContext.md)**
   - Technology stack
   - Dependencies and frameworks
   - Development setup
   - Build configurations

5. **[activeContext.md](activeContext.md)**
   - Current work focus
   - Recent changes
   - Next steps
   - Important patterns and learnings

6. **[progress.md](progress.md)**
   - What's completed
   - What's in progress
   - Known issues
   - Technical debt

## 🔄 File Hierarchy

```
projectbrief.md (Foundation)
    ├── productContext.md (Product perspective)
    ├── systemPatterns.md (Architecture)
    └── techContext.md (Technology)
         └── activeContext.md (Current state)
              └── progress.md (Status tracking)
```

## 📖 Quick Reference

### When to Read What

**Starting any task:**
- Read ALL core files (this is mandatory)
- Pay special attention to `activeContext.md` and `progress.md`

**Making architectural changes:**
- Focus on `systemPatterns.md`
- Update it after changes

**Adding new features:**
- Review `productContext.md` for context
- Check `progress.md` for related work
- Update `activeContext.md` with decisions

**Updating dependencies:**
- Review `techContext.md`
- Update version information after changes

**Bug fixing:**
- Check `progress.md` for known issues
- Review `systemPatterns.md` for architectural context

## 🎯 Project Quick Facts

**What**: iOS Example App demonstrating OneWelcome SDK integration  
**Architecture**: VIPER with Dependency Injection (Swinject)  
**Language**: Swift with Objective-C bridging  
**Current SDK**: 13.0.9+  
**Current Branch**: OAD-404  
**Status**: Mature & Actively Maintained  

## 🏗️ Architecture Summary

```
AppDelegate → AppRouter → VIPER Components → OneWelcome SDK

VIPER Layers:
- View (ViewControllers) - UI presentation
- Interactor - Business logic & SDK calls
- Presenter - Coordination & formatting
- Entity - Data models
- Router (AppRouter) - Navigation
```

## 🔑 Key Patterns

1. **Protocol-Oriented**: All components use protocols
2. **Dependency Injection**: Swinject for all dependencies
3. **Error Mapping**: SDK errors → Domain errors → AppError
4. **Challenge-Response**: SDK authentication flows
5. **Centralized Navigation**: AppRouter manages all navigation

## 📂 Project Structure

```
OneWelcomeExampleApp/
├── Assembly/          # DI configuration
├── ViewControllers/   # UI layer
├── Presenters/        # Presentation layer
├── Interactors/       # Business logic
├── Entity/            # Data models
└── ErrorMappings/     # Error transformation
```

## 🛠️ Common Tasks Reference

### Reading Code
1. Start with `AppDelegate.swift` to understand initialization
2. Follow `AppRouter.swift` for navigation flow
3. Pick a feature and trace: View → Presenter → Interactor → SDK

### Adding Features
1. Create Entity (if needed)
2. Create Interactor with protocol
3. Create Presenter with protocol
4. Create ViewController
5. Register in Assemblies
6. Add navigation in AppRouter

### Updating SDK
1. Update version in SPM
2. Test all authentication flows
3. Update error mappings if needed
4. Update `techContext.md`

## 🔄 Memory Bank Maintenance

### When to Update

**After every session** if changes were made to:
- Architecture → Update `systemPatterns.md`
- Dependencies → Update `techContext.md`
- Features → Update `progress.md`
- Current work → Update `activeContext.md`

### Update Triggers

1. **Significant feature addition** → Update all relevant files
2. **Architecture decision** → Update `systemPatterns.md`
3. **SDK upgrade** → Update `techContext.md` and `activeContext.md`
4. **User request: "update memory bank"** → Review ALL files

### Update Process

1. Review all 6 core files
2. Identify outdated information
3. Update changed sections
4. Document new learnings in `activeContext.md`
5. Update status in `progress.md`

## 🎓 Learning Resources

### Understanding VIPER
- See `systemPatterns.md` for detailed explanation
- Example flow: LoginViewController → LoginPresenter → LoginInteractor → SDK

### Understanding the SDK
- See `techContext.md` for SDK details
- Check `Interactors/` for SDK usage examples

### Understanding Navigation
- See `AppRouter.swift` implementation
- Check `systemPatterns.md` for navigation flow diagrams

## ⚠️ Important Notes

### Always Remember
1. **Read ALL files at start of EVERY session** - This is not optional
2. **Update files after significant changes**
3. **Document learnings in activeContext.md**
4. **Keep progress.md current**

### Current Project State (Last Updated: January 21, 2026)
- Branch: `OAD-404`
- SDK Version: 13.0.9+
- Recent Work: SDK update, Browser IDP support
- Next: Testing and merge to master

### Known Quirks
- Duplicate TransitionButton framework (low priority issue)
- Objective-C bridge still needed for config
- Token server required for all testing

## 🆘 Troubleshooting

**Can't build?**
- Check SPM registry configuration
- Verify Artifactory access
- Check `techContext.md` for setup steps

**SDK errors?**
- Check `ErrorMappings/` for mapping
- See error handling pattern in `systemPatterns.md`

**Navigation issues?**
- Review `AppRouter.swift`
- Check navigation flow in `systemPatterns.md`

**Architecture questions?**
- See `systemPatterns.md` for patterns
- Follow VIPER structure consistently

## 📞 Contact & Resources

- **Repository**: git@github.com:onewelcome/example-app-ios.git
- **SDK Docs**: https://docs.onegini.com
- **Artifactory**: https://repo.onewelcome.com
- **License**: Apache 2.0

---

**Remember**: This Memory Bank is your only link to previous work. Keep it accurate, complete, and up-to-date!
