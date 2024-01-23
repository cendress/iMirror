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
    contentView.layer.cornerRadius = 15
    contentView.backgroundColor = .systemBackground
    contentView.layer.borderWidth = 1.0
    contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 4)
    layer.shadowRadius = 6
    layer.shadowOpacity = 0.15
    layer.masksToBounds = false
    
    // Configure image view
    emotionImageView.contentMode = .scaleAspectFit
    emotionImageView.layer.cornerRadius = 20
    emotionImageView.clipsToBounds = true
    emotionImageView.backgroundColor = UIColor.systemGray6
    emotionImageView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(emotionImageView)
    
    // Configure label
    emotionLabel.textAlignment = .center
    emotionLabel.font = UIFont(name: "Roboto-Regular", size: 14)
    emotionLabel.textColor = UIColor.darkGray
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
