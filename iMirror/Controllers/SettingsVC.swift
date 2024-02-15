//
//  SettingsVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import CoreData
import UIKit

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  //MARK: - Initial setup
  
  private var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Settings"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    setupTableView()
  }
  
  private func setupTableView() {
    tableView = UITableView(frame: view.bounds, style: .grouped)
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(tableView)
    
    tableView.backgroundColor = UIColor { (traitCollection) -> UIColor in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 0.0, alpha: 1.0)
      default:
        return UIColor(white: 0.95, alpha: 1.0)
      }
    }
    
    tableView.dataSource = self
    tableView.delegate = self
    
    // Register cell class if custom
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  //MARK: - @objc methods
  
  // Switch action handler
  @objc func switchChanged(_ sender: UISwitch) {
    if sender.tag == 0 {
      if !sender.isOn {
        showAlert(switch: sender)
      } else {
        // Enable notifications
      }
    } else if sender.tag == 1 {
      // Light/dark mode switch
    }
  }
  
  // MARK: - Table view data source methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows for each section
    switch section {
    case 0:
      return 2 // Notifications and Dark/Light mode toggles
    case 1:
      return 2 // Support and Privacy Policy
    case 2:
      return 1 // Acknowledgments
    case 3:
      return 1 // Delete My Data
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    // Default system image name
    var systemImageName = "gear"
    
    switch indexPath.section {
    case 0:
      systemImageName = indexPath.row == 0 ? "bell.fill" : "moon.fill"
      cell.textLabel?.text = indexPath.row == 0 ? "Notifications" : "Dark Mode"
      let switchView = UISwitch(frame: .zero)
      switchView.tag = indexPath.row
      switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
      cell.accessoryView = switchView
      
    case 1:
      systemImageName = indexPath.row == 0 ? "questionmark.circle" : "lock.fill"
      cell.textLabel?.text = indexPath.row == 0 ? "Support" : "Privacy Policy"
      
    case 2:
      systemImageName = "book.fill"
      cell.textLabel?.text = "Acknowledgments"
      
    case 3:
      systemImageName = "trash.fill"
      cell.textLabel?.text = "Delete My Data"
      cell.textLabel?.textColor = UIColor.red
      
    default: break
    }
    
    if let robotoFont = UIFont(name: "Roboto-Regular", size: 18) {
      cell.textLabel?.font = robotoFont
    }
    
    cell.imageView?.image = UIImage(systemName: systemImageName)
    
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch indexPath.section {
      // Support and Privacy Policy section
    case 1:
      if indexPath.row == 0 {
        openSupportPage()
      } else if indexPath.row == 1 {
        openPrivacyPolicyPage()
      }
      // Acknowledgments section
    case 2:
      let acknowledgmentsVC = AcknowledgmentsVC()
      navigationController?.pushViewController(acknowledgmentsVC, animated: true)
      // Delete data section
    case 3:
      showDeleteConfirmationAlert()
      
    default:
      break
    }
  }
  
  //MARK: - Navigate to URL methods
  
  private func openSupportPage() {
    if let url = URL(string: "https://www.google.com") {
      UIApplication.shared.open(url)
    }
  }
  
  private func openPrivacyPolicyPage() {
    if let url = URL(string: "https://www.google.com") {
      UIApplication.shared.open(url)
    }
  }
  
  //MARK: - Alert methods
  
  // Show an alert to confirm turning off notifications
  private func showAlert(switch sender: UISwitch) {
    let alert = UIAlertController(title: "Turn Off Notifications", message: "Are you sure you want to turn off notifications?", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
      sender.setOn(true, animated: true)
    })
    
    alert.addAction(UIAlertAction(title: "Turn Off", style: .destructive) { _ in
    })
    
    present(alert, animated: true)
  }
  
  private func showDeleteConfirmationAlert() {
    let alert = UIAlertController(title: "Delete All My Data", message: "Are you sure you want to delete all your data? This action cannot be undone.", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
      self?.deleteAllJournalEntries()
    }))
    
    present(alert, animated: true)
  }
  
  //MARK: - Delete method
  
  private func deleteAllJournalEntries() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "JournalEntry")
    
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try managedContext.execute(deleteRequest)
      try managedContext.save()
      
      NotificationCenter.default.post(name: NSNotification.Name("JournalEntriesDeleted"), object: nil)
    } catch let error as NSError {
      print("Could not delete all journal entries. \(error), \(error.userInfo)")
    }
  }
}
