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
    @State private var hoveredSessionID: ObjectIdentifier?
    @FocusState private var focusedField: FocusField?
    
    private enum FocusField {
        case startDate, endDate, none
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(Constants.Strings.historyTitle)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .contentShape(Circle())
                .help("Close")
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 8)
            
            // Date filter section
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(Constants.Strings.filterByDate)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Button(action: viewModel.resetDateFilter) {
                            Text(Constants.Strings.reset)
                                .font(.subheadline)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .tint(.secondary)
                    }
                    
                    HStack(spacing: 8) {
                        Text(Constants.Strings.from)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        DatePicker("", selection: $viewModel.startDate, displayedComponents: [.date])
                            .labelsHidden()
                            .datePickerStyle(.field)
                            .frame(width: 120)
                            .focused($focusedField, equals: .startDate)
                    }
                    
                    HStack(spacing: 8) {
                        Text(Constants.Strings.to)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        DatePicker("", selection: $viewModel.endDate, displayedComponents: [.date])
                            .labelsHidden()
                            .datePickerStyle(.field)
                            .frame(width: 120)
                            .focused($focusedField, equals: .endDate)
                    }
                    
                    Button(action: {
                        viewModel.fetchSessions()
                        focusedField = .none
                    }) {
                        Text(Constants.Strings.apply)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                }
                .padding(Constants.Sizes.padding)
            }
            .padding(.horizontal)
            
            // Sessions list
            VStack {
                if viewModel.workSessions.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "clock.badge.exclamationmark")
                            .font(.system(size: 36))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                        
                        Text(Constants.Strings.noSessions)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.workSessions, id: \.self) { session in
                                sessionRowBuilder(session: session)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Divider()
                    
                    // Delete all button
                    HStack {
                        Spacer()
                        
                        Button(action: viewModel.confirmDeleteAllSessions) {
                            Label(Constants.Strings.deleteAll, systemImage: "trash")
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(.borderless)
                        .padding(.vertical, 8)
                        
                        Spacer()
                    }
                    .background(Color(.windowBackgroundColor).opacity(0.5))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 550, height: 600)
        .background(Color(.windowBackgroundColor))
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focusedField = .none
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = .none
        }
    }
    
    @ViewBuilder
    private func sessionRowBuilder(session: WorkSession) -> some View {
        let isHovered = hoveredSessionID == ObjectIdentifier(session)
        
        SessionRowView(
            session: session,
            isHovered: isHovered,
            onDelete: {
                viewModel.confirmDeleteSession(session)
            }
        )
        .contentShape(Rectangle())
        .onHover { isHovered in
            hoveredSessionID = isHovered ? ObjectIdentifier(session) : nil
        }
        .animation(.easeInOut(duration: 0.2), value: isHovered)
    }
}

struct SessionRowView: View {
    let session: WorkSession
    let isHovered: Bool
    let onDelete: () -> Void
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 8) {
                // Header with date
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.title3)
                        .foregroundStyle(Constants.Colors.primary)
                    
                    Text(formatDate(session.startTime))
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(4)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.borderless)
                    .opacity(isHovered ? 1 : 0)
                }
                
                Divider()
                
                // Start time
                HStack(spacing: 8) {
                    Image(systemName: "play.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                        .frame(width: 16)
                    
                    Text(Constants.Strings.startTime)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .frame(width: 80, alignment: .leading)
                    
                    Text(formatDateTime(session.startTime))
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundStyle(.primary)
                }
                
                // End time
                HStack(spacing: 8) {
                    Image(systemName: "stop.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .frame(width: 16)
                    
                    Text(Constants.Strings.endTime)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .frame(width: 80, alignment: .leading)
                    
                    if let endTime = session.endTime {
                        Text(formatDateTime(endTime))
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundStyle(.primary)
                    } else {
                        Text(Constants.Strings.notCompleted)
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .italic()
                    }
                }
                
                // Duration
                HStack(spacing: 8) {
                    Image(systemName: "hourglass.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(Constants.Colors.primary)
                        .frame(width: 16)
                    
                    Text(Constants.Strings.duration)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .frame(width: 80, alignment: .leading)
                    
                    Text(formatDuration(session.totalDuration))
                        .font(.system(.subheadline, design: .monospaced))
                        .fontWeight(.medium)
                        .foregroundStyle(Constants.Colors.primary)
                }
            }
            .padding(10)
        }
        .groupBoxStyle(CustomGroupBoxStyle(isHovered: isHovered))
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func formatDateTime(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: Double) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct CustomGroupBoxStyle: GroupBoxStyle {
    var isHovered: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.content
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Constants.Sizes.cornerRadius)
                .fill(Color(.controlBackgroundColor))
                .shadow(color: Color.black.opacity(isHovered ? 0.1 : 0.05), radius: isHovered ? 3 : 1, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.Sizes.cornerRadius)
                .strokeBorder(isHovered ? Constants.Colors.primary.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: isHovered ? 1.5 : 0.5)
        )
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

#Preview {
    HistoryView()
} 
