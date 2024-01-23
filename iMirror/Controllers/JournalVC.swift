//
//  JournalVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class JournalVC: UITableViewController {
  
  //MARK: - Initial setup
  
  private var journalEntries: [JournalEntry] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    self.navigationItem.title = "Journal"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    updateBackgroundMessage()
  }
  
  //MARK: - Other methods
  
  func updateBackgroundMessage() {
    if journalEntries.isEmpty {
      let messageLabel = ReuseableUI.createLabel(withText: "No entries. Tap the + button to add a new journal entry.")
      
      self.tableView.backgroundView = messageLabel
      self.tableView.separatorStyle = .none
    } else {
      self.tableView.backgroundView = nil
      self.tableView.separatorStyle = .singleLine
    }
  }
}
