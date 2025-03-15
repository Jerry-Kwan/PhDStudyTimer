//
//  PhDStudyTimerApp.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import SwiftUI

@main
struct PhDStudyTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
