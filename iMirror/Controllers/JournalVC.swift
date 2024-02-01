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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateUI()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    self.navigationItem.title = "Journal"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = editButtonItem
    
    updateUI()
    // Register cell
    tableView.register(JournalEntryCell.self, forCellReuseIdentifier: "JournalCell")
  }
  
  //MARK: - Table view methods
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return journalEntries.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      return UIView()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? JournalEntryCell else {
      fatalError("Unable to dequeue JournalEntryCell")
    }
    
    let entry = journalEntries[indexPath.section]
    cell.configure(with: entry)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  //MARK: - Table view edit methods
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let entry = journalEntries[indexPath.section]
      CoreDataManager.shared.viewContext.delete(entry)
      CoreDataManager.shared.saveContext()
      
      journalEntries.remove(at: indexPath.section)
      tableView.deleteRows(at: [indexPath], with: .fade)
      updateBackgroundMessage()
      tableView.reloadData()
    }
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    
    tableView.setEditing(editing, animated: true)
  }
  
  //MARK: - Update UI methods
  
  private func updateUI() {
    let fetchedEntries = CoreDataManager.shared.fetchJournalEntries()
    journalEntries = fetchedEntries.reversed()
    tableView.reloadData()
    updateBackgroundMessage()
  }
  
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
      self.tableView.separatorStyle = .none
    }
  }
}
