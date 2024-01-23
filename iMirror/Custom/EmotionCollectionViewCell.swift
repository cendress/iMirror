//
//  EmotionCollectionViewCell.swift
//  iMirror
//
//  Created by Christopher Endress on 1/23/24.
//

import UIKit

class EmotionCollectionViewCell: UICollectionViewCell {
    
  private let emotionImage = UILabel()
  private let emotionText = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented.")
  }
}
