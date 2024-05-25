//
//  SettingsViewModel.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import CoreData
import SwiftUI
import UserNotifications

class SettingsViewModel: ObservableObject {
  @Published var isNotificationsEnabled: Bool = UserDefaults.standard.bool(forKey: "isNotificationsEnabled") {
    didSet {
      UserDefaults.standard.set(isNotificationsEnabled, forKey: "isNotificationsEnabled")
    }
  }
  
  @Published var showAlertForNotifications = false
  @Published var showDeleteConfirmation = false
  var viewContext: NSManagedObjectContext?
  
  func setContext(_ context: NSManagedObjectContext) {
    self.viewContext = context
  }
  
  func loadNotificationState() {
    isNotificationsEnabled = UserDefaults.standard.bool(forKey: "isNotificationsEnabled")
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
      // Directly remove all notifications and update state
      isNotificationsEnabled = false
      UserDefaults.standard.set(false, forKey: "isNotificationsEnabled")
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
  
  //MARK: - Dark mode method
  
  func toggleDarkMode(_ isEnabled: Bool) {
    UserDefaults.standard.set(isEnabled, forKey: "isDarkModeEnabled")
    NotificationCenter.default.post(name: NSNotification.Name("UpdateAppAppearance"), object: nil)
  }
  
  //MARK: - Delete method
  
  func deleteAllJournalEntries() {
    CoreDataManager.shared.deleteAllJournalEntries { error in
      DispatchQueue.main.async {
        if error == nil {
          NotificationCenter.default.post(name: .didDeleteAllJournalEntries, object: nil)
        } else {
          print("Error deleting all journal entries: \(String(describing: error))")
        }
      }
    }
  }
}

extension Notification.Name {
  static let didDeleteAllJournalEntries = Notification.Name("didDeleteAllJournalEntries")
}

