//
//  SettingsViewModel.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import CoreData
import SwiftUI

class SettingsViewModel: ObservableObject {
  @Published var isNotificationsEnabled = true
  @Published var isDarkModeEnabled = false
  @Published var showAlertForNotifications = false
  @Published var showDeleteConfirmation = false
  var viewContext: NSManagedObjectContext?

   func setContext(_ context: NSManagedObjectContext) {
     self.viewContext = context
   }
  
  func toggleNotification(_ isEnabled: Bool) {
    if !isEnabled {
      showAlertForNotifications = true
    }
  }
  
  func deleteAllJournalEntries() {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "JournalEntry")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try viewContext?.execute(deleteRequest)
      try viewContext?.save()
    } catch {
      print("Error deleting data: \(error)")
    }
  }
}
