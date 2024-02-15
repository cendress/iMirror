//
//  CustomSettingsCell.swift
//  iMirror
//
//  Created by Christopher Endress on 2/15/24.
//

import UIKit

class CustomSettingsCell: UITableViewCell {
  
  let iconBackgroundView = UIView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupIconBackgroundView()
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
}
