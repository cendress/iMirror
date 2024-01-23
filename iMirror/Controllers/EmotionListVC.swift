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
  
  // Emotion array
  private let emotions = [
    Emotion(name: "Happiness", symbolName: "smiley"),
    Emotion(name: "Sadness", symbolName: "face.dashed"),
    Emotion(name: "Anger", symbolName: "flame.fill"),
    Emotion(name: "Surprise", symbolName: "exclamationmark.bubble.fill"),
    Emotion(name: "Fear", symbolName: "bolt.fill"),
    Emotion(name: "Disgust", symbolName: "trash.fill"),
    Emotion(name: "Anxiety", symbolName: "ant.circle.fill"),
    Emotion(name: "Hope", symbolName: "sun.max.fill"),
    Emotion(name: "Love", symbolName: "heart.fill"),
    Emotion(name: "Confusion", symbolName: "questionmark.circle.fill"),
    Emotion(name: "Jealousy", symbolName: "eyes"),
    Emotion(name: "Pride", symbolName: "crown.fill"),
    Emotion(name: "Guilt", symbolName: "person.fill.viewfinder"),
    Emotion(name: "Excitement", symbolName: "sparkles"),
    Emotion(name: "Loneliness", symbolName: "person.3.sequence.fill"),
    Emotion(name: "Gratitude", symbolName: "gift.fill"),
    Emotion(name: "Relaxation", symbolName: "hammock.fill"),
    Emotion(name: "Depression", symbolName: "cloud.drizzle.fill"),
    Emotion(name: "Grief", symbolName: "cloud.heavyrain.fill"),
    Emotion(name: "Boredom", symbolName: "yawn.fill"),
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
  
  //MARK: - Configuration methods
  
  private func setupViews() {
    view.addSubview(questionLabel)
    view.addSubview(collectionView)
    view.addSubview(continueButton)
    
    continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
      questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.smallPadding),
      questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.smallPadding),
      
      collectionView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: ReuseableUI.smallPadding),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReuseableUI.smallPadding),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ReuseableUI.smallPadding),
      collectionView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: ReuseableUI.smallPadding),
      
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
    return cell
  }
}
