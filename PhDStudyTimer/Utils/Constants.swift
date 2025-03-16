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
    }
} 