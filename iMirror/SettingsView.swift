//
//  SettingsView.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import CoreData
import SwiftUI
import UIKit
import UserNotifications

struct SettingsView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.scenePhase) var scenePhase
  @Environment(\.colorScheme) var systemColorScheme
  
  @StateObject private var viewModel = SettingsViewModel()
  @ObservedObject var appearanceManager = AppearanceManager()
  
  init() {
    setupNavigationBarAppearance()
  }
  
  var body: some View {
    NavigationView {
      List {
        notificationSection
        supportSection
        acknowledgmentsSection
        deleteDataSection
      }
      .listRowBackground(Color.clear)
      .onAppear {
        viewModel.setContext(viewContext)
        viewModel.checkNotificationPermissionAndUpdateToggle()
        adjustAppearanceToSystemIfNeeded()
      }
      .onChange(of: scenePhase) { newScenePhase in
        if newScenePhase == .active {
          viewModel.checkNotificationPermissionAndUpdateToggle()
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.large)
    }
  }
  
  private func adjustAppearanceToSystemIfNeeded() {
    if UserDefaults.standard.object(forKey: "isDarkModeEnabled") == nil {
      let isSystemDarkMode = systemColorScheme == .dark
      UserDefaults.standard.set(isSystemDarkMode, forKey: "isDarkModeEnabled")
      appearanceManager.isDarkModeEnabled = isSystemDarkMode
    }
  }
  
  private func setupNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.shadowColor = nil
    appearance.backgroundColor = UIColor(named: "FormBackgroundColor")
    
    if let robotoBoldFont = UIFont(name: "Roboto-Bold", size: 37) {
      appearance.largeTitleTextAttributes = [.font: robotoBoldFont]
    }
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
  
  private var notificationSection: some View {
    Section(header: Text("Preferences").background(Color.clear)) {
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
      
      ToggleSettingsView(isEnabled: $appearanceManager.isDarkModeEnabled, imageName: "moon.fill", title: "Dark Mode", backgroundColor: .blue)
        .onChange(of: appearanceManager.isDarkModeEnabled) { newValue in
          viewModel.toggleDarkMode(newValue)
        }
    }
  }
  
  private var supportSection: some View {
    Section(header: Text("Legal").background(Color.clear)) {
      CustomLinkView(title: "Support", url: "https://google.com", imageName: "person.2.fill", backgroundColor: .purple)
      CustomLinkView(title: "Privacy Policy", url: "https://google.com", imageName: "lock.fill", backgroundColor: .green)
    }
  }
  
  private var acknowledgmentsSection: some View {
    Section(header: Text("Acknowledgements").background(Color.clear)) {
      NavigationLink(destination: AcknowledgmentsView()) {
        SettingItemView(imageName: "book.fill", title: "Acknowledgments", backgroundColor: .orange)
      }
    }
  }
  
  private var deleteDataSection: some View {
    Section(header: Text("Data Management").background(Color.clear)) {
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

//MARK: - AppearanceManager Class

class AppearanceManager: ObservableObject {
  @Published var isDarkModeEnabled: Bool = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
  
  init() {
    NotificationCenter.default.addObserver(forName: NSNotification.Name("UpdateAppAppearance"), object: nil, queue: .main) { [weak self] _ in
      self?.isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    }
  }
}
