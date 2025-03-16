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
            if viewModel.isEditingTime {
                timeEditView
            } else {
                HStack {
                    Image(systemName: viewModel.getMenuBarIcon())
                        .font(.system(size: 24))
                    
                    Text(viewModel.elapsedTimeString)
                        .font(.system(size: 24, weight: .medium, design: .monospaced))
                }
                .padding(.vertical, 8)
            }
            
            // Control buttons
            HStack(spacing: 16) {
                if viewModel.isEditingTime {
                    // Save and Cancel buttons for time editing
                    Button(action: viewModel.saveTimeEditing) {
                        Label(Constants.Strings.save, systemImage: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: viewModel.cancelTimeEditing) {
                        Label(Constants.Strings.cancel, systemImage: "xmark")
                    }
                    .buttonStyle(.bordered)
                } else if viewModel.sessionState == .idle {
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
                    
                    // Edit time button
                    Button(action: viewModel.startTimeEditing) {
                        Label(Constants.Strings.editTime, systemImage: "pencil")
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
                    viewModel.showHistoryView = true
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
        .sheet(isPresented: $viewModel.showHistoryView) {
            HistoryView()
        }
    }
    
    // Time editing view
    private var timeEditView: some View {
        VStack(spacing: 8) {
            Text("Edit Session Duration")
                .font(.headline)
            
            HStack {
                // Hours
                VStack {
                    Text("Hours")
                        .font(.caption)
                    
                    Stepper(value: $viewModel.editedHours, in: 0...99) {
                        Text("\(viewModel.editedHours)")
                            .font(.system(.title2, design: .monospaced))
                            .frame(width: 40)
                    }
                }
                
                Text(":")
                    .font(.title2)
                    .padding(.horizontal, -4)
                
                // Minutes
                VStack {
                    Text("Min")
                        .font(.caption)
                    
                    Stepper(value: $viewModel.editedMinutes, in: 0...59) {
                        Text("\(viewModel.editedMinutes, specifier: "%02d")")
                            .font(.system(.title2, design: .monospaced))
                            .frame(width: 40)
                    }
                }
                
                Text(":")
                    .font(.title2)
                    .padding(.horizontal, -4)
                
                // Seconds
                VStack {
                    Text("Sec")
                        .font(.caption)
                    
                    Stepper(value: $viewModel.editedSeconds, in: 0...59) {
                        Text("\(viewModel.editedSeconds, specifier: "%02d")")
                            .font(.system(.title2, design: .monospaced))
                            .frame(width: 40)
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .padding(.vertical, 8)
    }
} 