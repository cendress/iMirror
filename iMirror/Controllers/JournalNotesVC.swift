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
  private var activeTextView: UITextView?
  
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
    addDoneButtonOnKeyboard()
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
    if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
       let activeTextView = activeTextView {
      
      let keyboardTop = view.frame.height - keyboardFrame.height
      let textViewBottom = activeTextView.convert(activeTextView.bounds, to: view).maxY
      
      if textViewBottom > keyboardTop {
        view.frame.origin.y = -(textViewBottom - keyboardTop)
      }
    }
  }
  
  @objc private func keyboardWillHide(notification: NSNotification) {
    view.frame.origin.y = 0
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
    titleTextView.font = UIFont(name: "Roboto-Regular", size: 18)
    titleTextView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    titleTextView.textColor = .label
    titleTextView.layer.borderColor = UIColor.lightGray.cgColor
    titleTextView.isScrollEnabled = false
    styleTextView(titleTextView)
    
    notesTextView = UITextView()
    notesTextView.text = notesPlaceholder
    notesTextView.font = UIFont(name: "Roboto-Regular", size: 16)
    notesTextView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    notesTextView.textColor = .label
    notesTextView.layer.borderColor = UIColor.lightGray.cgColor
    notesTextView.isScrollEnabled = true
    styleTextView(notesTextView)
    
    titleTextView.delegate = self
    notesTextView.delegate = self
    
    titleTextView.translatesAutoresizingMaskIntoConstraints = false
    notesTextView.translatesAutoresizingMaskIntoConstraints = false
    
    updatePlaceholderTextColor(titleTextView, placeholder: titlePlaceholder)
    updatePlaceholderTextColor(notesTextView, placeholder: notesPlaceholder)
  }
  
  private func styleTextView(_ textView: UITextView) {
    textView.layer.cornerRadius = 8.0
    textView.layer.shadowColor = UIColor.black.cgColor
    textView.layer.shadowOffset = CGSize(width: 0, height: 2)
    textView.layer.shadowOpacity = 0.1
    textView.layer.shadowRadius = 4.0
    textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
  }
  
  private func updatePlaceholderTextColor(_ textView: UITextView, placeholder: String) {
    if textView.text == placeholder {
      textView.textColor = UIColor.lightGray
    } else {
      textView.textColor = .label
    }
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
      notesTextView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -ReuseableUI.largePadding),
      
      saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      saveButton.heightAnchor.constraint(equalToConstant: 60),
      saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.largePadding),
      saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.largePadding),
      saveButton.bottomAnchor.constraint(equalTo: meditationButton.topAnchor, constant: -10),
      
      meditationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ReuseableUI.padding),
      meditationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      meditationButton.heightAnchor.constraint(equalToConstant: 60),
      meditationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.largePadding),
      meditationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.largePadding)
    ])
  }
  
  // MARK: - UITextViewDelegate methods
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    activeTextView = textView
    
    if textView.text == titlePlaceholder || textView.text == notesPlaceholder {
      textView.text = ""
      textView.textColor = UIColor.label
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    activeTextView = nil
    
    if textView.text.isEmpty {
      if textView == titleTextView {
        textView.text = titlePlaceholder
      } else if textView == notesTextView {
        textView.text = notesPlaceholder
      }
      textView.textColor = UIColor.lightGray
    }
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if textView == titleTextView && text == "\n" {
      // Dismiss the keyboard when the return button is pressed on keyboard
      textView.resignFirstResponder()
      return false
    }
    return true
  }
  
  //MARK: - Dismiss keyboard method
  
  private func addDoneButtonOnKeyboard() {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    doneToolbar.barStyle = .default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
    
    doneToolbar.items = [flexSpace, done]
    doneToolbar.sizeToFit()
    
    titleTextView.inputAccessoryView = doneToolbar
    notesTextView.inputAccessoryView = doneToolbar
  }
  
  //MARK: - Deinit
  
  // Unregister keyboard notifications to avoid memory leaks
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
