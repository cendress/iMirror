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
  let shadowView = UIView()
  
  var isToggled = false {
    didSet {
      toggleCell()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureShadowView()
    configureCell()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func toggleCell() {
    if isToggled {
      contentView.backgroundColor = tintColor
      emotionImageView.tintColor = .white
      emotionImageView.backgroundColor = nil
      emotionLabel.textColor = .white
    } else {
      contentView.backgroundColor = .systemBackground
      emotionImageView.backgroundColor = UIColor.systemGray6
      emotionImageView.tintColor = tintColor
      emotionLabel.textColor = UIColor.darkGray
    }
  }
  
  private func configureShadowView() {
    shadowView.layer.shadowColor = UIColor.systemGray.cgColor
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
    shadowView.layer.shadowRadius = 6
    shadowView.layer.shadowOpacity = 0.15
    shadowView.backgroundColor = .clear
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(shadowView)
    sendSubviewToBack(shadowView)
  }
  
  private func configureCell() {
    contentView.layer.cornerRadius = 15
    contentView.layer.borderWidth = 1.0
    contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    contentView.backgroundColor = .systemBackground
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
      shadowView.topAnchor.constraint(equalTo: topAnchor),
      shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
      shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
      shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      emotionImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      emotionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
      emotionImageView.widthAnchor.constraint(equalToConstant: 50),
      emotionImageView.heightAnchor.constraint(equalToConstant: 50),
      
      emotionLabel.topAnchor.constraint(equalTo: emotionImageView.bottomAnchor, constant: 5),
      emotionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      emotionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      emotionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
    ])
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
  }
}
