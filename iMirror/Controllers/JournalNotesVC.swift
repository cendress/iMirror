//
//  JournalNotesVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/23/24.
//

import UIKit

class JournalNotesVC: UIViewController, UITextViewDelegate {
  
  //MARK: - Initial setup
  
  private let questionLabel = ReuseableUI.createLabel(withText: "Write about it.")
  
  private var titleTextView: UITextView!
  private var notesTextView: UITextView!
  
  private let titlePlaceholder = "Enter a title..."
  private let notesPlaceholder = "Write some notes here..."
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: self, action: #selector(backButtonTapped))
    
    setupTextViews()
    setupViews()
    setupConstraints()
  }
  
  //MARK: - @objc methods
  
  @objc private func closeButtonTapped() {
    self.dismiss(animated: true)
  }
  
  @objc private func backButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
  
  //MARK: - Configuration methods
  
  private func setupTextViews() {
    titleTextView = UITextView()
    titleTextView.text = titlePlaceholder
    titleTextView.textColor = UIColor.lightGray
    titleTextView.font = UIFont(name: "Roboto-Regular", size: 18)
    titleTextView.backgroundColor = .white
    titleTextView.textColor = .label
    titleTextView.layer.borderColor = UIColor.gray.cgColor
    titleTextView.layer.borderWidth = 1.0
    titleTextView.layer.cornerRadius = 5.0
    titleTextView.isScrollEnabled = false
    
    notesTextView = UITextView()
    notesTextView.text = notesPlaceholder
    notesTextView.textColor = UIColor.lightGray
    notesTextView.font = UIFont(name: "Roboto-Regular", size: 16)
    notesTextView.backgroundColor = .white
    notesTextView.textColor = .label
    notesTextView.layer.borderColor = UIColor.lightGray.cgColor
    notesTextView.layer.borderWidth = 1.0
    notesTextView.layer.cornerRadius = 5.0
    notesTextView.isScrollEnabled = true
    
    titleTextView.delegate = self
    notesTextView.delegate = self
    
    titleTextView.translatesAutoresizingMaskIntoConstraints = false
    notesTextView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupViews() {
    view.addSubview(questionLabel)
    view.addSubview(titleTextView)
    view.addSubview(notesTextView)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
      questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      titleTextView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: ReuseableUI.smallPadding),
      titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.smallPadding),
      titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.smallPadding),
      titleTextView.heightAnchor.constraint(equalToConstant: ReuseableUI.padding),
      
      notesTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: ReuseableUI.smallPadding),
      notesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.smallPadding),
      notesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.smallPadding),
      // Change this constraint when you add buttons
      notesTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ReuseableUI.smallPadding)
    ])
  }
  
  // MARK: - UITextViewDelegate methods
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == titlePlaceholder || textView.text == notesPlaceholder {
      textView.text = ""
      textView.textColor = UIColor.label
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      if textView == titleTextView {
        textView.text = titlePlaceholder
      } else if textView == notesTextView {
        textView.text = notesPlaceholder
      }
      textView.textColor = UIColor.lightGray
    }
  }
}
