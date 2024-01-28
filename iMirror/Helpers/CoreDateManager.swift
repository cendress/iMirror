//
//  CoreDateManager.swift
//  iMirror
//
//  Created by Christopher Endress on 1/28/24.
//

import UIKit
import CoreData

class CoreDataManager {
  
  static let shared = CoreDataManager()
  
  private let persistentContainer: NSPersistentContainer
  
  private init() {
    persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
  }
  
  // Update this when saving more objects
  func saveJournalEntry(mood: String, emotions: [String]) {
    let context = persistentContainer.viewContext
    let journalEntry = JournalEntry(context: context)
    journalEntry.mood = mood
    journalEntry.emotion = emotions as NSObject
    
    do {
      try context.save()
    } catch {
      print("Failed to save journal entry: \(error)")
    }
  }
  
  func fetchJournalEntries() -> [JournalEntry] {
    let context = persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
    
    do {
      return try context.fetch(fetchRequest)
    } catch {
      print("Failed to fetch journal entries: \(error)")
      return []
    }
  }
}
