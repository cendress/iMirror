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
  
  private let saveButton = ReuseableUI.createButton(withTitle: "Save & Exit".uppercased())
  private let meditationButton = ReuseableUI.createButton(withTitle: "Begin Meditation".uppercased())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: self, action: #selector(backButtonTapped))
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
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
  
  //MARK: - Keyboard @objc methods
  
  @objc private func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      if view.frame.origin.y == 0 {
        view.frame.origin.y -= keyboardSize.height / 2
      }
    }
  }
  
  @objc private func keyboardWillHide(notification: NSNotification) {
    if view.frame.origin.y != 0 {
      view.frame.origin.y = 0
    }
  }
  
  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
  
  //MARK: - Button @objc methods
  
  @objc private func saveButtonTapped() {
    // Add saving logic
    
    self.dismiss(animated: true)
  }
  
  @objc private func meditationButtonTapped() {
    // Navigate to new view controller
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
    view.addSubview(saveButton)
    view.addSubview(meditationButton)
    
    saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    meditationButton.addTarget(self, action: #selector(meditationButtonTapped), for: .touchUpInside)
    
    // Tap gesture to dismiss keyboard
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tapGesture)
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
      notesTextView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -ReuseableUI.largePadding),
      
      saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      saveButton.heightAnchor.constraint(equalToConstant: 60),
      saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.largePadding),
      saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.largePadding),
      saveButton.bottomAnchor.constraint(equalTo: meditationButton.topAnchor, constant: 10),
      
      meditationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ReuseableUI.padding),
      meditationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      meditationButton.heightAnchor.constraint(equalToConstant: 60),
      meditationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.largePadding),
      meditationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.largePadding)
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
  
  //MARK: - Deinit
  
  // Unregister keyboard notifications to avoid memory leaks
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
