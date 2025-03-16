//
//  MenuBarViewModel.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import Foundation
import Combine
import SwiftUI

class MenuBarViewModel: ObservableObject {
    private let sessionManager = SessionManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isSessionActive = false
    @Published var sessionState: TimerState = .idle
    @Published var elapsedTimeString = "00:00:00"
    
    // Properties for manual time editing
    @Published var isEditingTime = false
    @Published var editedHours = 0
    @Published var editedMinutes = 0
    @Published var editedSeconds = 0
    
    // Property for showing history view
    @Published var showHistoryView = false
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // Bind to session manager state
        sessionManager.$isSessionActive
            .assign(to: \.isSessionActive, on: self)
            .store(in: &cancellables)
        
        sessionManager.$sessionState
            .assign(to: \.sessionState, on: self)
            .store(in: &cancellables)
        
        // Update elapsed time string every second when active
        sessionManager.$currentElapsedTime
            .map { TimeFormatter.formatTimeInterval($0) }
            .assign(to: \.elapsedTimeString, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    func startSession() {
        sessionManager.startSession()
    }
    
    func pauseSession() {
        sessionManager.pauseSession()
    }
    
    func resumeSession() {
        sessionManager.resumeSession()
    }
    
    func endSession() {
        sessionManager.endSession()
    }
    
    func getMenuBarIcon() -> String {
        switch sessionState {
        case .running:
            return "person.fill"
        case .paused:
            return "pause.fill"
        case .idle:
            return "bed.double.fill"
        }
    }
    
    // MARK: - Time Editing Methods
    
    func startTimeEditing() {
        guard sessionState == .paused else { return }
        
        // Parse current time string to set initial values
        let components = elapsedTimeString.split(separator: ":")
        if components.count == 3,
           let hours = Int(components[0]),
           let minutes = Int(components[1]),
           let seconds = Int(components[2]) {
            editedHours = hours
            editedMinutes = minutes
            editedSeconds = seconds
        }
        
        isEditingTime = true
    }
    
    func cancelTimeEditing() {
        isEditingTime = false
    }
    
    func saveTimeEditing() {
        // Validate input values
        let validMinutes = min(max(editedMinutes, 0), 59)
        let validSeconds = min(max(editedSeconds, 0), 59)
        
        // Update the session time
        if sessionManager.manuallyUpdateElapsedTime(
            hours: editedHours,
            minutes: validMinutes,
            seconds: validSeconds
        ) {
            // Time was successfully updated
            isEditingTime = false
        }
    }
} 