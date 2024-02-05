//
//  JournalVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class JournalVC: UITableViewController {
  
  // Inital setup
  
  private var journalSections: [JournalSection] = []
  private var expandedIndexPaths: Set<IndexPath> = []
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateUI()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Journal"
    navigationController?.navigationBar.prefersLargeTitles = true
    tableView.rowHeight = UITableView.automaticDimension
    updateUI()
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
    return 0
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
    cell.noteLabel.numberOfLines = expandedIndexPaths.contains(indexPath) ? 0 : 2
    
    cell.backgroundColor = UIColor { (traitCollection) -> UIColor in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 0.0, alpha: 1.0)
      default:
        return UIColor(white: 0.95, alpha: 1.0)
      }
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.beginUpdates()
    
    if expandedIndexPaths.contains(indexPath) {
      expandedIndexPaths.remove(indexPath)
    } else {
      expandedIndexPaths.insert(indexPath)
    }
    
    tableView.reloadRows(at: [indexPath], with: .automatic)
    
    tableView.endUpdates()
  }
  
  //MARK: - Edit methods
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    // Required method
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    // Delete action
    let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
      self?.deleteJournalEntry(at: indexPath)
      completionHandler(true)
    }
    
    deleteAction.backgroundColor = UIColor { (traitCollection) -> UIColor in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 0.0, alpha: 1.0)
      default:
        return UIColor(white: 0.95, alpha: 1.0)
      }
    }
    
    deleteAction.image = UIImage(named: "trash")
    
    // Edit action
    let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
      self?.editJournalEntry(at: indexPath)
      completionHandler(true)
    }
    
    editAction.backgroundColor = UIColor { (traitCollection) -> UIColor in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 0.0, alpha: 1.0)
      default:
        return UIColor(white: 0.95, alpha: 1.0)
      }
    }
    
    editAction.image = UIImage(named: "edit")
    
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    configuration.performsFirstActionWithFullSwipe = false
    return configuration
  }
  
  //MARK: - Edit methods
  
  private func deleteJournalEntry(at indexPath: IndexPath) {
    let journalEntry = journalEntries[indexPath.section]
    CoreDataManager.shared.viewContext.delete(journalEntry)
    CoreDataManager.shared.saveContext()
    
    journalEntries.remove(at: indexPath.section)
    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
    updateBackgroundMessage()
  }
  
  private func editJournalEntry(at indexPath: IndexPath) {
    let entry = journalEntries[indexPath.section]
    let editVC = EditNoteVC()
    editVC.noteTitleText = entry.title
    editVC.noteText = entry.note
    editVC.completion = { [weak self] newNoteText in

      entry.note = newNoteText

      CoreDataManager.shared.saveContext()

      self?.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }
    
    let navController = UINavigationController(rootViewController: editVC)
    navController.modalPresentationStyle = .formSheet
    self.present(navController, animated: true, completion: nil)
  }
  
  //MARK: - Update UI methods
  
  private func updateUI() {
    let fetchedEntries = CoreDataManager.shared.fetchJournalEntries()
    journalEntries = fetchedEntries.reversed()
    tableView.reloadData()
    updateBackgroundMessage()
  }
  
  private func updateBackgroundMessage() {
    let messageLabelTag = 123
    tableView.backgroundView?.viewWithTag(messageLabelTag)?.removeFromSuperview()
    
    let messageLabel = UILabel()
    messageLabel.tag = messageLabelTag
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.frame = tableView.bounds
    
    if journalEntries.isEmpty {
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
      
      if tableView.backgroundView == nil {
        tableView.backgroundView = UIView(frame: tableView.bounds)
      }
      
      tableView.backgroundView?.addSubview(messageLabel)
      
      messageLabel.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        messageLabel.centerXAnchor.constraint(equalTo: tableView.backgroundView!.centerXAnchor),
        messageLabel.centerYAnchor.constraint(equalTo: tableView.backgroundView!.centerYAnchor),
        messageLabel.leadingAnchor.constraint(equalTo: tableView.backgroundView!.leadingAnchor),
        messageLabel.trailingAnchor.constraint(equalTo: tableView.backgroundView!.trailingAnchor)
      ])
    }
    
    tableView.backgroundColor = UIColor { (traitCollection) -> UIColor in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 0.0, alpha: 1.0)
      default:
        return UIColor(white: 0.95, alpha: 1.0)
      }
    }
    
    tableView.separatorStyle = .none
  }
}
