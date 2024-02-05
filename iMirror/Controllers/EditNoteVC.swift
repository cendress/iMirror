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
    setupTextView()
  }
  
  private func setupTextView() {
    view.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
}
