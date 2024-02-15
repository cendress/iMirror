//
//  CustomSettingsCell.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import UIKit

class CustomSettingsCell: UITableViewCell {
  
  let iconBackgroundView = UIView()
  let customImageView = UIImageView()
  let customTextLabel = UILabel()
  let containerView = UIView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.backgroundColor = .clear
    contentView.backgroundColor = UIColor { (traitCollection) -> UIColor in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 0.0, alpha: 1.0)
      default:
        return UIColor(white: 0.95, alpha: 1.0)
      }
    }
    
    setupContainerView()
    setupIconBackgroundView()
    setupCustomImageViewAndLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContainerView() {
    containerView.backgroundColor = .systemBackground
    containerView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(containerView)
    
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
    ])
    
    containerView.layer.cornerRadius = 10
    containerView.clipsToBounds = true
  }
  
  private func setupIconBackgroundView() {
    iconBackgroundView.backgroundColor = UIColor.systemGray5
    iconBackgroundView.layer.cornerRadius = 8
    iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(iconBackgroundView)
    containerView.addSubview(customImageView)
    
    NSLayoutConstraint.activate([
      iconBackgroundView.centerYAnchor.constraint(equalTo: customImageView.centerYAnchor),
      iconBackgroundView.centerXAnchor.constraint(equalTo: customImageView.centerXAnchor),
      iconBackgroundView.heightAnchor.constraint(equalTo: customImageView.heightAnchor),
      iconBackgroundView.widthAnchor.constraint(equalTo: customImageView.widthAnchor)
    ])
    
    customImageView.layer.cornerRadius = 8
    customImageView.clipsToBounds = true
  }
  
  private func setupCustomImageViewAndLabel() {
    customImageView.translatesAutoresizingMaskIntoConstraints = false
    customImageView.layer.cornerRadius = 8
    customImageView.tintColor = .white
    customImageView.clipsToBounds = true
    containerView.addSubview(customImageView)
    
    customTextLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(customTextLabel)
    
    NSLayoutConstraint.activate([
      customImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      customImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      customImageView.heightAnchor.constraint(equalToConstant: 30),
      customImageView.widthAnchor.constraint(equalToConstant: 30),
      
      customTextLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 16),
      customTextLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      customTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
    ])
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
