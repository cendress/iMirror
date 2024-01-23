//
//  EmotionCollectionViewCell.swift
//  iMirror
//
//  Created by Christopher Endress on 1/23/24.
//

import UIKit

class EmotionCollectionViewCell: UICollectionViewCell {
    
  private let emotionImageView = UIImageView()
  private let emotionLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureCell()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented.")
  }
  
  private func configureCell() {
    
  }
}
