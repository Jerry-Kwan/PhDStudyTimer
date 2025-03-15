//
//  MenuBarView.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import SwiftUI

struct MenuBarView: View {
    @StateObject private var viewModel = MenuBarViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            Text(Constants.Strings.appName)
                .font(.headline)
                .padding(.top, 8)
            
            Divider()
            
            // Timer display
            HStack {
                Image(systemName: viewModel.getMenuBarIcon())
                    .font(.system(size: 24))
                
                Text(viewModel.elapsedTimeString)
                    .font(.system(size: 24, weight: .medium, design: .monospaced))
            }
            .padding(.vertical, 8)
            
            // Control buttons
            HStack(spacing: 16) {
                if viewModel.sessionState == .idle {
                    // Start button
                    Button(action: viewModel.startSession) {
                        Label(Constants.Strings.start, systemImage: "play.fill")
                    }
                    .buttonStyle(.borderedProminent)
                } else if viewModel.sessionState == .running {
                    // Pause button
                    Button(action: viewModel.pauseSession) {
                        Label(Constants.Strings.pause, systemImage: "pause.fill")
                    }
                    .buttonStyle(.bordered)
                    
                    // Stop button
                    Button(action: viewModel.endSession) {
                        Label(Constants.Strings.stop, systemImage: "stop.fill")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                } else if viewModel.sessionState == .paused {
                    // Resume button
                    Button(action: viewModel.resumeSession) {
                        Label(Constants.Strings.resume, systemImage: "play.fill")
                    }
                    .buttonStyle(.bordered)
                    
                    // Stop button
                    Button(action: viewModel.endSession) {
                        Label(Constants.Strings.stop, systemImage: "stop.fill")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
            .padding(.vertical, 8)
            
            Divider()
            
            // Menu options
            VStack(alignment: .leading, spacing: 8) {
                Button(action: {
                    // Open history view
                }) {
                    Label(Constants.Strings.history, systemImage: "clock")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    // Open settings
                }) {
                    Label(Constants.Strings.settings, systemImage: "gear")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                
                Divider()
                
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Label(Constants.Strings.quit, systemImage: "power")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 8)
        }
        .padding(.horizontal, 16)
        .frame(width: Constants.MenuBar.popoverWidth)
    }
} 