# PhD Study Timer - Development Todo List

## Phase 1: Basic Infrastructure

### Project Setup
- [x] Create a new macOS SwiftUI project in Xcode
- [x] Configure the project for menu bar app functionality
- [x] Set up the basic directory structure as outlined in the requirements
- [x] Add necessary app icons and assets

### Data Model Implementation
- [x] Create CoreData model file (PhDStudyTimer.xcdatamodeld)
- [x] Define WorkSession entity with required attributes:
  - startTime (Date)
  - endTime (Date)
  - totalDuration (Double)
- [x] Create CoreDataManager.swift for database operations
- [x] Implement CRUD operations for WorkSession

### Menu Bar Implementation
- [x] Create AppDelegate.swift to handle application lifecycle
- [x] Create MenuBarView.swift for the menu bar interface
- [x] Create MenuBarViewModel.swift for menu bar logic
- [x] Implement basic menu bar icon display
- [x] Create a simple dropdown menu structure

### Timer Service
- [x] Create TimerService.swift to handle timing functionality
- [x] Implement timer start, pause, resume, and stop functions
- [x] Add time calculation methods
- [x] Create time formatting utilities in TimeFormatter.swift

## Phase 2: Core Functionality

### Work Session Management
- [x] Create SessionManager.swift to manage work sessions
- [x] Implement methods to create new work sessions
- [x] Implement methods to end work sessions
- [x] Add functionality to calculate actual work duration

### System Monitoring
- [x] Create SystemMonitor.swift to detect system events
- [x] Implement screen lock detection
- [x] Implement screen unlock detection
- [x] Connect system events to session management

### Pause/Resume Functionality
- [x] Enhance SessionManager to handle pause/resume events
- [x] Implement manual pause/resume in the UI
- [x] Connect automatic pause on screen lock

### Menu Bar UI Enhancement
- [x] Add timer display in menu bar
- [x] Implement session control buttons (start, pause, resume, end)

## Phase 3: History

### History View Implementation
- [x] Create HistoryView.swift for displaying work session history
- [x] Create HistoryViewModel.swift to manage history data and logic
- [x] Implement session list display with scrollable interface
- [x] Add detailed information for each session (start time, end time, duration) on the list

### Date Filtering
- [x] Add DatePicker components for start and end date selection
- [x] Implement date range filtering functionality
- [x] Create filter reset option
- [x] Connect filtering to CoreData queries

### Session Management
- [x] Add delete button for individual sessions
- [x] Implement confirmation dialog for session deletion
- [x] Add "Delete All" button for batch deletion
- [x] Implement confirmation dialog for batch deletion
- [x] Ensure UI updates after deletion operations

### Menu Bar Integration
- [x] Add history view access button to menu bar dropdown
- [x] Create smooth transition between menu and history view
- [x] Implement proper window management for history view
