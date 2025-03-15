//
//  AppDelegate.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import Cocoa
import SwiftUI
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    private let sessionManager = SessionManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var menuBarViewModel = MenuBarViewModel()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        setupBindings()
    }
    
    private func setupMenuBar() {
        // Create the status item in the menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            // Initial state - sleeping icon with "12H" text
            button.image = NSImage(systemSymbolName: "bed.double.fill", accessibilityDescription: "Sleep")
            button.title = " 12H"
            button.imagePosition = .imageLeading
            button.action = #selector(togglePopover)
            button.target = self
        }
        
        // Create the popover for the menu interface
        let contentView = MenuBarView()
        let popover = NSPopover()
        popover.contentSize = NSSize(width: Constants.MenuBar.popoverWidth, height: Constants.MenuBar.popoverHeight)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
    }
    
    private func setupBindings() {
        // Update menu bar icon and title based on session state
        menuBarViewModel.$sessionState
            .sink { [weak self] state in
                self?.updateMenuBarIcon(state: state)
            }
            .store(in: &cancellables)
        
        menuBarViewModel.$elapsedTimeString
            .sink { [weak self] timeString in
                self?.updateMenuBarTitle(timeString: timeString)
            }
            .store(in: &cancellables)
    }
    
    private func updateMenuBarIcon(state: TimerState) {
        guard let button = statusItem?.button else { return }
        
        let iconName: String
        
        switch state {
        case .running:
            iconName = "person.fill"
        case .paused:
            iconName = "pause.fill"
        case .idle:
            iconName = "bed.double.fill"
        }
        
        button.image = NSImage(systemSymbolName: iconName, accessibilityDescription: nil)
    }
    
    private func updateMenuBarTitle(timeString: String) {
        guard let button = statusItem?.button else { return }
        
        if menuBarViewModel.isSessionActive {
            button.title = " \(timeString)"
        } else {
            button.title = " 12H"
        }
    }
    
    @objc func togglePopover() {
        if let button = statusItem?.button {
            if let popover = self.popover {
                if popover.isShown {
                    popover.performClose(nil)
                } else {
                    popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                }
            }
        }
    }
} 