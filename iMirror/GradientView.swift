//
//  GradientView.swift
//  iMirror
//
//  Created by Christopher Endress on 1/7/24.
//

import UIKit

class GradientView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupGradient()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupGradient()
  }
  
  private func setupGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
    //Top left corner
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    //Bottom right corner
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    gradientLayer.frame = bounds
    layer.insertSublayer(gradientLayer, at: 0)
  }
}

