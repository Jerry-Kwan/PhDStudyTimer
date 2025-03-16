//
//  HistoryViewModel.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/16.
//

import Foundation
import SwiftUI
import Combine

class HistoryViewModel: ObservableObject {
    private let coreDataManager = CoreDataManager.shared
    
    @Published var workSessions: [WorkSession] = []
    @Published var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @Published var endDate: Date = Date()
    @Published var isShowingDeleteConfirmation = false
    @Published var sessionToDelete: WorkSession?
    @Published var isShowingDeleteAllConfirmation = false
    
    init() {
        fetchSessions()
    }
    
    func fetchSessions() {
        workSessions = coreDataManager.fetchWorkSessions(from: startDate, to: endDate)
    }
    
    func resetDateFilter() {
        startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        endDate = Date()
        fetchSessions()
    }
    
    func deleteSession(_ session: WorkSession) {
        coreDataManager.deleteWorkSession(session)
        fetchSessions()
    }
    
    func deleteAllSessions() {
        coreDataManager.deleteAllWorkSessions()
        fetchSessions()
    }
    
    func confirmDeleteSession(_ session: WorkSession) {
        sessionToDelete = session
        isShowingDeleteConfirmation = true
    }
    
    func confirmDeleteAllSessions() {
        isShowingDeleteAllConfirmation = true
    }
} 