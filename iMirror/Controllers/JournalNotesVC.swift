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
    notesTextView = UITextView()
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
