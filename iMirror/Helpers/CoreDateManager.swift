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
  
  // Additional methods for CRUD operations will be added here
}
