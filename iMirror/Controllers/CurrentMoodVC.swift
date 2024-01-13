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
  let moodLabel = CurrentMoodVC.createLabel(withText: "Just Fine".uppercased())
  let progressView = CurrentMoodVC.createProgressView(withProgress: 0.5)
  let continueButton = CurrentMoodVC.createButton(withTitle: "Continue".uppercased())
  
  let verticalPadding: CGFloat = 200
  let smallVerticalPadding: CGFloat = 40
  let horizontalPadding: CGFloat = 20
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: {
      self.questionLabel.alpha = 1
      self.emojiLabel.alpha = 1
      self.moodLabel.alpha = 1
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
    moodLabel.alpha = 0
    progressView.alpha = 0
    continueButton.alpha = 0
  }
  
  //MARK: - Configuration methods
  
  private func setupViews() {
    view.addSubview(questionLabel)
    view.addSubview(emojiLabel)
    view.addSubview(progressView)
    view.addSubview(moodLabel)
    view.addSubview(continueButton)
    
    progressView.progressDidChange = { [weak self] progress in
      self?.updateMoodLabel(for: progress)
    }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
      questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      emojiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      moodLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 10),
      moodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      progressView.topAnchor.constraint(equalTo: moodLabel.bottomAnchor, constant: 40),
      progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      progressView.heightAnchor.constraint(equalToConstant: 5),
      
      continueButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 60),
      continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      continueButton.heightAnchor.constraint(equalToConstant: 40),
      continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 40)
    ])
  }
  
  private func configureUIProperties() {
    emojiLabel.font = UIFont(name: "Roboto-Medium", size: 120)
    emojiLabel.adjustsFontSizeToFitWidth = true
    emojiLabel.minimumScaleFactor = 0.5
    
    moodLabel.font = UIFont(name: "Roboto-Light", size: 15)
    moodLabel.adjustsFontSizeToFitWidth = true
    moodLabel.minimumScaleFactor = 0.5
    
    continueButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
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
  
  //MARK: - Update mood label method
  
  private func updateMoodLabel(for progress: CGFloat) {
    let mood: (text: String, emoji: String)
    
    switch progress {
    case 0..<0.2:
      mood = ("Awful", "😞")
    case 0.2..<0.4:
      mood = ("Pretty Bad", "😕")
    case 0.4..<0.6:
      mood = ("Just Fine", "🙂")
    case 0.6..<0.8:
      mood = ("Pretty Good", "😀")
    case 0.8...1:
      mood = ("Really Awesome", "🤩")
    default:
      mood = ("Just Fine", "🙂")
    }
    
    moodLabel.text = mood.text.uppercased()
    emojiLabel.text = mood.emoji
  }
}
