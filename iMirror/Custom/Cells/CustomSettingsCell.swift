//
//  CustomSettingsCell.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import UIKit

class CustomSettingsCell: UITableViewCell {
  
  let iconBackgroundView = UIView()
  let shadowContainerView = UIView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupIconBackgroundView()
    setupShadowContainerView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupIconBackgroundView() {
    guard let imageView = self.imageView else { return }
    
    iconBackgroundView.backgroundColor = UIColor.systemGray5
    iconBackgroundView.layer.cornerRadius = 8
    iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    // Ensure the background view goes behind the image in the cell
    self.contentView.insertSubview(iconBackgroundView, belowSubview: imageView)
    
    NSLayoutConstraint.activate([
      iconBackgroundView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
      iconBackgroundView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
      iconBackgroundView.heightAnchor.constraint(equalTo: imageView.heightAnchor),
      iconBackgroundView.widthAnchor.constraint(equalTo: imageView.widthAnchor)
    ])
    
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
  }
  
  private func setupShadowContainerView() {
    shadowContainerView.backgroundColor = .white
    shadowContainerView.layer.cornerRadius = 10
    shadowContainerView.layer.shadowColor = UIColor.black.cgColor
    shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    shadowContainerView.layer.shadowRadius = 3
    shadowContainerView.layer.shadowOpacity = 0.3
    shadowContainerView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(shadowContainerView)
    contentView.sendSubviewToBack(shadowContainerView)
    
    NSLayoutConstraint.activate([
      shadowContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
      shadowContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
      shadowContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      shadowContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
    ])
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let cellSpacing: CGFloat = 16
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing))
    
    contentView.layer.cornerRadius = 10
    contentView.layer.masksToBounds = true
  }
}
