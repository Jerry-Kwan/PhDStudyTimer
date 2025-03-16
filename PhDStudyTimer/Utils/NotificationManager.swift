//
//  NotificationManager.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/16.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
        requestNotificationPermission()
        setupNotificationCategories()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupNotificationCategories() {
        // 创建"关闭"按钮
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_ACTION",
            title: Constants.Strings.dismiss,
            options: UNNotificationActionOptions.destructive
        )
        
        // 创建通知类别，包含"关闭"按钮
        let category = UNNotificationCategory(
            identifier: "TIMER_REMINDER_CATEGORY",
            actions: [dismissAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        // 注册通知类别
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // 设置通知中心代理
        UNUserNotificationCenter.current().delegate = NotificationCenterDelegate.shared
    }
    
    func showResumeTimerNotification() {
        let content = UNMutableNotificationContent()
        content.title = Constants.Strings.appName
        content.body = Constants.Strings.resumeTimerReminder
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "TIMER_REMINDER_CATEGORY" // 设置通知类别
        
        // 设置通知的持久性
        content.interruptionLevel = .timeSensitive  // 使用时间敏感级别，提高通知优先级
        
        // 创建一个延迟触发器，让通知在显示后不会立即消失
        // 这里使用一个重复的通知，如果用户没有处理，每5分钟提醒一次
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
        
        // Create a notification request with a unique identifier (using timestamp)
        let identifier = "resumeTimerReminder-\(Date().timeIntervalSince1970)"
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // 移除之前的相同类型通知，避免重复
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["resumeTimerReminder"])
        
        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error showing notification: \(error.localizedDescription)")
            }
        }
        
        // 同时立即显示一个通知
        let immediateRequest = UNNotificationRequest(
            identifier: "resumeTimerReminder",
            content: content,
            trigger: nil // 立即显示
        )
        
        UNUserNotificationCenter.current().add(immediateRequest) { error in
            if let error = error {
                print("Error showing immediate notification: \(error.localizedDescription)")
            }
        }
    }
}

// 通知中心代理，处理通知按钮点击事件
class NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationCenterDelegate()
    
    private override init() {
        super.init()
    }
    
    // 处理通知按钮点击
    func userNotificationCenter(_ center: UNUserNotificationCenter, 
                               didReceive response: UNNotificationResponse, 
                               withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let actionIdentifier = response.actionIdentifier
        
        if actionIdentifier == "DISMISS_ACTION" {
            // 用户点击了"关闭"按钮，清除所有相关通知
            SessionManager.shared.clearAllResumeTimerNotifications()
        }
        
        completionHandler()
    }
    
    // 允许在应用前台时也显示通知
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .sound, .badge])
    }
} 