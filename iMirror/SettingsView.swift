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
            HStack {
              SettingsImageView(imageName: "bell.fill", backgroundColor: .yellow)
              Text("Notifications")
                .font(.custom("Roboto-Regular", size: 18))
            }
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
          HStack {
            SettingsImageView(imageName: "moon.fill", backgroundColor: .blue)
            Toggle("Dark Mode", isOn: $isDarkModeEnabled)
              .font(.custom("Roboto-Regular", size: 18))
          }
        }
        
        Section {
          HStack {
            SettingsImageView(imageName: "person.2.fill", backgroundColor: .purple)
            customLink(title: "Support", url: "https://google.com")
          }
          
          HStack {
            SettingsImageView(imageName: "lock.fill", backgroundColor: .green)
            customLink(title: "Privacy Policy", url: "https://google.com")
          }
        }
        
        Section {
          NavigationLink(destination: AcknowledgmentsView()) {
            
            HStack {
              SettingsImageView(imageName: "book.fill", backgroundColor: .orange)
              Text("Acknowledgments")
                .font(.custom("Roboto-Regular", size: 18))
            }
          }
        }
        
        Section {
          HStack {
            SettingsImageView(imageName: "trash.fill", backgroundColor: .red)
            Button("Delete My Data", role: .destructive) {
              showDeleteConfirmation = true
            }
            .font(.custom("Roboto-Regular", size: 18))
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
        .font(.custom("Roboto-Regular", size: 18))
      
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
