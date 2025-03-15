//
//  CoreDataManager.swift
//  PhDStudyTimer
//
//  Created by Jerry Kwan on 2025/3/15.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PhDStudyTimer")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - WorkSession CRUD Operations
    
    func createWorkSession() -> WorkSession {
        let workSession = WorkSession(context: viewContext)
        workSession.startTime = Date()
        saveContext()
        return workSession
    }
    
    func endWorkSession(_ workSession: WorkSession) {
        workSession.endTime = Date()
        
        // Calculate total duration
        if let startTime = workSession.startTime, let endTime = workSession.endTime {
            let totalDuration = endTime.timeIntervalSince(startTime)
            workSession.totalDuration = totalDuration
            
            // Calculate actual work duration (total - pauses)
            let pauseDuration = calculatePauseDuration(for: workSession)
            workSession.actualWorkDuration = totalDuration - pauseDuration
        }
        
        saveContext()
    }
    
    func calculatePauseDuration(for workSession: WorkSession) -> TimeInterval {
        guard let pauseRecords = workSession.pauseRecords as? Set<PauseRecord> else {
            return 0
        }
        
        var totalPauseDuration: TimeInterval = 0
        
        for pauseRecord in pauseRecords {
            if let pauseTime = pauseRecord.pauseTime, let resumeTime = pauseRecord.resumeTime {
                totalPauseDuration += resumeTime.timeIntervalSince(pauseTime)
            } else if let pauseTime = pauseRecord.pauseTime {
                // If there's no resume time, calculate up to current time
                totalPauseDuration += Date().timeIntervalSince(pauseTime)
            }
        }
        
        return totalPauseDuration
    }
    
    func fetchAllWorkSessions() -> [WorkSession] {
        let request: NSFetchRequest<WorkSession> = WorkSession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkSession.startTime, ascending: false)]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching work sessions: \(error)")
            return []
        }
    }
    
    func fetchWorkSessions(from startDate: Date, to endDate: Date) -> [WorkSession] {
        let request: NSFetchRequest<WorkSession> = WorkSession.fetchRequest()
        request.predicate = NSPredicate(format: "startTime >= %@ AND startTime <= %@", startDate as NSDate, endDate as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkSession.startTime, ascending: false)]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching work sessions: \(error)")
            return []
        }
    }
    
    // MARK: - PauseRecord CRUD Operations
    
    func createPauseRecord(for workSession: WorkSession) -> PauseRecord {
        let pauseRecord = PauseRecord(context: viewContext)
        pauseRecord.pauseTime = Date()
        pauseRecord.workSession = workSession
        saveContext()
        return pauseRecord
    }
    
    func resumePauseRecord(_ pauseRecord: PauseRecord) {
        pauseRecord.resumeTime = Date()
        saveContext()
    }
} 