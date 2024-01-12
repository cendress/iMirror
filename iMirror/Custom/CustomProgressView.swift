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
  private let sliderKnob = UIView()
  
  var progress: CGFloat = 0 {
    didSet {
      updateSliderPosition()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayers()
    setupSliderKnob()
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupLayers()
    setupSliderKnob()
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
  }
  
  private func setupLayers() {
    trackLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    layer.addSublayer(trackLayer)
    
    progressLayer.colors = [UIColor(named: "AppColor")!]
    progressLayer.startPoint = CGPoint(x: 0, y: 0.5)
    progressLayer.endPoint = CGPoint(x: 1, y: 0.5)
    layer.addSublayer(progressLayer)
  }
  
  private func setupSliderKnob() {
    sliderKnob.backgroundColor = UIColor(named: "AppColor")
    sliderKnob.layer.cornerRadius = 10 // Adjust as needed
    sliderKnob.frame = CGRect(x: 0, y: 0, width: 20, height: 20) // Adjust size as needed
    addSubview(sliderKnob)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let cornerRadius = bounds.size.height / 2
    trackLayer.cornerRadius = cornerRadius
    progressLayer.cornerRadius = cornerRadius
    
    trackLayer.frame = bounds
    progressLayer.frame = CGRect(x: 0, y: 0, width: bounds.width * progress, height: bounds.height)
    
    updateSliderPosition()
  }
  
  private func updateSliderPosition() {
    let sliderPosition = bounds.width * progress - sliderKnob.frame.width / 2
    sliderKnob.center = CGPoint(x: sliderPosition, y: bounds.height / 2)
  }
  
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    let location = gesture.location(in: self)
    let width = bounds.width
    progress = min(max(0, location.x / width), 1)
  }
}
