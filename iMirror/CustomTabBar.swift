//
//  CustomTabBar.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class CustomTabBar: UITabBar {
  private var shapeLayer: CAShapeLayer?
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.addShape()
  }
  
  private func addShape() {
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = createPath()
    shapeLayer.strokeColor = UIColor.lightGray.cgColor
    shapeLayer.fillColor = UIColor.white.cgColor
    shapeLayer.lineWidth = 1.0
    shapeLayer.shadowOffset = CGSize(width: 0, height: 2)
    shapeLayer.shadowRadius = 10
    shapeLayer.shadowColor = UIColor.black.cgColor
    shapeLayer.shadowOpacity = 0.5
    
    if let oldShapeLayer = self.shapeLayer {
      self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
    } else {
      self.layer.insertSublayer(shapeLayer, at: 0)
    }
    self.shapeLayer = shapeLayer
  }
  
  func createPath() -> CGPath {
    let height: CGFloat = 30.0
    let path = UIBezierPath()
    let centerWidth = self.frame.width / 2
    
    path.move(to: CGPoint(x: 0, y: 0))
    
    path.addLine(to: CGPoint(x: centerWidth - 50, y: 0))
    
    path.addQuadCurve(to: CGPoint(x: centerWidth + 50, y: 0),
                      controlPoint: CGPoint(x: centerWidth, y: -height))
    
    path.addLine(to: CGPoint(x: self.frame.width, y: 0))
    
    path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
    path.addLine(to: CGPoint(x: 0, y: self.frame.height))
    path.close()
    
    return path.cgPath
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    if shapeLayer?.path?.contains(point) == true {
      return super.hitTest(point, with: event)
    }
    return nil
  }
}



