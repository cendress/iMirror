//
//  EmotionListVC.swift
//  iMirror
//
//  Created by Christopher Endress on 1/22/24.
//

import UIKit

class EmotionListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  //MARK: - Initial setup
  
  private let questionLabel = ReuseableUI.createLabel(withText: "What emotions are you feeling?")
  private var collectionView: UICollectionView!
  private let continueButton = ReuseableUI.createButton(withTitle: "Continue".uppercased())
  private var selectedEmotions: Set<Int> = []
  
  var mood: String?
  
  // Emotion array
  private let emotions = [
    Emotion(name: "Happiness", symbolName: "smiley"),
    Emotion(name: "Sadness", symbolName: "cloud.rain.fill"),
    Emotion(name: "Anger", symbolName: "flame.fill"),
    Emotion(name: "Surprise", symbolName: "exclamationmark.bubble.fill"),
    Emotion(name: "Fear", symbolName: "bolt.fill"),
    Emotion(name: "Disgust", symbolName: "trash.fill"),
    Emotion(name: "Anxiety", symbolName: "ant.circle.fill"),
    Emotion(name: "Hope", symbolName: "sun.max.fill"),
    Emotion(name: "Love", symbolName: "heart.fill"),
    Emotion(name: "Confusion", symbolName: "puzzlepiece.fill"),
    Emotion(name: "Jealousy", symbolName: "eyes"),
    Emotion(name: "Pride", symbolName: "crown.fill"),
    Emotion(name: "Guilt", symbolName: "person.fill.viewfinder"),
    Emotion(name: "Excitement", symbolName: "sparkles"),
    Emotion(name: "Loneliness", symbolName: "person.3.sequence.fill"),
    Emotion(name: "Gratitude", symbolName: "gift.fill"),
    Emotion(name: "Relaxation", symbolName: "leaf.fill"),
    Emotion(name: "Depression", symbolName: "umbrella.fill"),
    Emotion(name: "Grief", symbolName: "waveform.path.ecg"),
    Emotion(name: "Boredom", symbolName: "hourglass"),
    Emotion(name: "Curiosity", symbolName: "lightbulb.fill"),
    Emotion(name: "Resentment", symbolName: "tortoise.fill"),
    Emotion(name: "Regret", symbolName: "backward.fill"),
    // Default use case:
    Emotion(name: "Other", symbolName: "questionmark.circle.fill")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: self, action: #selector(backButtonTapped))
    
    setupCollectionView()
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
  
  @objc private func continueButtonTapped() {
    if selectedEmotions.isEmpty {
      showAlert()
      return
    }
    
    let journalNotesVC = JournalNotesVC()
    journalNotesVC.mood = self.mood
    journalNotesVC.selectedEmotions = selectedEmotions.map { emotions[$0].name }
    navigationController?.pushViewController(journalNotesVC, animated: true)
  }
  
  //MARK: - Configuration methods
  
  private func setupViews() {
    view.addSubview(questionLabel)
    view.addSubview(collectionView)
    view.addSubview(continueButton)
    
    continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
      questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.smallPadding),
      questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.smallPadding),
      
      collectionView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: ReuseableUI.padding),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.smallPadding),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.smallPadding),
      collectionView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -ReuseableUI.padding),
      
      continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ReuseableUI.padding),
      continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      continueButton.heightAnchor.constraint(equalToConstant: 60),
      continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.largePadding),
      continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.largePadding)
    ])
  }
  
  //MARK: - Collection view methods
  
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: 100, height: 100)
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(EmotionCollectionViewCell.self, forCellWithReuseIdentifier: "EmotionCell")
    collectionView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return emotions.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmotionCell", for: indexPath) as? EmotionCollectionViewCell else {
      fatalError("Failed to dequeue collection view cell.")
    }
    
    let emotion = emotions[indexPath.row]
    cell.emotionImageView.image = UIImage(systemName: emotion.symbolName)
    cell.emotionLabel.text = emotion.name
    cell.backgroundColor = .systemBackground
    
    cell.isToggled = selectedEmotions.contains(indexPath.row)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if selectedEmotions.contains(indexPath.row) {
      // This item was selected but then deselected by the user
      selectedEmotions.remove(indexPath.row)
    } else {
      // Item was selected by user
      selectedEmotions.insert(indexPath.row)
    }
    
    if let cell = collectionView.cellForItem(at: indexPath) as? EmotionCollectionViewCell {
      cell.isToggled.toggle()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let cell = cell as? EmotionCollectionViewCell else { return }
    cell.isToggled = selectedEmotions.contains(indexPath.row)
  }
  
  //MARK: - Alert controller
  
  private func showAlert() {
    let ac = UIAlertController(title: "Select an Emotion", message: "Please select an emotion to continue.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
}
