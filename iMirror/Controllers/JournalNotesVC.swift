//
//  JournalNotesVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/23/24.
//

import UIKit

class JournalNotesVC: UIViewController {
  
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
    titleTextView.font = UIFont(name: "Roboto-Regular", size: 18)
    titleTextView.backgroundColor = .white
    titleTextView.textColor = .black
    titleTextView.layer.borderColor = UIColor.gray.cgColor
    titleTextView.layer.borderWidth = 1.0
    titleTextView.layer.cornerRadius = 5.0
    titleTextView.isScrollEnabled = false
    
    notesTextView = UITextView()
    notesTextView.font = UIFont(name: "Roboto-Regular", size: 16)
    notesTextView.backgroundColor = .white
    notesTextView.textColor = .black
    notesTextView.layer.borderColor = UIColor.lightGray.cgColor
    notesTextView.layer.borderWidth = 1.0
    notesTextView.layer.cornerRadius = 5.0
    notesTextView.isScrollEnabled = true
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
    ])
  }
}
