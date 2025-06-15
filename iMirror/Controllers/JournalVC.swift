//
//  JournalVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit
import UserNotifications

class JournalVC: UITableViewController {
    
    //MARK: - Properties
    
    private var journalSections: [JournalSection] = []
    private var expandedIndexPaths: Set<IndexPath> = []
    private let dailyInspirationNotificationId = "dailyInspirationNotificationId"
    
    // Haptic feedback generators
    private let cellFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let buttonFeedbackGenerator = UISelectionFeedbackGenerator()
    
    // Use lazy to initialize property only when its used
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // View life cycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        updateNavigationBarColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestNotificationPermission()
        
        // Prepare the feedback generators
        cellFeedbackGenerator.prepare()
        buttonFeedbackGenerator.prepare()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Journal"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(filterEntries))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(JournalEntryCell.self, forCellReuseIdentifier: "JournalCell")
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(journalEntriesDeleted), name: NSNotification.Name("JournalEntriesDeleted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAppAppearance), name: NSNotification.Name("UpdateAppAppearance"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataDeleted), name: .didDeleteAllJournalEntries, object: nil)
        
        updateUI()
    }
    
    @objc func handleDataDeleted() {
        updateUI()
    }
    
    @objc func updateAppAppearance() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        self.view.window?.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }
    
    //MARK: - Filter entry date methods
    
    @objc func journalEntriesDeleted() {
        self.tableView.reloadData()
    }
    
    @objc func filterEntries() {
        let alert = UIAlertController(title: "Filter", message: "Select how you want to filter the journal entries.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Select Date", style: .default) { _ in
            // Implement filter logic
            self.presentDatePicker()
        })
        alert.addAction(UIAlertAction(title: "Show All Entries", style: .default) { _ in
            self.updateUI()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func presentDatePicker() {
        let datePickerVC = DatePickerVC()
        datePickerVC.modalPresentationStyle = .formSheet
        datePickerVC.completion = { [weak self] selectedDate in
            if let date = selectedDate {
                self?.filterJournalEntries(byDate: date)
            }
        }
        
        if let sheet = datePickerVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        
        present(datePickerVC, animated: true, completion: nil)
    }
    
    private func filterJournalEntries(byDate selectedDate: Date) {
        let calendar = Calendar.current
        journalSections = journalSections.filter { section in
            calendar.isDate(section.date, inSameDayAs: selectedDate)
        }
        tableView.reloadData()
    }
    
    //MARK: - Table view methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return journalSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalSections[section].entries.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        headerView.backgroundColor = .systemBackground
        
        let headerLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.bounds.size.width, height: 60))
        headerLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        headerLabel.textColor = UIColor.label
        
        headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionDate = journalSections[section].date
        return dateFormatter.string(from: sectionDate)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? JournalEntryCell else {
            fatalError("Unable to dequeue JournalEntryCell")
        }
        
        let entry = journalSections[indexPath.section].entries[indexPath.row]
        cell.configure(with: entry)
        cell.noteLabel.numberOfLines = expandedIndexPaths.contains(indexPath) ? 0 : 2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellFeedbackGenerator.impactOccurred()
        
        tableView.beginUpdates()
        
        if expandedIndexPaths.contains(indexPath) {
            expandedIndexPaths.remove(indexPath)
        } else {
            expandedIndexPaths.insert(indexPath)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        tableView.endUpdates()
    }
    
    //MARK: - Swipe action methods
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Required method
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
            self?.buttonFeedbackGenerator.selectionChanged()
            
            // Present alert controller to confirm deletion
            let ac = UIAlertController(title: "Delete Entry", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completionHandler(false)
            }))
            ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self?.deleteJournalEntry(at: indexPath)
                completionHandler(true)
            }))
            self?.present(ac, animated: true, completion: nil)
        }
        
        deleteAction.backgroundColor = .systemBackground
        
        deleteAction.image = UIImage(named: "trash")
        
        // Edit action
        let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            self?.buttonFeedbackGenerator.selectionChanged()
            self?.editJournalEntry(at: indexPath)
            completionHandler(true)
        }
        
        editAction.backgroundColor = .systemBackground
        
        editAction.image = UIImage(named: "edit")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    //MARK: - Edit methods
    
    private func deleteJournalEntry(at indexPath: IndexPath) {
        let section = journalSections[indexPath.section]
        let entryToDelete = section.entries[indexPath.row]
        
        CoreDataManager.shared.viewContext.delete(entryToDelete)
        CoreDataManager.shared.saveContext()
        
        journalSections[indexPath.section].entries.remove(at: indexPath.row)
        if journalSections[indexPath.section].entries.isEmpty {
            journalSections.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        updateBackgroundMessage()
    }
    
    private func editJournalEntry(at indexPath: IndexPath) {
        let entryToEdit = journalSections[indexPath.section].entries[indexPath.row]
        let editVC = EditNoteVC()
        editVC.noteTitleText = entryToEdit.title
        editVC.noteText = entryToEdit.note
        editVC.completion = { [weak self] newNoteText in
            entryToEdit.note = newNoteText
            CoreDataManager.shared.saveContext()
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let navController = UINavigationController(rootViewController: editVC)
        navController.modalPresentationStyle = .formSheet
        self.present(navController, animated: true, completion: nil)
    }
    
    //MARK: - Update UI methods
    
    private func updateUI() {
        let fetchedEntries = CoreDataManager.shared.fetchJournalEntries()
        groupJournalEntries(fetchedEntries)
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
        
        if journalSections.isEmpty {
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
        
        tableView.separatorStyle = .none
    }
    
    //MARK: - Notification methods
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("Notification permission granted.")
                    self.setupDailyInspirationalQuoteNotification()
                } else {
                    print("Notification permission denied.")
                }
            }
        }
    }
    
    // Method for testing
    //  private func setupDailyInspirationalQuoteNotification() {
    //    let quote = QuoteProvider.shared.getRandomQuote()
    //    let content = UNMutableNotificationContent()
    //    content.title = "Daily Inspiration"
    //    content.body = "\"\(quote.text)\" - \(quote.author ?? "Unknown")"
    //    content.sound = UNNotificationSound.default
    //
    //    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
    //
    //    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    //
    //    UNUserNotificationCenter.current().add(request) { error in
    //      DispatchQueue.main.async {
    //        if let error = error {
    //          print("Error scheduling daily inspiration notification: \(error)")
    //        } else {
    //          print("Successfully scheduled daily inspiration notification every minute.")
    //        }
    //      }
    //    }
    //  }
    
    private func setupDailyInspirationalQuoteNotification() {
        let quote = QuoteProvider.shared.getRandomQuote()
        let content = UNMutableNotificationContent()
        content.title = "Daily Inspiration"
        content.body = "\"\(quote.text)\" - \(quote.author ?? "Unknown")"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Remove any existing notifications with that identifier
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [dailyInspirationNotificationId])
        
        // Schedule a new notification
        let request = UNNotificationRequest(identifier: dailyInspirationNotificationId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error scheduling daily inspiration notification: \(error)")
                } else {
                    print("Successfully scheduled daily inspiration notification.")
                }
            }
        }
    }
    
    //MARK: - Update navigation bar appearance methods
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateNavigationBarColor()
        }
    }
    
    private func updateNavigationBarColor() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    //MARK: - Other methods
    
    private func groupJournalEntries(_ entries: [JournalEntry]) {
        var tempSections: [Date: [JournalEntry]] = [:]
        let calendar = Calendar.current
        
        for entry in entries {
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: entry.currentDate!)
            if let date = calendar.date(from: dateComponents) {
                if tempSections[date] == nil {
                    tempSections[date] = [entry]
                } else {
                    tempSections[date]?.append(entry)
                }
            }
        }
        
        journalSections = tempSections.map { JournalSection(date: $0.key, entries: $0.value) }
        
        // Sort entries by date in descending order
        journalSections.sort { $0.date > $1.date }
        
        // Sort entries within each section by currentTime in descending order
        for i in 0..<journalSections.count {
            journalSections[i].entries.sort {
                $0.currentTime! > $1.currentTime!
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
