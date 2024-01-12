//
//  QuestionPromptsVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class CurrentMoodVC: UIViewController {
  
  //MARK: - Initial setup
  
  let questionLabel = CurrentMoodVC.createLabel(withText: "How are you feeling?")
  let emojiLabel = CurrentMoodVC.createLabel(withText: "🙂")
  let progressView = CurrentMoodVC.createProgressView(withProgress: 0.5)
  let continueButton = CurrentMoodVC.createButton(withTitle: "Continue")
  
  let verticalPadding: CGFloat = 200
  let smallVerticalPadding: CGFloat = 40
  let horizontalPadding: CGFloat = 20
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: {
      self.questionLabel.alpha = 1
      self.emojiLabel.alpha = 1
      self.progressView.alpha = 1
      self.continueButton.alpha = 1
    }, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
    
    setupViews()
    setupConstraints()
    configureUIProperties()
    changeTransparency()
  }
  
  @objc func closeButtonTapped() {
    self.dismiss(animated: true)
  }
  
  private func changeTransparency() {
    questionLabel.alpha = 0
    emojiLabel.alpha = 0
    progressView.alpha = 0
    continueButton.alpha = 0
  }
  
  //MARK: - Configuration methods
  
  private func setupViews() {
    view.addSubview(questionLabel)
    view.addSubview(emojiLabel)
    view.addSubview(progressView)
    view.addSubview(continueButton)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
      questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      emojiLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: smallVerticalPadding),
      emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      progressView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: verticalPadding),
      progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
      progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
      progressView.heightAnchor.constraint(equalToConstant: 20),
      
      continueButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: smallVerticalPadding),
      continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      continueButton.heightAnchor.constraint(equalToConstant: 50),
      continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
      continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding)
    ])
  }
  
  private func configureUIProperties() {
    emojiLabel.font = UIFont(name: "Roboto-Medium", size: 120)
    emojiLabel.adjustsFontSizeToFitWidth = true
    emojiLabel.minimumScaleFactor = 0.5
    
    continueButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
    continueButton.backgroundColor = .tintColor
    continueButton.setTitleColor(.systemBackground, for: .normal)
    continueButton.layer.cornerRadius = 25
    continueButton.layer.borderWidth = 4
    continueButton.layer.masksToBounds = true
  }
  
  //MARK: - UI creation methods
  
  private static func createLabel(withText text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = UIFont(name: "Roboto-Medium", size: 30)
    label.adjustsFontSizeToFitWidth = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  private static func createProgressView(withProgress progress: Float) -> CustomProgressView {
    let progressView = CustomProgressView()
    progressView.progress = CGFloat(progress)
    progressView.translatesAutoresizingMaskIntoConstraints = false
    return progressView
  }
  
  private static func createButton(withTitle title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }
}
