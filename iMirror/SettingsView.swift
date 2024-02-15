//
//  SettingsView.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import SwiftUI
import CoreData

struct SettingsView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @State private var isNotificationsEnabled = true
  @State private var isDarkModeEnabled = false
  @State private var showAlertForNotifications = false
  @State private var showDeleteConfirmation = false
  
  var body: some View {
    NavigationView {
      List {
        Section {
          Toggle(isOn: $isNotificationsEnabled) {
            Text("Notifications")
          }
          .onChange(of: isNotificationsEnabled) { newValue in
            if !newValue {
              showAlertForNotifications = true
            }
          }
          .alert("Turn Off Notifications", isPresented: $showAlertForNotifications) {
            Button("Cancel", role: .cancel) {
              isNotificationsEnabled = true
            }
            Button("Turn Off", role: .destructive) {}
          } message: {
            Text("Are you sure you want to turn off notifications?")
          }
          
          Toggle("Dark Mode", isOn: $isDarkModeEnabled)
        }
        
        Section {
          customLink(title: "Support", url: "https://google.com")
          customLink(title: "Privacy Policy", url: "https://google.com")
        }
        
        Section {
          NavigationLink(destination: AcknowledgmentsView()) {
            Text("Acknowledgments")
          }
        }
        
        Section {
          Button("Delete My Data", role: .destructive) {
            showDeleteConfirmation = true
          }
          .alert("Delete All My Data", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
              deleteAllJournalEntries()
            }
          } message: {
            Text("Are you sure you want to delete all your data? This action cannot be undone.")
          }
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.large)
    }
  }
  
  private func customLink(title: String, url: String) -> some View {
    HStack {
      Text(title)
      Spacer()
      Image(systemName: "arrow.up.right")
        .foregroundColor(.blue)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      if let url = URL(string: url) {
        UIApplication.shared.open(url)
      }
    }
  }
  
  private func deleteAllJournalEntries() {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "JournalEntry")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try viewContext.execute(deleteRequest)
      try viewContext.save()
    } catch {
      // Handle the error
      print("Error deleting data: \(error)")
    }
  }
}

#Preview {
    SettingsView()
}
