//
//  QuestionPromptsVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class CurrentMoodVC: UIViewController {
  
  //MARK: - Initial setup
  
  private let questionLabel = ReuseableUI.createLabel(withText: "How are you feeling?")
  private let emojiLabel = ReuseableUI.createLabel(withText: "🙂")
  private let moodLabel = ReuseableUI.createLabel(withText: "Just Fine".uppercased())
  private let progressView = CurrentMoodVC.createProgressView(withProgress: 0.5)
  private let continueButton = ReuseableUI.createButton(withTitle: "Continue".uppercased())
  
  private let buttonFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
  
  var selectedMood: String?
  
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
    
    setupLabels()
    setupViews()
    setupConstraints()
    changeTransparency()
    setNavigationAppearance()
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateAppAppearance), name: NSNotification.Name("UpdateAppAppearance"), object: nil)
    
    buttonFeedbackGenerator.prepare()
  }
  
  @objc func updateAppAppearance() {
    let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    self.view.window?.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
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
  
  private func setNavigationAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.systemBackground
    appearance.shadowColor = nil
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }
  
  //MARK: - Configuration methods
  
  private func setupLabels() {
    emojiLabel.font = UIFont.systemFont(ofSize: 100)
    emojiLabel.adjustsFontSizeToFitWidth = false
    
    moodLabel.font = UIFont(name: "Roboto-Light", size: 15)
    moodLabel.adjustsFontSizeToFitWidth = true
    moodLabel.minimumScaleFactor = 0.5
  }
  
  private func setupViews() {
    view.addSubview(questionLabel)
    view.addSubview(emojiLabel)
    view.addSubview(progressView)
    view.addSubview(moodLabel)
    view.addSubview(continueButton)
    
    progressView.progressDidChange = { [weak self] progress in
      self?.updateMoodLabel(for: progress)
    }
    
    continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
      questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      emojiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      moodLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 5),
      moodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      progressView.topAnchor.constraint(equalTo: moodLabel.bottomAnchor, constant: ReuseableUI.padding),
      progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.smallPadding),
      progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.smallPadding),
      progressView.heightAnchor.constraint(equalToConstant: 5),
      
      continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ReuseableUI.bottomButtonPadding),
      continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      continueButton.heightAnchor.constraint(equalToConstant: 60),
      continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.largePadding),
      continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.largePadding)
    ])
  }
  
  //MARK: - Progress view creation method
  
  private static func createProgressView(withProgress progress: Float) -> CustomProgressView {
    let progressView = CustomProgressView()
    progressView.progress = CGFloat(progress)
    progressView.translatesAutoresizingMaskIntoConstraints = false
    return progressView
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
  
  //MARK: - Continue button action method
  
  @objc private func continueButtonTapped() {
    buttonFeedbackGenerator.impactOccurred()
    selectedMood = emojiLabel.text ?? "🙂"
    
    let emotionVC = EmotionListVC()
    emotionVC.mood = selectedMood
    navigationController?.pushViewController(emotionVC, animated: true)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
