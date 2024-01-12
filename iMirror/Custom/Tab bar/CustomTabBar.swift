//
//  CustomTabBar.swift
//  iMirror
//
//  Created by Christopher Endress on 1/3/24.
//

import UIKit

class CustomTabBar: UITabBar {
  private var shapeLayer: CAShapeLayer?
  
  private let extraHeight: CGFloat = 30.0
  private let curveHeight: CGFloat = 60.0
  private let curveWidth: CGFloat = 70.0
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    var sizeThatFits = super.sizeThatFits(size)
    sizeThatFits.height += extraHeight
    return sizeThatFits
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    addShape()
  }
  
  private func addShape() {
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = createPath()
    configureShapeLayer(shapeLayer)
    replaceOldShapeLayer(with: shapeLayer)
  }
  
  private func configureShapeLayer(_ layer: CAShapeLayer) {
    layer.strokeColor = UIColor.systemBackground.cgColor
    layer.fillColor = UIColor.systemBackground.cgColor
    layer.lineWidth = 1.0
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 10
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
  }
  
  private func replaceOldShapeLayer(with newLayer: CAShapeLayer) {
    if let oldShapeLayer = self.shapeLayer {
      self.layer.replaceSublayer(oldShapeLayer, with: newLayer)
    } else {
      self.layer.insertSublayer(newLayer, at: 0)
    }
    self.shapeLayer = newLayer
  }
  
  func createPath() -> CGPath {
    let path = UIBezierPath()
    let screenWidth = UIScreen.main.bounds.width
    let centerWidth = screenWidth / 2
    
    path.move(to: CGPoint(x: 0, y: extraHeight))
    
    let leftCurveStart = CGPoint(x: centerWidth - curveWidth, y: extraHeight)
    let controlPoint1 = CGPoint(x: centerWidth - curveWidth / 2, y: extraHeight - curveHeight)
    let controlPoint2 = CGPoint(x: centerWidth + curveWidth / 2, y: extraHeight - curveHeight)
    let rightCurveEnd = CGPoint(x: centerWidth + curveWidth, y: extraHeight)
    
    path.addLine(to: leftCurveStart)
    path.addCurve(to: rightCurveEnd, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    path.addLine(to: CGPoint(x: screenWidth, y: extraHeight))
    path.addLine(to: CGPoint(x: screenWidth, y: self.frame.height))
    path.addLine(to: CGPoint(x: 0, y: self.frame.height))
    path.close()
    
    return path.cgPath
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let path = shapeLayer?.path, self.bounds.contains(point) else {
      return nil
    }
    return path.contains(point) ? super.hitTest(point, with: event) : nil
  }
}
