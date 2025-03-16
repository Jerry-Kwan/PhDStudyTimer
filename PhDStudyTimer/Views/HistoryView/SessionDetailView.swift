//
//  SessionDetailView.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/16.
//

import SwiftUI

struct SessionDetailView: View {
    let session: WorkSession
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text(Constants.Strings.sessionDetails)
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
            
            Divider()
            
            // Session details
            Group {
                detailRow(title: Constants.Strings.startTime, value: formatDateTime(session.startTime))
                
                if let endTime = session.endTime {
                    detailRow(title: Constants.Strings.endTime, value: formatDateTime(endTime))
                } else {
                    detailRow(title: Constants.Strings.endTime, value: Constants.Strings.notCompleted)
                }
                
                detailRow(title: Constants.Strings.duration, value: formatDuration(session.totalDuration))
                
                if let startDate = session.startTime, let endDate = session.endTime {
                    let calendar = Calendar.current
                    if !calendar.isDate(startDate, inSameDayAs: endDate) {
                        detailRow(title: Constants.Strings.spansMultipleDays, value: Constants.Strings.yes)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 400, height: 300)
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
        }
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

#Preview {
    SessionDetailView(session: WorkSession())
} 