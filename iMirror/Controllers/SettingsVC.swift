//
//  SettingsVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  //MARK: - Initial setup
  
  private var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    self.navigationItem.title = "Settings"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    setupTableView()
  }
  
  private func setupTableView() {
    tableView = UITableView(frame: view.bounds, style: .grouped)
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(tableView)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    // Register cell class if custom
    //    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "")
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
    // Number of sections i.e "legal"
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
    
    switch indexPath.section {
    case 0:
      let switchView = UISwitch(frame: .zero)
      switchView.tag = indexPath.row
      switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
      
      if indexPath.row == 0 {
        cell.textLabel?.text = "Notifications"
      } else if indexPath.row == 1 {
        cell.textLabel?.text = "Dark/Light Mode"
      }
      
      cell.accessoryView = switchView
      
    default:
      break
    }
    
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
  
  //MARK: - Other methods
  
  // Show an alert to confirm turning off notifications
  func showAlert(switch sender: UISwitch) {
    let alert = UIAlertController(title: "Turn Off Notifications", message: "Are you sure you want to turn off notifications?", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
      sender.setOn(true, animated: true)
    })
    
    alert.addAction(UIAlertAction(title: "Turn Off", style: .destructive) { _ in
      // Proceed with turning off notifications
    })
    
    present(alert, animated: true)
  }
  
}
