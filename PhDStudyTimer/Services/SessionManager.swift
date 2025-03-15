//
//  SessionManager.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import Foundation
import Combine

class SessionManager {
    static let shared = SessionManager()
    
    private let timerService = TimerService.shared
    private let systemMonitor = SystemMonitor.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isSessionActive = false
    @Published var sessionState: TimerState = .idle
    @Published var currentElapsedTime: TimeInterval = 0
    
    private init() {
        setupBindings()
        setupSystemMonitoring()
    }
    
    private func setupBindings() {
        // Bind to timer service state
        timerService.$timerState
            .sink { [weak self] state in
                self?.sessionState = state
                self?.isSessionActive = state != .idle
            }
            .store(in: &cancellables)
        
        // Bind to timer service elapsed time
        timerService.$elapsedTime
            .sink { [weak self] time in
                self?.currentElapsedTime = time
            }
            .store(in: &cancellables)
    }
    
    private func setupSystemMonitoring() {
        // Automatically pause when screen is locked
        systemMonitor.onScreenLocked = { [weak self] in
            self?.pauseSession()
        }
        
        // Don't automatically resume when screen is unlocked
        // User must manually resume
    }
    
    // MARK: - Public Methods
    
    func startSession() {
        timerService.startTimer()
    }
    
    func pauseSession() {
        guard sessionState == .running else { return }
        timerService.pauseTimer()
    }
    
    func resumeSession() {
        guard sessionState == .paused else { return }
        timerService.startTimer()
    }
    
    func endSession() {
        timerService.stopTimer()
        // Explicitly update the session state and active status
        sessionState = .idle
        isSessionActive = false
    }
    
    func formattedElapsedTime() -> String {
        return timerService.formattedElapsedTime()
    }
    
    func updateMenuBarIcon() {
        // This will be implemented to update the menu bar icon based on session state
        // Will be called from AppDelegate
    }
} 