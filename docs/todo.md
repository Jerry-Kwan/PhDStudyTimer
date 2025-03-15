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
  - actualWorkDuration (Double)
  - relationship to PauseRecord entities
- [x] Define PauseRecord entity with required attributes:
  - pauseTime (Date)
  - resumeTime (Date)
  - relationship to parent WorkSession
- [x] Create CoreDataManager.swift for database operations
- [x] Implement CRUD operations for WorkSession and PauseRecord

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
- [x] Store pause records in the database

### Menu Bar UI Enhancement
- [x] Implement dynamic icon changes based on session state
- [x] Add timer display in menu bar
- [x] Implement session control buttons (start, pause, resume, end)

## Phase 3: History and Statistics

### History Record Functionality
- [ ] Implement query methods in CoreDataManager for retrieving session history
- [ ] Add filtering capabilities by date ranges
- [ ] Create methods to calculate daily, weekly, and monthly statistics

### History UI Implementation
- [ ] Create HistoryView.swift for displaying work history
- [ ] Create HistoryViewModel.swift for history view logic
- [ ] Implement list/table view of past sessions
- [ ] Create SessionDetailView.swift for detailed session information
- [ ] Add date filtering controls

### Statistics and Visualization
- [ ] Implement statistical calculations for work patterns
- [ ] Add visualization components for work trends
- [ ] Create daily and weekly summary views
- [ ] Implement export functionality for session data

## Final Phase: Polishing

### UI/UX Refinement
- [ ] Ensure consistent design across all views
- [ ] Optimize UI for different screen sizes
- [ ] Add animations and transitions
- [ ] Implement keyboard shortcuts

### Performance Optimization
- [ ] Optimize CoreData queries
- [ ] Reduce memory footprint
- [ ] Ensure low CPU usage during idle periods

### Testing
- [ ] Write unit tests for core functionality
- [ ] Perform integration testing
- [ ] Conduct user testing
- [ ] Fix identified bugs and issues

### Documentation
- [ ] Document code with comments
- [ ] Create user documentation
- [ ] Prepare app for distribution
