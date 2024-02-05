//
//  CoreDateManager.swift
//  iMirror
//
//  Created by Christopher Endress on 1/28/24.
//

import Foundation
import CoreData

class CoreDataManager {
  static let shared = CoreDataManager()
  
  private init() {}
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "iMirror")
    container.loadPersistentStores(completionHandler: { storeDescription, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  var viewContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  func saveContext () {
    let context = viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func saveJournalEntry(mood: String, emotions: [String], title: String, note: String, currentDate: Date, currentTime: Date) {
    let journalEntry = JournalEntry(context: viewContext)
    journalEntry.mood = mood
    // Must typecast emotion as NSObject if it is a 'transformable' data type
    journalEntry.emotion = emotions as NSObject
    journalEntry.title = title
    journalEntry.note = note
    journalEntry.currentDate = currentDate
    journalEntry.currentTime = currentTime
    
    saveContext()
  }
  
  func fetchJournalEntries() -> [JournalEntry] {
    let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
    
    // Add a sort descriptor for currentDate
    let sortDescriptor = NSSortDescriptor(key: "currentDate", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    do {
      let entries = try viewContext.fetch(fetchRequest)
      return entries
    } catch {
      print("Error fetching journal entries: \(error)")
      return []
    }
  }
}
