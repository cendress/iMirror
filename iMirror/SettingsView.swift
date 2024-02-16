//
//  SettingsView.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import CoreData
import SwiftUI
import UIKit

struct SettingsView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @StateObject private var viewModel = SettingsViewModel()
  
  var body: some View {
    NavigationView {
      List {
        notificationSection
        supportSection
        acknowledgmentsSection
        deleteDataSection
      }
      .onAppear {
        viewModel.setContext(viewContext)
        configureNavigationBarAppearance()
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.large)
      .background(BackgroundView())
    }
  }
  
  private func configureNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.largeTitleTextAttributes = [.font: UIFont(name: "Roboto-Bold", size: 37)!]
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
  
  private var notificationSection: some View {
    Section {
      ToggleSettingsView(isEnabled: $viewModel.isNotificationsEnabled, imageName: "bell.fill", title: "Notifications", backgroundColor: .yellow)
        .onChange(of: viewModel.isNotificationsEnabled) { newValue in
          viewModel.toggleNotification(newValue)
        }
        .alert("Turn Off Notifications", isPresented: $viewModel.showAlertForNotifications) {
          Button("Cancel", role: .cancel) {
            viewModel.isNotificationsEnabled = true
          }
          Button("Turn Off", role: .destructive) {}
        } message: {
          Text("Are you sure you want to turn off notifications?")
        }
      
      ToggleSettingsView(isEnabled: $viewModel.isDarkModeEnabled, imageName: "moon.fill", title: "Dark Mode", backgroundColor: .blue)
    }
  }
  
  private var supportSection: some View {
    Section {
      CustomLinkView(title: "Support", url: "https://google.com", imageName: "person.2.fill", backgroundColor: .purple)
      CustomLinkView(title: "Privacy Policy", url: "https://google.com", imageName: "lock.fill", backgroundColor: .green)
    }
  }
  
  private var acknowledgmentsSection: some View {
    Section {
      NavigationLink(destination: AcknowledgmentsView()) {
        SettingItemView(imageName: "book.fill", title: "Acknowledgments", backgroundColor: .orange)
      }
    }
  }
  
  private var deleteDataSection: some View {
    Section {
      Button("Delete My Data", role: .destructive) {
        viewModel.showDeleteConfirmation = true
      }
      .alert("Delete All My Data", isPresented: $viewModel.showDeleteConfirmation) {
        Button("Cancel", role: .cancel) { }
        Button("Delete", role: .destructive) {
          viewModel.deleteAllJournalEntries()
        }
      } message: {
        Text("Are you sure you want to delete all your data? This action cannot be undone.")
      }
    }
  }
}

#Preview {
  SettingsView()
}
