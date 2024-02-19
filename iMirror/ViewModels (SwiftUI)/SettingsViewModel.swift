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
  @Published var showAlertForNotifications = false
  @Published var showDeleteConfirmation = false
  var viewContext: NSManagedObjectContext?
  
  func setContext(_ context: NSManagedObjectContext) {
    self.viewContext = context
  }
  
  //MARK: - Notification methods
  
  func toggleNotification(_ isEnabled: Bool) {
    if isEnabled {
      // Request notification permissions
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
        DispatchQueue.main.async {
          if granted {
            // Permission granted
            self?.isNotificationsEnabled = true
          } else {
            // Permission denied
            self?.isNotificationsEnabled = false
          }
        }
      }
    } else {
      isNotificationsEnabled = false
      UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
      UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
  }
  
  func checkNotificationPermissionAndUpdateToggle() {
    UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
      DispatchQueue.main.async {
        switch settings.authorizationStatus {
        case .authorized, .provisional:
          self?.isNotificationsEnabled = true
        default:
          self?.isNotificationsEnabled = false
        }
      }
    }
  }

  //MARK: - Delete method
  
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
