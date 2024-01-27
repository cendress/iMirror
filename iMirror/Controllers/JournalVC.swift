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
  var selectedEmoji: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    self.navigationItem.title = "Journal"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    updateBackgroundMessage()
  }
  
  //MARK: - Table view methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return journalEntries.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath)
    cell.textLabel?.text = selectedEmoji
    return cell
  }
  
  //MARK: - Other methods
  
  private func updateBackgroundMessage() {
    if journalEntries.isEmpty {
      let messageLabel = UILabel()
      messageLabel.numberOfLines = 0
      messageLabel.textAlignment = .center
      
      let noEntriesText = "No Entries!\n"
      let actionText = "Tap the plus button to add a journal entry."
      
      let noEntriesAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Roboto-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24)
      ]
      
      let actionAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Roboto-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)
      ]
      
      let attributedString = NSMutableAttributedString(string: noEntriesText, attributes: noEntriesAttributes)
      attributedString.append(NSAttributedString(string: actionText, attributes: actionAttributes))
      
      messageLabel.attributedText = attributedString
      
      self.tableView.backgroundView = messageLabel
      self.tableView.separatorStyle = .none
    } else {
      self.tableView.backgroundView = nil
      self.tableView.separatorStyle = .singleLine
    }
  }
}

extension JournalVC: CurrentMoodDelegate {
  func didSelectMood(emoji: String) {
    self.selectedEmoji = emoji
    tableView.reloadData()
  }
}
