# Croquet Deadness Board System

A dual-app solution for digitally managing and displaying "deadness" status in American six-wicket croquet tournaments.

## Overview

The Croquet Deadness Board System consists of:
- **iOS Control App** (`CroquetControlApp/`): Tournament director control interface
- **tvOS Display App** (`CroquetDisplayApp/`): Large screen display for players and spectators

Both apps embed their own copy of shared models and Firebase services.

## Features

### iOS Control App
- Intuitive 4x4 deadness grid interface
- Player setup and game management
- Real-time synchronization with display
- Undo/redo functionality
- Hoop progression tracking

### tvOS Display App
- Large, high-contrast deadness board display
- Real-time game information panel
- Current striker indicator
- Hoop progression tracking
- Professional tournament presentation

### Backend
- Firebase Realtime Database for real-time sync between apps
- Firebase Anonymous Authentication
- Offline-first architecture with automatic reconnection

## Project Structure

```
croquet-deadness-board/
├── CroquetControlApp/                  # iOS control app (Xcode project)
│   ├── CroquetControlApp.xcodeproj
│   └── CroquetControlApp/
│       ├── ContentView.swift
│       ├── GameViewModel.swift
│       ├── DeadnessGridView.swift
│       ├── GameControlsView.swift
│       ├── GameSetupSheet.swift
│       ├── GameSetupView.swift
│       ├── HoopTrackView.swift
│       ├── Assets.xcassets/
│       ├── GoogleService-Info.plist     # (gitignored)
│       └── Shared/                     # Embedded shared code
│           ├── Models/                 # Game, Player, BallColor, etc.
│           ├── Services/               # FirebaseGameService
│           └── Extensions/             # Color+Extensions
│
├── CroquetDisplayApp/                  # tvOS display app (Xcode project)
│   ├── CroquetDisplayApp.xcodeproj
│   └── CroquetDisplayApp/
│       ├── DisplayContentView.swift
│       ├── DisplayViewModel.swift
│       ├── DeadnessBoardDisplayView.swift
│       ├── GameInfoPanelView.swift
│       ├── Assets.xcassets/
│       ├── GoogleService-Info.plist     # (gitignored)
│       └── Shared/                     # Embedded shared code
│
├── docs/                               # Documentation
│   └── croquet-deadness-board-prd.md
├── .gitignore
└── README.md
```

## Requirements

### Devices
- **iOS**: iPhone or iPad running iOS 16.0+
- **tvOS**: Apple TV 4K running tvOS 16.0+
- **Network**: WiFi connectivity for Firebase sync

### Development
- Xcode 15.0+
- Swift 5.8+

## Getting Started

### 1. Clone the Repository
```bash
git clone <repository-url>
cd croquet-deadness-board
```

### 2. Firebase Setup
1. Create a Firebase project at https://firebase.google.com
2. Add an iOS app and a tvOS app to your Firebase project
3. Download the `GoogleService-Info.plist` for each app
4. Place them in:
   - `CroquetControlApp/CroquetControlApp/GoogleService-Info.plist`
   - `CroquetDisplayApp/CroquetDisplayApp/GoogleService-Info.plist`

### 3. Build and Run
- Open `CroquetControlApp/CroquetControlApp.xcodeproj` in Xcode for the iOS app
- Open `CroquetDisplayApp/CroquetDisplayApp.xcodeproj` in Xcode for the tvOS app
- Firebase SPM dependencies will resolve automatically on first open
- Build and run on simulator or device

## Architecture

### Data Models
- **Game**: Core game state including a 4x4 deadness matrix and player information
- **Player**: Individual player with ball color and hoop progression
- **GameAction**: Action history for undo/redo functionality

### Services
- **FirebaseGameService**: Real-time game synchronization via Firebase Realtime Database

### Real-time Synchronization
- Firebase Realtime Database for instant updates between iOS and tvOS
- Optimistic UI updates with conflict resolution
- Offline support with automatic sync on reconnection

## License

[Add your license information here]
