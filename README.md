# Croquet Deadness Board System

A dual-app solution for digitally managing and displaying "deadness" status in American six-wicket croquet tournaments.

## Overview

The Croquet Deadness Board System consists of:
- **iOS Control App**: Tournament director control interface
- **tvOS Display App**: Large screen display for players and spectators
- **Shared Models & Services**: Common data structures and Firebase integration

## Features

### iOS Control App
- Intuitive 4x4 deadness grid interface
- Player setup and game management
- Real-time synchronization with display
- Undo/redo functionality
- Offline capability with sync when reconnected

### tvOS Display App
- Large, high-contrast deadness board display
- Real-time game information panel
- Current striker indicator
- Hoop progression tracking
- Professional tournament presentation

### Backend Services
- Firebase Realtime Database integration
- Automatic conflict resolution
- Multi-device support
- Offline-first architecture

## Project Structure

```
├── iOS-ControlApp/          # iOS control application
│   ├── Sources/             # App entry point
│   ├── Views/               # SwiftUI views
│   ├── ViewModels/          # MVVM view models
│   ├── Services/            # iOS-specific services
│   └── Resources/           # Assets and configurations
│
├── tvOS-DisplayApp/         # tvOS display application
│   ├── Sources/             # App entry point
│   ├── Views/               # SwiftUI views for TV
│   ├── ViewModels/          # TV-specific view models
│   ├── Services/            # tvOS-specific services
│   └── Resources/           # TV assets and configurations
│
├── Shared/                  # Shared code between platforms
│   ├── Models/              # Data models (Game, Player, etc.)
│   ├── Services/            # Firebase and networking services
│   ├── Extensions/          # Swift extensions
│   └── Utilities/           # Helper classes and utilities
│
├── Tests/                   # Unit and integration tests
└── docs/                    # Documentation including PRD
```

## Requirements

### Minimum System Requirements
- **iOS Device**: iPhone 12 or newer / iPad (9th gen) or newer, iOS 16.0+
- **Display System**: Apple TV 4K (3rd generation) or newer, tvOS 16.0+
- **Network**: WiFi connectivity, minimum 10 Mbps internet connection

### Development Requirements
- Xcode 15.0 or later
- Swift 5.8+
- iOS 16.0+ SDK
- tvOS 16.0+ SDK

## Getting Started

### 1. Clone the Repository
```bash
git clone [repository-url]
cd croquet_deadness_board_app
```

### 2. Install Dependencies
The project uses Swift Package Manager for dependency management. Dependencies will be automatically resolved when you open the project in Xcode.

### 3. Firebase Setup
1. Create a Firebase project at https://firebase.google.com
2. Add iOS and tvOS apps to your Firebase project
3. Download the `GoogleService-Info.plist` files
4. Add them to the respective app bundles

### 4. Build and Run
- Open the project in Xcode
- Select the target (iOS or tvOS)
- Build and run on simulator or device

## Architecture

### Data Models
- **Game**: Core game state with deadness matrix and player information
- **Player**: Individual player with ball color and hoop progression
- **GameAction**: Action history for undo/redo functionality

### Services
- **FirebaseGameService**: Real-time game synchronization
- **GameStateManager**: Local state management and persistence

### Real-time Synchronization
- Firebase Realtime Database for instant updates
- Optimistic UI updates with conflict resolution
- Offline support with automatic sync when reconnected

## Development Guidelines

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftUI for all UI components
- Implement MVVM architecture pattern
- Include unit tests for business logic

### Git Workflow
- Use feature branches for new development
- Include descriptive commit messages
- Test thoroughly before merging to main

### Testing
- Run unit tests: `swift test`
- Test on both simulator and physical devices
- Verify real-time synchronization between apps

## Deployment

### iOS App Store
1. Archive the iOS app in Xcode
2. Upload to App Store Connect
3. Submit for review

### tvOS App Store
1. Archive the tvOS app in Xcode
2. Upload to App Store Connect
3. Submit for review

## Support

For issues and feature requests, please refer to:
- [Product Requirements Document](docs/croquet-deadness-board-prd.md)
- Project issue tracker
- Development team contact

## License

[Add your license information here]