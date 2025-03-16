//
//  Constants.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import SwiftUI

struct Constants {
    // Colors
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color.gray
        static let accent = Color.green
        static let warning = Color.orange
        static let error = Color.red
    }
    
    // Sizes
    struct Sizes {
        static let cornerRadius: CGFloat = 8
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let iconSize: CGFloat = 24
    }
    
    // Animation
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let defaultCurve = SwiftUI.Animation.easeInOut
    }
    
    // Menu Bar
    struct MenuBar {
        static let popoverWidth: CGFloat = 300
        static let popoverHeight: CGFloat = 400
    }
    
    // Strings
    struct Strings {
        static let appName = "PhD Study Timer"
        static let start = "Start"
        static let pause = "Pause"
        static let resume = "Resume"
        static let stop = "Stop"
        static let history = "History"
        static let settings = "Settings"
        static let quit = "Quit"
        static let editTime = "Edit"
        static let save = "Save"
        static let cancel = "Cancel"
        static let dismiss = "Dismiss"
        
        // Notifications
        static let resumeTimerReminder = "Your timer is paused. Remember to resume your study session."
        
        // History View
        static let historyTitle = "Work Session History"
        static let filterByDate = "Filter by date"
        static let from = "From:"
        static let to = "To:"
        static let apply = "Apply"
        static let reset = "Reset"
        static let noSessions = "No work sessions found"
        static let deleteAll = "Delete All Sessions"
        static let confirmDelete = "Confirm Deletion"
        static let confirmDeleteAll = "Confirm Delete All"
        static let deleteConfirmMessage = "Are you sure you want to delete this session?"
        static let deleteAllConfirmMessage = "Are you sure you want to delete all sessions? This action cannot be undone."
        static let delete = "Delete"
        
        // Session Detail View
        static let sessionDetails = "Session Details"
        static let startTime = "Start Time:"
        static let endTime = "End Time:"
        static let duration = "Duration:"
        static let notCompleted = "Not completed"
        static let spansMultipleDays = "Spans Multiple Days:"
        static let yes = "Yes"
    }
} 