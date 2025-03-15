//
//  MainView.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text(Constants.Strings.appName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            // Timer display
            VStack {
                Image(systemName: viewModel.sessionState == .running ? "person.fill" : 
                                 viewModel.sessionState == .paused ? "pause.fill" : "bed.double.fill")
                    .font(.system(size: 48))
                    .foregroundColor(viewModel.sessionState == .running ? .green : 
                                     viewModel.sessionState == .paused ? .orange : .gray)
                    .padding(.bottom, 8)
                
                Text(viewModel.elapsedTimeString)
                    .font(.system(size: 48, weight: .medium, design: .monospaced))
                    .padding(.bottom, 16)
                
                // Session state text
                Text(viewModel.sessionState == .running ? "Working" : 
                     viewModel.sessionState == .paused ? "Paused" : "Not Working")
                    .font(.headline)
                    .foregroundColor(viewModel.sessionState == .running ? .green : 
                                     viewModel.sessionState == .paused ? .orange : .gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.windowBackgroundColor).opacity(0.3))
            .cornerRadius(Constants.Sizes.cornerRadius)
            
            Spacer()
            
            // Control buttons
            HStack(spacing: 20) {
                if viewModel.sessionState == .idle {
                    // Start button
                    Button(action: viewModel.startSession) {
                        VStack {
                            Image(systemName: "play.fill")
                                .font(.system(size: 24))
                            Text(Constants.Strings.start)
                        }
                        .frame(width: 80, height: 80)
                    }
                    .buttonStyle(.borderedProminent)
                } else if viewModel.sessionState == .running {
                    // Pause button
                    Button(action: viewModel.pauseSession) {
                        VStack {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 24))
                            Text(Constants.Strings.pause)
                        }
                        .frame(width: 80, height: 80)
                    }
                    .buttonStyle(.bordered)
                    
                    // Stop button
                    Button(action: viewModel.endSession) {
                        VStack {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 24))
                            Text(Constants.Strings.stop)
                        }
                        .frame(width: 80, height: 80)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                } else if viewModel.sessionState == .paused {
                    // Resume button
                    Button(action: viewModel.resumeSession) {
                        VStack {
                            Image(systemName: "play.fill")
                                .font(.system(size: 24))
                            Text(Constants.Strings.resume)
                        }
                        .frame(width: 80, height: 80)
                    }
                    .buttonStyle(.bordered)
                    
                    // Stop button
                    Button(action: viewModel.endSession) {
                        VStack {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 24))
                            Text(Constants.Strings.stop)
                        }
                        .frame(width: 80, height: 80)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
            
            Spacer()
            
            // Today's stats
            VStack(alignment: .leading, spacing: 8) {
                Text("Today's Progress")
                    .font(.headline)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Sessions")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(viewModel.todayStats.sessions)")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Total Time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(viewModel.formattedTodayTotalTime())
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.windowBackgroundColor).opacity(0.3))
            .cornerRadius(Constants.Sizes.cornerRadius)
        }
        .padding()
        .frame(width: 350, height: 500)
    }
} 