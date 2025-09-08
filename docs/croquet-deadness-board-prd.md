# Croquet Deadness Board System - Product Requirements Document

## Executive Summary

The Croquet Deadness Board System is a dual-app solution consisting of an iOS control application and a companion tvOS display application designed to digitally manage and display "deadness" status in American six-wicket croquet tournaments. The system replaces traditional physical deadness boards with a modern, real-time digital solution.

## Product Overview

### Vision Statement
To modernize croquet tournament management by providing an intuitive, reliable, and highly visible digital deadness tracking system that enhances gameplay experience and reduces scoring errors.

### Core Value Proposition
- **Real-time Updates**: Instant synchronization between control and display
- **Enhanced Visibility**: Large, clear display readable from across the court
- **Error Reduction**: Digital tracking with undo functionality
- **Professional Presentation**: Clean, modern interface for tournaments

## Target Users

### Primary Users
- **Tournament Directors**: Control game state, manage multiple matches
- **Players**: View current deadness status during gameplay
- **Spectators**: Follow game progression

### User Personas
1. **Tournament Director (Primary)**: Experienced croquet official managing 1-4 simultaneous games
2. **Club Official**: Volunteer managing casual club tournaments
3. **Tech-Savvy Player**: Player who also helps with tournament technology

## Product Requirements

### 1. iOS Control Application

#### Core Features
**Game Setup**
- Create new game session
- Configure player names and ball colors (Blue, Red, Black, Yellow)
- Select game format (singles/doubles)
- Set tournament information (optional)

**Deadness Management**
- 4x4 grid interface showing deadness relationships
- Tap-to-toggle deadness between any two balls
- Visual indicators for current deadness state
- Bulk clear options (clear all deadness for a ball when it runs a hoop)

**Game State Control**
- Track current striker
- Hoop progression tracking (1st through Rover)
- Score tracking integration
- Game completion detection

**Real-time Synchronization**
- Instant updates to display via Firebase/WebSocket
- Offline capability with sync when reconnected
- Multi-user support (multiple iOS devices can control same game)

#### User Interface Requirements
- **Intuitive Touch Controls**: Large, easy-to-tap buttons optimized for outdoor use
- **High Contrast Design**: Readable in bright sunlight
- **Landscape Orientation**: Primary interface orientation for stability
- **Accessibility**: VoiceOver support, appropriate contrast ratios
- **Error Prevention**: Confirmation dialogs for significant actions

#### Technical Requirements
- **Platform**: iOS 16.0+, iPadOS 16.0+
- **Development**: Swift/SwiftUI
- **Connectivity**: WiFi required, cellular backup optional
- **Storage**: Local game state with cloud synchronization
- **Performance**: <200ms response time for deadness updates

### 2. tvOS Display Application

#### Core Features
**Deadness Board Display**
- 4x4 grid showing all deadness relationships
- Color-coded player indicators matching traditional croquet colors
- Large, high-contrast text and symbols
- Automatic orientation and scaling for various display sizes

**Game Information Panel**
- Current striker indicator
- Hoop progression for all players
- Game timer (optional)
- Tournament/match information

**Visual Design**
- **Typography**: San Francisco font family, minimum 72pt for player names
- **Colors**: High contrast with customizable themes
- **Layout**: Responsive design for 16:9 and 4:3 displays
- **Animations**: Smooth transitions for state changes (≤300ms)

#### Technical Requirements
- **Platform**: tvOS 16.0+
- **Development**: Swift/SwiftUI
- **Input**: Apple TV Remote navigation (backup control)
- **Display**: Support for 1080p and 4K displays
- **Performance**: 60fps refresh rate, low latency updates

### 3. Backend Infrastructure

#### Real-time Synchronization
- **Primary**: Firebase Realtime Database
- **Fallback**: WebSocket server with Redis
- **Data Structure**: JSON-based game state with versioning
- **Conflict Resolution**: Last-write-wins with timestamp validation

#### Data Models
```
Game {
  id: String
  tournament: String?
  players: [Player]
  deadnessMatrix: [[Bool]]
  currentStriker: Int
  hoopProgression: [Int]
  timestamp: Date
  status: GameStatus
}

Player {
  name: String
  ballColor: BallColor
  hoopsRun: Int
  score: Int
}
```

#### Security & Privacy
- **Authentication**: Optional Apple Sign-In for tournaments
- **Data Privacy**: Local-first storage, opt-in cloud sync
- **Network Security**: TLS 1.3 for all communications

## Hardware Requirements

### Minimum System Requirements
**iOS Device (Control)**
- iPhone 12 or newer / iPad (9th gen) or newer
- iOS 16.0+
- WiFi connectivity
- Minimum 64GB storage

**Display System**
- Apple TV 4K (3rd generation) or newer
- tvOS 16.0+
- HDMI-compatible display (minimum 32" recommended)
- Stable WiFi network

**Network Infrastructure**
- 802.11n WiFi (2.4GHz or 5GHz)
- Minimum 10 Mbps internet connection
- Local network with multicast support

### Recommended Setup
- iPad Pro 12.9" for control (enhanced visibility and battery life)
- Apple TV 4K with 65"+ display
- Dedicated 5GHz WiFi network
- UPS backup power for critical tournaments

## User Experience Flows

### Primary Flow: Managing Deadness During Play
1. Tournament director observes play and deadness-creating shot
2. Opens iOS app showing current game state
3. Taps appropriate grid cell to mark deadness
4. Change immediately reflects on large display
5. Players and spectators see updated deadness status

### Secondary Flow: Clearing Deadness
1. Player runs hoop and clears deadness
2. Tournament director taps "Clear All" for that player's ball
3. All deadness involving that ball is removed
4. Display updates to show cleared deadness status

### Error Recovery Flow
1. Tournament director recognizes incorrect deadness marking
2. Taps "Undo" or manually corrects via grid interface
3. System reverts to previous state
4. Display updates to show corrected information

## Success Metrics

### Quantitative Metrics
- **Adoption Rate**: Number of tournaments using the system
- **Reliability**: 99.5% uptime during active games
- **Performance**: <200ms update latency iOS to tvOS
- **User Satisfaction**: 4.5+ stars on App Store

### Qualitative Metrics
- Tournament director feedback on ease of use
- Player satisfaction with visibility and accuracy
- Reduction in scoring disputes related to deadness
- Integration success with existing tournament workflows

## Technical Architecture

### System Architecture
```
iOS Control App ←→ Firebase Realtime Database ←→ tvOS Display App
       ↓                      ↓                        ↓
Local Storage        Cloud Firestore          Local Cache
```

### Development Stack
- **Frontend**: Swift 5.8+, SwiftUI, Combine
- **Backend**: Firebase (Realtime Database, Firestore, Analytics)
- **CI/CD**: Xcode Cloud, TestFlight
- **Monitoring**: Firebase Crashlytics, Performance Monitoring

### Security Considerations
- End-to-end encryption for tournament data
- Local data protection using iOS keychain
- Network traffic encryption (TLS 1.3)
- No sensitive personal data collection

## Implementation Timeline

### Phase 1: Core MVP (12 weeks)
- **Weeks 1-4**: iOS app core functionality
- **Weeks 5-8**: tvOS app development
- **Weeks 9-10**: Firebase integration and testing
- **Weeks 11-12**: Beta testing and refinement

### Phase 2: Enhancement & Polish (6 weeks)
- **Weeks 13-15**: Advanced features (undo, multi-game support)
- **Weeks 16-18**: UI/UX polish and performance optimization

### Phase 3: Launch Preparation (4 weeks)
- **Weeks 19-20**: App Store submission and review
- **Weeks 21-22**: Launch preparation and documentation

## Risk Assessment

### Technical Risks
- **Network Connectivity**: Mitigation through offline mode and local sync
- **Apple TV Reliability**: Backup AirPlay mirroring option
- **Firebase Limitations**: WebSocket fallback server

### User Adoption Risks
- **Learning Curve**: Comprehensive user documentation and training
- **Hardware Costs**: Rental program for tournaments
- **Tournament Integration**: Pilot programs with key tournament directors

## Future Considerations

### Potential Enhancements
- Multi-platform support (Android, Windows)
- Advanced tournament management features
- Score tracking and statistics
- Live streaming integration
- Voice control via Siri
- Integration with croquet association databases

### Scalability Planning
- Support for multiple simultaneous tournaments
- Cloud infrastructure scaling
- International deployment considerations
- Enterprise features for large associations

## Conclusion

The Croquet Deadness Board System represents a significant modernization opportunity for croquet tournament management. By leveraging familiar Apple ecosystem technologies and focusing on core user needs, the system can provide immediate value while establishing a foundation for future enhancements.

The dual-app approach ensures optimal user experience for both control and display functions while maintaining the reliability and professional presentation required for tournament play.