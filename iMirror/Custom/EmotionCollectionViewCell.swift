//
//  EmotionCollectionViewCell.swift
//  iMirror
//
//  Created by Christopher Endress on 1/23/24.
//

import UIKit

class EmotionCollectionViewCell: UICollectionViewCell {
  
  let emotionImageView = UIImageView()
  let emotionLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureCell()
    setupConstraints()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented.")
  }
  
  private func configureCell() {
    // Configure image view
    emotionImageView.contentMode = .scaleAspectFit
    emotionImageView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(emotionImageView)
    
    // Configure label
    emotionLabel.textAlignment = .center
    emotionLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(emotionLabel)
    
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      emotionImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      emotionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
      emotionImageView.widthAnchor.constraint(equalToConstant: ReuseableUI.padding),
      emotionImageView.heightAnchor.constraint(equalToConstant: ReuseableUI.padding),
      
      emotionLabel.topAnchor.constraint(equalTo: emotionImageView.bottomAnchor, constant: 5),
      emotionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      emotionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      emotionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
    ])
  }
}
