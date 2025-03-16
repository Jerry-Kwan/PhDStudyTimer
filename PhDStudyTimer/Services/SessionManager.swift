//
//  SessionManager.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import Foundation
import Combine
import UserNotifications

class SessionManager {
    static let shared = SessionManager()
    
    private let timerService = TimerService.shared
    private let systemMonitor = SystemMonitor.shared
    private let notificationManager = NotificationManager.shared
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
        
        // 清除所有恢复计时器的通知
        clearAllResumeTimerNotifications()
        
        timerService.startTimer()
    }
    
    func endSession() {
        timerService.stopTimer()
        // Explicitly update the session state and active status
        sessionState = .idle
        isSessionActive = false
        
        // 清除所有恢复计时器的通知
        clearAllResumeTimerNotifications()
    }
    
    func formattedElapsedTime() -> String {
        return timerService.formattedElapsedTime()
    }
    
    func updateMenuBarIcon() {
        // This will be implemented to update the menu bar icon based on session state
        // Will be called from AppDelegate
    }
    
    // MARK: - Manual Time Adjustment
    
    func manuallyUpdateElapsedTime(hours: Int, minutes: Int, seconds: Int) -> Bool {
        // Only allow updates when paused
        guard sessionState == .paused else { return false }
        
        return timerService.manuallyUpdateElapsedTime(hours: hours, minutes: minutes, seconds: seconds)
    }
    
    // MARK: - Notification Management
    
    /// 清除所有与恢复计时器相关的通知
    func clearAllResumeTimerNotifications() {
        // 清除所有已投递的通知
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["resumeTimerReminder"])
        
        // 清除所有待处理的通知
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["resumeTimerReminder"])
        
        // 清除所有以resumeTimerReminder开头的通知
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            let identifiersToRemove = notifications
                .filter { $0.request.identifier.hasPrefix("resumeTimerReminder") }
                .map { $0.request.identifier }
            
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiersToRemove)
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiersToRemove = requests
                .filter { $0.identifier.hasPrefix("resumeTimerReminder") }
                .map { $0.identifier }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
        }
    }
} 