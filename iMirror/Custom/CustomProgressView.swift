//
//  CustomProgressView.swift
//  iMirror
//
//  Created by Christopher Endress on 1/8/24.
//

import UIKit

class CustomProgressView: UIView {
  private var progressLayer = CAGradientLayer()
  private var trackLayer = CALayer()
  
  var progress: CGFloat = 0 {
    didSet {
      UIView.animate(withDuration: 0.25) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayers()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupLayers()
  }
  
  private func setupLayers() {
    trackLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    layer.addSublayer(trackLayer)
    
    progressLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
    progressLayer.startPoint = CGPoint(x: 0, y: 0.5)
    progressLayer.endPoint = CGPoint(x: 1, y: 0.5)
    layer.addSublayer(progressLayer)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let cornerRadius = bounds.size.height / 2
    trackLayer.cornerRadius = cornerRadius
    progressLayer.cornerRadius = cornerRadius
    
    trackLayer.frame = bounds
    progressLayer.frame = CGRect(x: 0, y: 0, width: bounds.width * progress, height: bounds.height)
  }
}
