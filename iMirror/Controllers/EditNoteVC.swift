//
//  EditNoteVC.swift
//  iMirror
//
//  Created by Christopher Endress on 2/5/24.
//

import UIKit

class EditNoteVC: UIViewController {
  var noteTitleText: String?
  var noteText: String?
  var completion: ((String) -> Void)?
  
  private let textView = UITextView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    adjustNavBarAppearance()
    setupTextView()
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateAppAppearance), name: NSNotification.Name("UpdateAppAppearance"), object: nil)
  }
  
  @objc func updateAppAppearance() {
    let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    self.view.window?.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
  }
  
  private func adjustNavBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemBackground
    appearance.shadowColor = nil
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }
  
  private func setupTextView() {
    view.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: view.topAnchor, constant: ReuseableUI.smallPadding),
      textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -ReuseableUI.smallPadding),
      textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.smallPadding),
      textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.smallPadding),
    ])
    
    textView.text = noteText
    textView.font = UIFont(name: "Roboto-Regular", size: 17)
    textView.textColor = .label
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
    navigationItem.title = noteTitleText
  }
  
  @objc private func doneEditing() {
    completion?(textView.text)
    dismiss(animated: true, completion: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
