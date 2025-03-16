//
//  TimerService.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import Foundation
import Combine

enum TimerState {
    case idle
    case running
    case paused
}

class TimerService {
    static let shared = TimerService()
    
    private init() {
        setupTimer()
    }
    
    // MARK: - Properties
    
    private var timer: Timer?
    private var startTime: Date?
    private var currentWorkSession: WorkSession?
    private var currentPauseRecord: PauseRecord?
    
    @Published var timerState: TimerState = .idle
    @Published var elapsedTime: TimeInterval = 0
    
    // MARK: - Timer Control Methods
    
    func startTimer() {
        guard timerState != .running else { return }
        
        if timerState == .idle {
            // Start a new session
            startTime = Date()
            elapsedTime = 0
            
            // Create a new work session in CoreData
            currentWorkSession = CoreDataManager.shared.createWorkSession()
        } else if timerState == .paused {
            // Resume from pause
            
            // Resume the current pause record if exists
            if let pauseRecord = currentPauseRecord {
                CoreDataManager.shared.resumePauseRecord(pauseRecord)
                currentPauseRecord = nil
            }
        }
        
        timerState = .running
        setupTimer()
    }
    
    func pauseTimer() {
        guard timerState == .running else { return }
        
        timerState = .paused
        timer?.invalidate()
        
        // Create a pause record in CoreData
        if let workSession = currentWorkSession {
            currentPauseRecord = CoreDataManager.shared.createPauseRecord(for: workSession)
        }
    }
    
    func stopTimer() {
        guard timerState != .idle else { return }
        
        timer?.invalidate()
        timer = nil
        
        // End the current work session in CoreData
        if let workSession = currentWorkSession {
            CoreDataManager.shared.endWorkSession(workSession)
            currentWorkSession = nil
        }
        
        // Reset state
        startTime = nil
        elapsedTime = 0
        timerState = .idle
        currentPauseRecord = nil
    }
    
    // MARK: - Private Methods
    
    private func setupTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    private func updateElapsedTime() {
        guard timerState == .running else { return }
        
        // Simply increment elapsed time by 1 second
        elapsedTime += 1.0
    }
    
    // MARK: - Utility Methods
    
    func formattedElapsedTime() -> String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // MARK: - Manual Time Adjustment
    
    func manuallyUpdateElapsedTime(hours: Int, minutes: Int, seconds: Int) -> Bool {
        // Only allow manual updates when paused
        guard timerState == .paused else { return false }
        
        // Calculate the new elapsed time in seconds
        let newElapsedTime = TimeInterval(hours * 3600 + minutes * 60 + seconds)
        
        // Directly update the elapsed time
        elapsedTime = newElapsedTime
        return true
    }
} 