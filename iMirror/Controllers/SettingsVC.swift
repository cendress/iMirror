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
      if indexPath.row == 0 {
        cell.textLabel?.text = "Notifications"
        // Add UISwitch for toggling, handle its action to show alert if needed
      } else {
        cell.textLabel?.text = "Dark/Light Mode"
        // Add UISwitch for toggling
      }
    case 1:
      if indexPath.row == 0 {
        cell.textLabel?.text = "Support"
      } else {
        cell.textLabel?.text = "Privacy Policy"
      }
    case 2:
      cell.textLabel?.text = "Acknowledgments"
    case 3:
      cell.textLabel?.text = "Delete My Data"
      // Customize the cell to indicate it's a destructive action, if you like
    default:
      break
    }
    
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Handle cell selection for actions like navigating to detail views or showing alerts
    // Example:
    if indexPath.section == 3 {
      // Show alert to confirm "Delete My Data"
    }
  }
  
  // Additional delegate methods for customization
  
}
