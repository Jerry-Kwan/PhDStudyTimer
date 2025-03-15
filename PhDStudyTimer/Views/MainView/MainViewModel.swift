//
//  MainViewModel.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    private let sessionManager = SessionManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isSessionActive = false
    @Published var sessionState: TimerState = .idle
    @Published var elapsedTimeString = "00:00:00"
    @Published var todayStats: (sessions: Int, totalTime: TimeInterval) = (0, 0)
    
    init() {
        setupBindings()
        updateTodayStats()
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
        updateTodayStats()
    }
    
    func updateTodayStats() {
        // Get today's date range
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Fetch today's sessions
        let sessions = CoreDataManager.shared.fetchWorkSessions(from: startOfDay, to: endOfDay)
        
        // Calculate stats
        let totalSessions = sessions.count
        let totalTime = sessions.reduce(0) { $0 + ($1.actualWorkDuration > 0 ? $1.actualWorkDuration : 0) }
        
        // Update published property
        todayStats = (totalSessions, totalTime)
    }
    
    func formattedTodayTotalTime() -> String {
        return TimeFormatter.formatTimeIntervalShort(todayStats.totalTime)
    }
} 