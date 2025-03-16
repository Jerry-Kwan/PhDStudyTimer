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
        
        // Use elapsedTime from TimerService instead of calculating
        workSession.totalDuration = TimerService.shared.elapsedTime
        
        saveContext()
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
    
    func deleteWorkSession(_ workSession: WorkSession) {
        viewContext.delete(workSession)
        saveContext()
    }
    
    func deleteAllWorkSessions() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = WorkSession.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error deleting all work sessions: \(error)")
        }
    }
} 