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
    
    func getMenuBarTitle() -> String {
        if isSessionActive {
            return elapsedTimeString
        } else {
            return "12H"
        }
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
} 