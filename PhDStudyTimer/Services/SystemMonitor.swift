//
//  SystemMonitor.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import Foundation
import Cocoa

class SystemMonitor {
    static let shared = SystemMonitor()
    
    // Closure to be called when screen is locked
    var onScreenLocked: (() -> Void)?
    
    // Closure to be called when screen is unlocked
    var onScreenUnlocked: (() -> Void)?
    
    private init() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        // Register for screen lock notification
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(screenLocked),
            name: NSNotification.Name("com.apple.screenIsLocked"),
            object: nil
        )
        
        // Register for screen unlock notification
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(screenUnlocked),
            name: NSNotification.Name("com.apple.screenIsUnlocked"),
            object: nil
        )
        
        // Register for sleep notification
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(systemWillSleep),
            name: NSWorkspace.willSleepNotification,
            object: nil
        )
        
        // Register for wake notification
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(systemDidWake),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
    }
    
    @objc private func screenLocked() {
        onScreenLocked?()
    }
    
    @objc private func screenUnlocked() {
        onScreenUnlocked?()
        
        // Check if timer is paused and show notification
        checkTimerStateAndNotify()
    }
    
    @objc private func systemWillSleep() {
        // Treat sleep as screen lock
        onScreenLocked?()
    }
    
    @objc private func systemDidWake() {
        // Don't automatically treat wake as unlock
        // The screen will still be locked after wake, and screenUnlocked will be called when user unlocks
        
        // However, on some systems, the wake notification might be received without a subsequent unlock
        // So we also check timer state here
        checkTimerStateAndNotify()
    }
    
    private func checkTimerStateAndNotify() {
        // Check if timer is in paused state
        if SessionManager.shared.sessionState == .paused {
            // Show notification to remind user to resume timer
            NotificationManager.shared.showResumeTimerNotification()
        }
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
} 