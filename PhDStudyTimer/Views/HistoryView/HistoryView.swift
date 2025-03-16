//
//  HistoryView.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/16.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSession: WorkSession?
    @State private var isShowingSessionDetail = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(Constants.Strings.historyTitle)
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            // Date filter
            VStack(spacing: 8) {
                HStack {
                    Text(Constants.Strings.filterByDate)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button(action: viewModel.resetDateFilter) {
                        Text(Constants.Strings.reset)
                            .font(.subheadline)
                    }
                    .buttonStyle(.borderless)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(Constants.Strings.from)
                            .font(.caption)
                        
                        DatePicker("", selection: $viewModel.startDate, displayedComponents: [.date])
                            .labelsHidden()
                    }
                    
                    VStack(alignment: .leading) {
                        Text(Constants.Strings.to)
                            .font(.caption)
                        
                        DatePicker("", selection: $viewModel.endDate, displayedComponents: [.date])
                            .labelsHidden()
                    }
                    
                    Button(action: viewModel.fetchSessions) {
                        Text(Constants.Strings.apply)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            Divider()
            
            // Sessions list
            if viewModel.workSessions.isEmpty {
                VStack {
                    Spacer()
                    Text(Constants.Strings.noSessions)
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                List {
                    ForEach(viewModel.workSessions, id: \.self) { session in
                        SessionRowView(session: session, onDelete: {
                            viewModel.confirmDeleteSession(session)
                        })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedSession = session
                            isShowingSessionDetail = true
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            Divider()
            
            // Delete all button
            if !viewModel.workSessions.isEmpty {
                Button(action: viewModel.confirmDeleteAllSessions) {
                    Label(Constants.Strings.deleteAll, systemImage: "trash")
                        .foregroundColor(.red)
                }
                .padding()
            }
        }
        .frame(width: 500, height: 600)
        .alert(Constants.Strings.confirmDelete, isPresented: $viewModel.isShowingDeleteConfirmation) {
            Button(Constants.Strings.cancel, role: .cancel) { }
            Button(Constants.Strings.delete, role: .destructive) {
                if let session = viewModel.sessionToDelete {
                    viewModel.deleteSession(session)
                }
            }
        } message: {
            Text(Constants.Strings.deleteConfirmMessage)
        }
        .alert(Constants.Strings.confirmDeleteAll, isPresented: $viewModel.isShowingDeleteAllConfirmation) {
            Button(Constants.Strings.cancel, role: .cancel) { }
            Button(Constants.Strings.deleteAll, role: .destructive) {
                viewModel.deleteAllSessions()
            }
        } message: {
            Text(Constants.Strings.deleteAllConfirmMessage)
        }
        .onChange(of: viewModel.startDate) { _ in
            if viewModel.startDate > viewModel.endDate {
                viewModel.endDate = viewModel.startDate
            }
        }
        .sheet(isPresented: $isShowingSessionDetail) {
            if let session = selectedSession {
                SessionDetailView(session: session)
            }
        }
    }
}

struct SessionRowView: View {
    let session: WorkSession
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Start: \(formatDate(session.startTime))")
                    .font(.subheadline)
                
                if let endTime = session.endTime {
                    Text("End: \(formatDate(endTime))")
                        .font(.subheadline)
                } else {
                    Text("End: Not completed")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Text("Duration: \(formatDuration(session.totalDuration))")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: Double) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}

#Preview {
    HistoryView()
} 
