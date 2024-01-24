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
  let shadowLayer = CALayer()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureCell()
    setupConstraints()
    addShadow()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureCell() {
    contentView.layer.cornerRadius = 15
    contentView.layer.borderWidth = 1.0
    contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    contentView.clipsToBounds = true
    
    emotionImageView.contentMode = .scaleAspectFit
    emotionImageView.layer.cornerRadius = 20
    emotionImageView.clipsToBounds = true
    emotionImageView.backgroundColor = UIColor.systemGray6
    emotionImageView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(emotionImageView)
    
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
      emotionImageView.widthAnchor.constraint(equalToConstant: 50), // Adjust as needed
      emotionImageView.heightAnchor.constraint(equalToConstant: 50), // Adjust as needed
      
      emotionLabel.topAnchor.constraint(equalTo: emotionImageView.bottomAnchor, constant: 5),
      emotionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      emotionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      emotionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
    ])
  }
  
  private func addShadow() {
    shadowLayer.shadowColor = UIColor.black.cgColor
    shadowLayer.shadowOffset = CGSize(width: 0, height: 4)
    shadowLayer.shadowRadius = 6
    shadowLayer.shadowOpacity = 0.15
    shadowLayer.backgroundColor = UIColor.clear.cgColor
    shadowLayer.frame = contentView.frame
    layer.insertSublayer(shadowLayer, at: 0)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    shadowLayer.frame = contentView.frame
  }
}
