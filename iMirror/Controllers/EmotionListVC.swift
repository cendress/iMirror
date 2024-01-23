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
    collectionView.backgroundColor = .systemMint
    collectionView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmotionCell", for: indexPath)
    cell.backgroundColor = .systemBackground
    return cell
  }
}
